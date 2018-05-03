`timescale 1ns/1ps
//ped_1         = 8X4  
//error_1          = 8x4  
//sign_buffer_1 = 8x4
// 
//ped_2         = zeros(16,1,Data); 
//error_2          = zeros(16,1,Data); 
//sign_buffer_2 = zeros(16,2,Data);
//sign_2        = zeros(16,2,Data); 
//ped_sort_2    = zeros(16,1,Data); 
//index_2       = zeros(16,1,Data);
//

module layer78(clk,rstn,y8,y7,R88,R78,R77,ped_2,sign_2_1,sign_2_2);
//////////////////////////////////////////從R77後面是output
input clk,rstn;
input signed[11:0]y8,y7,R88,R78,R77;
reg  signed[11:0]s8,s7;
reg  signed[11:0]stotal[0:1];
reg  signed[11:0]s8f[0:3];
reg  signed[11:0]s7f[0:31];

reg  signed[11:0]error_1[0:3];
reg  signed[11:0]ped_1[0:3];// error x error 不知道要不要多億點記憶體然後移位算真的ped
reg  signed[11:0]ped_reg_1[0:3];
reg  signed[11:0]sign_buffer_1[0:3];

reg  signed[11:0]error_2[0:15];
reg  signed[11:0]sign_buffer_2_1[0:15];//
reg  signed[11:0]sign_buffer_2_2[0:15];

reg  [11:0]ped_2_reg[0:15];//下一層會用到
reg  [11:0]sign_2_1_reg[0:15];//存s8跟s7的值
reg  [11:0]sign_2_2_reg[0:15];
output reg [191:0]ped_2;
output reg [191:0]sign_2_1;
output reg [191:0]sign_2_2;

reg [4:0]i;

reg  signed[11:0]temp[0:15];
reg  [3:0]temp1[0:15];
reg  [3:0]index_2[0:15];
reg [3:0]n;
reg [4:0]j;
 //////////////////

///////////////////
// 初始     
    //s1-s8是最開始的點 不在星座點上
always @ (posedge clk or negedge rstn) begin
	
	if(~rstn)  begin 
		s8<=12'b0;
		s7<=12'b0;
		for(i=0;i<8;i=i+1)begin
		stotal[i]<=12'b0;
		end
		for(i=0;i<4;i=i+1)begin
		s8f[i]<=12'b0;
		end
		for(i=0;i<32;i=i+1)begin
		s7f[i]<=12'b0;
		end
		for(i=0;i<16;i=i+1)begin
		index_2[i]=i;
		end
		
	end
	
	else 
	begin
     	s8 = div(y8,R88);//算每一個s8的值
	 
     	s7 = div( (y7- mul(R78,s8)),R77) ;//算每一個s7的值

		stotal[0] <= s8;//
     	stotal[1] <= s7;
		
		{s8f[3],s8f[2],s8f[1],s8f[0]} = eli(stotal[0]);
		//範圍重取且排續
		
		for(i=0;i<8;i=i+1'b1)
		begin
     		{s7f[4*i+3],s7f[4*i+2],s7f[4*i+1],s7f[4*i]} = eli(stotal[1]);
		end
		
		for(n=0;n<4;n=n+1'b1)
		begin
    	error_1[n] = y8 - mul( s8f[n],R88 );
		ped_1[n] = mul(error_1[n] , error_1[n]);
		sign_buffer_1[n] = s8f[n];//這裡有可能接太多條線
		end
		
		
		for(n=0;n<4;n=n+1'b1)
		begin
		ped_reg_1 [n] = ped_1[n];//看要不要去掉
			
			//算error
			for(i=0;i<4;i=i+1'b1)
			begin
      			error_2[4*(n)+i] = y7-mul(s7f[n] ,R77 ); 
	 		end
			
			//ped_2
			for(i=0;i<4;i=i+1'b1)
			begin                  
      			ped_2_reg[4*(n)+i]   = ped_reg_1[n]+ mul( error_2[4*(n)+i], error_2[4*(n)+i]);
	  		end
			
			//s7
			for(i=0;i<4;i=i+1'b1)
			begin 
      			sign_buffer_2_1[4*(n)+i]   = s7f[4*(n)+i];
	  		end
			//s8
			for(i=0;i<4;i=i+1'b1)
			begin
      			sign_buffer_2_2[4*(n)+i]   = sign_buffer_1[n];
	  		end		
		end
		
		//sort ped2
		for(i=0;i<16;i=i+1'b1)
		begin	
			for(j=i+1'b1;j<16;j=j+1'b1)//17->16
		    if(ped_2_reg[j]<ped_2_reg[i])
			begin
			temp[i]	=	ped_2_reg[i];
			ped_2_reg[i]	=	ped_2_reg[j];
			ped_2_reg[j]	=	temp[i];
			temp1[i]	=	index_2[i];
			index_2[i]	=	index_2[j];
			index_2[j]	=	temp1[i];
			end

		end
		
		//sort s8 s7
		for(i=0;i<16;i=i+1'b1)
		begin
    	sign_2_1_reg[i] = sign_buffer_2_1[ index_2[i] ];//把前面的s7值排序
		sign_2_2_reg[i] = sign_buffer_2_2[ index_2[i] ];//把前面的s8值排序
		end
	
		
	
		
		//轉一維
		for(i=0;i<16;i=i+1'b1)
		begin
		ped_2[12*i+:12]<=ped_2_reg[i];
		sign_2_1[12*i+:12]<=sign_2_1_reg[i];
		sign_2_2[12*i+:12]<=sign_2_2_reg[i];
		end
	end


end

////////////////////////////////////////////結合式列舉CE
	function [47:0]eli;
	input signed[11:0]x;
    reg signed[11:0]s8f[0:3];
	parameter signed sqrt_42   = 12'b0_110_0111_1011 ;//6.4807406984
	parameter signed sqrt_42_7 = 12'b0_001_0001_0100 ;//1.080123449
	parameter signed sqrt_42_6 = 12'b0_000_1110_1101 ;//0.925800998
	parameter signed sqrt_42_5 = 12'b0_000_1100_0101 ;//
	parameter signed sqrt_42_4 = 12'b0_000_1001_1110 ;//
	parameter signed sqrt_42_3 = 12'b0_000_0110_0110 ;//
	parameter signed sqrt_42_2 = 12'b0_000_0100_1111 ;//
	parameter signed sqrt_42_1 = 12'b0_000_0010_0111 ;//
	           
	parameter signed sqrt_42_m   = 	    12'b1_001_1000_0101;//負數軸
	parameter signed sqrt_42_7_m =  	12'b1_110_1110_1100;
	parameter signed sqrt_42_6_m =  	12'b1_111_0001_0011;
	parameter signed sqrt_42_5_m =  	12'b1_111_0011_1011;
	parameter signed sqrt_42_4_m =  	12'b1_111_0110_0010;
	parameter signed sqrt_42_3_m =  	12'b1_111_1101_1001;
	parameter signed sqrt_42_2_m =  	12'b1_111_1011_0001;
	parameter signed sqrt_42_1_m =  	12'b1_111_1101_1001;
              
    begin
		
        if(sqrt_42_6 < x)
		begin
            s8f[0]=sqrt_42_7;
            s8f[1]=sqrt_42_5;
            s8f[2]=sqrt_42_3;
            s8f[3]=sqrt_42_1; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
		
        else if(sqrt_42_5<=x && x<sqrt_42_6)
		begin   
            s8f[0]=sqrt_42_5;
            s8f[1]=sqrt_42_7;
            s8f[2]=sqrt_42_3;
            s8f[3]=sqrt_42_1;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
		
        else if(sqrt_42_4<=x && x<sqrt_42_5) 
		begin  
            s8f[0]=sqrt_42_5;
            s8f[1]=sqrt_42_3;
            s8f[2]=sqrt_42_7;
            s8f[3]=sqrt_42_1; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end		
		
        else if(sqrt_42_3<=x && x<sqrt_42_4)
		begin
            s8f[0]=sqrt_42_3;
            s8f[1]=sqrt_42_5;
            s8f[2]=sqrt_42_1;
            s8f[3]=sqrt_42_7;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(sqrt_42_2<=x && x<sqrt_42_3)
		begin
            s8f[0]=sqrt_42_3;
            s8f[1]=sqrt_42_1;
            s8f[2]=sqrt_42_5;
            s8f[3]=sqrt_42_1_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(sqrt_42_1<=x && x<sqrt_42_2)
		begin    
            s8f[0]=sqrt_42_1;
            s8f[1]=sqrt_42_3;
            s8f[2]=sqrt_42_1_m;
            s8f[3]=sqrt_42_5; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(0<=x && x<sqrt_42_1) 
		begin    
            s8f[0]=sqrt_42_1;
            s8f[1]=sqrt_42_1_m;
            s8f[2]=sqrt_42_3;
            s8f[3]=sqrt_42_3_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
		
        else if(sqrt_42_1_m<=x && x<0) 
		begin    
            s8f[0]=sqrt_42_1_m;
            s8f[1]=sqrt_42_1;
            s8f[2]=sqrt_42_3_m;
            s8f[3]=sqrt_42_3; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(x<=sqrt_42_1_m && x>sqrt_42_2_m) 
		begin    
            s8f[0]=sqrt_42_1_m;
            s8f[1]=sqrt_42_3_m;
            s8f[2]=sqrt_42_1;
            s8f[3]=sqrt_42_5_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(x<=sqrt_42_2_m && x>sqrt_42_3_m) 
		begin      
            s8f[0]=sqrt_42_3_m;
            s8f[1]=sqrt_42_1_m;
            s8f[2]=sqrt_42_5_m;
            s8f[3]=sqrt_42_1; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
        end			
        else if(x<=sqrt_42_3_m && x>sqrt_42_4_m)  
		begin 
            s8f[0]=sqrt_42_3_m;
            s8f[1]=sqrt_42_5_m;
            s8f[2]=sqrt_42_1_m;
            s8f[3]=sqrt_42_7_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(x<=sqrt_42_4_m && x>sqrt_42_5_m)
		begin    
            s8f[0]=sqrt_42_5_m;
            s8f[1]=sqrt_42_3_m;
            s8f[2]=sqrt_42_7_m;
            s8f[3]=sqrt_42_1_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(x<=sqrt_42_5_m && x>sqrt_42_6_m)   
		begin  
            s8f[0]=sqrt_42_5_m;
            s8f[1]=sqrt_42_7_m;
            s8f[2]=sqrt_42_3_m;
            s8f[3]=sqrt_42_1_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(x<sqrt_42_6_m)  
		begin   
            s8f[0]=sqrt_42_7_m;
            s8f[1]=sqrt_42_5_m;
            s8f[2]=sqrt_42_3_m;
            s8f[3]=sqrt_42_1_m; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};			
		end			
        else 
		begin
		s8f[0] = s8f[0];
		s8f[1] = s8f[1];
		s8f[2] = s8f[2];
		s8f[3] = s8f[3];
        eli = eli;
		end
    end
	
endfunction
/////////////////////////////////////////////

/////////////////////////////////////////////
function [11:0]mul;
input [11:0]a,b;
reg [21:0]ab;
reg [21:0]mul_reg;
//取最後11:0bit
begin

if(a[11]==1'b0&& b[11]==1'b0)begin
		ab = a[10:0]*b[10:0];
		mul_reg = ab>>8;
		mul ={1'b0, mul_reg[10:0]};
	end
	else if(a[11]==1'b0&& b[11]==1'b1)begin
		b = ~(b - 1'b1);
		ab = a[10:0]*b[10:0];
		mul_reg = ab>>8;
		mul = ~{1'b0, mul_reg[10:0]}+1'b1;
	end
	else if(a[11]==1'b1&& b[11]==1'b0)begin
		a = ~(a - 1'b1);
		ab = a[10:0]*b[10:0];//正數相家
		mul_reg = ab>>8;
		mul = ~{1'b0, mul_reg[10:0]}+1'b1;
	end
	else if(a[11]==1'b1&& b[11]==1'b1)begin
		a = ~(a - 1'b1);
		b = ~(b - 1'b1);
		ab = a[10:0]*b[10:0];
		mul_reg = ab>>8;
		mul ={1'b0, mul_reg[10:0]};
	end

end
endfunction


/////////////////////////////////////////////
function [11:0]div;
input [11:0]c,d;
reg [10:0]c_div_d;

//取最後11:0dit
begin

if(c[11]==1'd0&& d[11]==1'd0)
    begin
		c_div_d = c[10:0]/d[10:0];
		div ={1'd0, c_div_d [10:0]};
	end
	else if(c[11]==1'd0&& d[11]==1'd1)
	begin
		d = ~(d - 1'd1);
		c_div_d = c[10:0]/d[10:0];
		div = ~{1'd0, c_div_d [10:0]}+1'd1;
	end
	else if(c[11]==1'd1&& d[11]==1'd0)
	begin
		c = ~(c - 1'd1);
		c_div_d = c[10:0]/d[10:0];//正數相家
		div = ~{1'd0, c_div_d [10:0]}+1'd1;
	end
	else if(c[11]==1'd1&& d[11]==1'd1)
	begin
		c = ~(c - 1'd1);
		d = ~(d - 1'd1);
		c_div_d = c[10:0]/d[10:0];
		div ={1'd0, c_div_d [10:0]};
	end

end
endfunction
////////////////////////////////////////////

endmodule
