`timescale 1ns/1ps

module layer56(clk,rstn,y6,y5,R68,R67,R66,R58,R56,R55,ped_2,sign_2_1,sign_2_2);

input clk,rstn;
input reg  signed[11:0]y6,y5,R68,R67,R66,R58,R56,R55;
input reg [191:0]ped_2;
input reg [191:0]sign_2_1;
input reg [191:0]sign_2_2;
reg  [11:0]ped_2_reg[0:15];//下一層會用到
reg  [11:0]sign_2_1_reg[0:15];//存s8跟s7的值
reg  [11:0]sign_2_2_reg[0:15];
reg [11:0]a_3[0:7];
reg [11:0]b_3[0:7];
reg [11:0]a_4[0:7];
reg [11:0]b_4[0:7];
reg [11:0]L_error_3[0:7];
reg [11:0]sign_pp_3[0:59];
reg [11:0]sign_pp_3_reg[0:59];
reg [11:0]L_error_4[0:7];
reg [11:0]sign_pp_4[0:59];
reg [11:0]sign_pp_4_reg[0:59];



reg

always @ (posedge clk or negedge rstn) begin
	
    for (n=0;n<8;n=n+1'b1)begin
        a_3[n] = sign_2_1[n]*R67; //R67*s7
		//n===========n 下面以此類推
        b_3[n] = sign_2_2[n]*R68; //R68*s8
        a_4[n] = sign_2_1[n]*R57; //R57*s7
        b_4[n] = sign_2_2[n]*R58; //R58*s8    

        L_error_3[n] = y6 - (a_3[n]+ b_3[n]);
        //s3跟
		
		//diff我要想一夏
		//for(i=0;i<8;i=1'b1)begin
        //這樣不太好sign_pp_3[8*(n)+i] = diff_64(L_error_3[n],R66);//輸出八個數字
		//可能要寫成
		{sign_pp_3[8*(n)+7],sign_pp_3[8*(n)+6],sign_pp_3[8*(n)+5],sign_pp_3[8*(n)+4],
		sign_pp_3[8*(n)+3],sign_pp_3[8*(n)+2],sign_pp_3[8*(n)+1],sign_pp_3[8*(n)+0]}=diff_64(L_error_3[n],R66);
		//sign_pp_3[8*(n)+i]這樣沒辦法一次接8個數字
		//所以for迴圈		for(i=0;i<8;i=1'b1)begin也不需要了
		//end
		//....
		//8*(n-1)+1:8*n===================n
		//...
		
        ////排error值
		//				1:4
		for(i=0;i<4;i=i+1'b1)begin
        sign_pp_3_reg[i]= sign_pp_3[8*(n)+i];
		end
		//....
		//sign_pp_3_reg(1,1:4,k) = sign_pp_3(1,8*(n-1)+1:8*n-4,k);
		//	====================8*(n-1)+1:8*n-4
		//....
        
        L_error_4[n] = y5 - (a_4[n] +  b_4[n]);
        ////s4跟
		
		{sign_pp_4[8*(n)+7],sign_pp_4[8*(n)+6],sign_pp_4[8*(n)+5],sign_pp_4[8*(n)+4],
		sign_pp_4[8*(n)+3],sign_pp_4[8*(n)+2],sign_pp_4[8*(n)+1],sign_pp_4[8*(n)+0]}=diff_64(L_error_4[n],R55);
		//....
		//8*(n-1)+1:8*n================
		//....
		
        ////排error值
		
		for(i=0;i<4;i=i+1'b1)begin
		sign_pp_4_reg[i]= sign_pp_4[8*(n)+i];
		end
		//....sign_pp_4_reg(1,1:4,k) = sign_pp_4(1,8*(n-1)+1:8*n-4,k);
		//============8*(n-1)+1:8*n-4
		//....
        ////拿前面算過的ped值來配對error值 總共8個 跟四個不同情況算
		
        //ped_reg_2[n] = ped_sort_2[n];//就是已經排過的ped2
		ped_reg_2[n] = ped_2[n];
        
     if(n==0||n==1)begin
     for (m=0;m<4;m=m+1'b1)begin
        // //for迴圈裡面算都異樣 
			for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_3_1[4*m+i] = sign_pp_4_reg[m];
			sign_buffer_3_2[4*m+i] = sign_pp_3_reg[i];
			
			error_3[4*m+i]=y6-
			(sign_buffer_3_2[4*m+i]*R66+
			a_3[n]+b_3[n]);
			
			error_4[4*m+i]=y5-
			(sign_buffer_3_1[4*m+i]*R55+
			a_3[n]+b_3[n]);
		
			ped_3[4*m+i] 
			= ped_reg_2
			+ error_3[4*m+i]*error_3[4*m+i]
			+ error_4[4*m+i]*error_4[4*m+i];
			end
			//error_3[4*(m-1)+1~4*m]=y61-(sign_buffer_3_2[4*(m-1)+1:4*m]*R66+a_3[n-1]+b_3[n-1]);
                                            
        //ped_3[4*(m-1)+1~4*m] = ped_reg_2//(這是常數)
								//+ error_3[4*(m-1)+1~4*m].*error_3[4*(m-1)+1~4*m]+error_4[4*(m-1)+1~4*m].*error_4[4*(m-1)+1~4*m];
     end
	 
	 //sort
      //[ped_sort_3(1:16,1,k),index_3(1:16,1,k)] = sort(ped_3(1:16,1,k));    
	  for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_3[j]<ped_3[i])begin
			temp[i]	=	ped_3[i];
			ped_3[i]	=	ped_3[np];
			ped_3[np]	=	temp[i];
			temp1[i]	=	index_3[i];
			index_3[i]	=	index_3[np];
			index_3[np]	=	temp1[i];
			end
			
		end
		end
		
		//sign3
      for(i=0;i<16;i=i+1'b1)begin
	  sign_3_1[i] = sign_buffer_3_1[index_3[i]];   
	  sign_3_2[i] = sign_buffer_3_2[index_3[i]];  
      sign_3_3[i] = sign_2_1[n]; 
      sign_3_4[i] = sign_2_2[n]; 
	  end
	  
	  //sign4//1~8 9~17
      for(i=0;i<8;i=i+1'b1)begin
      ped_4[8*n+i] = ped_sort_3[i];
	  sign_buffer_4_1[8*n+i] = sign_3_1[i];
      sign_buffer_4_2[8*n+i] = sign_3_2[i];
      sign_buffer_4_3[8*n+i] = sign_3_3[i];
      sign_buffer_4_4[8*n+i] = sign_3_4[i];
      end
      
	 end
      
     else if(n==2||n==3)begin
     for (m=0;m<4;m=m+1'b1)begin
        // //for迴圈裡面算都異樣 
			for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_3_1[4*m+i] = sign_pp_4_reg[m];
			sign_buffer_3_2[4*m+i] = sign_pp_3_reg[i];
			
			error_3[4*m+i]=y6-
			(sign_buffer_3_2[4*m+i]*R66+
			a_3[n]+b_3[n]);
			
			error_4[4*m+i]=y5-
			(sign_buffer_3_1[4*m+i]*R55+
			a_3[n]+b_3[n]);
		
			ped_3[4*m+i] 
			= ped_reg_2
			+ error_3[4*m+i]*error_3[4*m+i]
			+ error_4[4*m+i]*error_4[4*m+i];
			end
			//error_3[4*(m-1)+1~4*m]=y61-(sign_buffer_3_2[4*(m-1)+1:4*m]*R66+a_3[n-1]+b_3[n-1]);
                                            
        //ped_3[4*(m-1)+1~4*m] = ped_reg_2//(這是常數)
								//+ error_3[4*(m-1)+1~4*m].*error_3[4*(m-1)+1~4*m]+error_4[4*(m-1)+1~4*m].*error_4[4*(m-1)+1~4*m];
     end
	 
	 //
      //[ped_sort_3(1:16,1,k),index_3(1:16,1,k)] = sort(ped_3(1:16,1,k));    
	  for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_3[j]<ped_3[i])begin
			temp[i]	=	ped_3[i];
			ped_3[i]	=	ped_3[np];
			ped_3[np]	=	temp[i];
			temp1[i]	=	index_3[i];
			index_3[i]	=	index_3[np];
			index_3[np]	=	temp1[i];
			end
			
		end
		end
		
		
      for(i=0;i<16;i=i+1'b1)begin
	  sign_3_1[i] = sign_buffer_3_1[index_3[i]];   
	  sign_3_2[i] = sign_buffer_3_2[index_3[i]];  
      sign_3_3[i] = sign_2_1[n]; 
      sign_3_4[i] = sign_2_2[n]; 
	  end
	  
	  
      for(i=0;i<6;i=i+1'b1)begin
      ped_4[6*n+i+4] = ped_sort_3[i];//5~10vs0~5
      
      sign_buffer_4_1[i+6*n] = sign_3_1[i];
      sign_buffer_4_2[i+6*n] = sign_3_2[i];
      sign_buffer_4_3[i+6*n] = sign_3_3[i];
      sign_buffer_4_4[i+6*n] = sign_3_4[i];
       end
	end
	
	
     else if(n==4||n==5)begin
     for (m=0;m<4;m=m+1'b1)begin
        // //for迴圈裡面算都異樣 
			for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_3_1[4*m+i] = sign_pp_4_reg[m];
			sign_buffer_3_2[4*m+i] = sign_pp_3_reg[i];
			
			error_3[4*m+i]=y6-
			(sign_buffer_3_2[4*m+i]*R66+
			a_3[n]+b_3[n]);
			
			error_4[4*m+i]=y5-
			(sign_buffer_3_1[4*m+i]*R55+
			a_3[n]+b_3[n]);
			
			
			ped_3[4*m+i] 
			= ped_reg_2
			+ error_3[4*m+i]*error_3[4*m+i]
			+ error_4[4*m+i]*error_4[4*m+i];
			end
			//error_3[4*(m-1)+1~4*m]=y61-(sign_buffer_3_2[4*(m-1)+1:4*m]*R66+a_3[n-1]+b_3[n-1]);
                                            
        //ped_3[4*(m-1)+1~4*m] = ped_reg_2//(這是常數)
								//+ error_3[4*(m-1)+1~4*m].*error_3[4*(m-1)+1~4*m]+error_4[4*(m-1)+1~4*m].*error_4[4*(m-1)+1~4*m];
     end
	 
	 //
      //[ped_sort_3(1:16,1,k),index_3(1:16,1,k)] = sort(ped_3(1:16,1,k));    
	  for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_3[j]<ped_3[i])begin
			temp[i]	=	ped_3[i];
			ped_3[i]	=	ped_3[np];
			ped_3[np]	=	temp[i];
			temp1[i]	=	index_3[i];
			index_3[i]	=	index_3[np];
			index_3[np]	=	temp1[i];
			end
			
		end
		end
		
		
      for(i=0;i<16;i=i+1'b1)begin
	  sign_3_1[i] = sign_buffer_3_1[index_3[i]];   
	  sign_3_2[i] = sign_buffer_3_2[index_3[i]];  
      sign_3_3[i] = sign_2_1[n]; 
      sign_3_4[i] = sign_2_2[n]; 
	  end
	  
	  
      for(i=0;i<4;i=i+1'b1)begin
      ped_4[12+4*n+i] = ped_sort_3[i];//13~16vs0~3
      
      sign_buffer_4_1[i+12+4*n] = sign_3_1[i];
      sign_buffer_4_2[i+12+4*n] = sign_3_2[i];
      sign_buffer_4_3[i+12+4*n] = sign_3_3[i];
      sign_buffer_4_4[i+12+4*n] = sign_3_4[i];
	  end
	  end
                  
     else if(n==6||n==7)begin
     for (m=0;m<4;m=m+1'b1)begin
        // //for迴圈裡面算都異樣 
			for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_3_1[4*m+i] = sign_pp_4_reg[m];
			sign_buffer_3_2[4*m+i] = sign_pp_3_reg[i];
			
			error_3[4*m+i]=y6-
			(sign_buffer_3_2[4*m+i]*R66+
			a_3[n]+b_3[n]);
			
			error_4[4*m+i]=y5-
			(sign_buffer_3_1[4*m+i]*R55+
			a_3[n]+b_3[n]);
		
			ped_3[4*m+i] 
			= ped_reg_2
			+ error_3[4*m+i]*error_3[4*m+i]
			+ error_4[4*m+i]*error_4[4*m+i];
			end
			//error_3[4*(m-1)+1~4*m]=y61-(sign_buffer_3_2[4*(m-1)+1:4*m]*R66+a_3[n-1]+b_3[n-1]);
                     // error_4(4*(m-1)+1:4*m,1,k) = [y(5,1,k),y(5,1,k),y(5,1,k),y(5,1,k)]...
       //                          - ((sign_buffer_3(4*(m-1)+1:4*m,1,k)*R(5,5,k))'+[a_4,a_4,a_4,a_4]+[b_4,b_4,b_4,b_4]);
     //                       
        //ped_3[4*(m-1)+1~4*m] = ped_reg_2//(這是常數)
								//+ error_3[4*(m-1)+1~4*m].*error_3[4*(m-1)+1~4*m]+error_4[4*(m-1)+1~4*m].*error_4[4*(m-1)+1~4*m];
     end
	 
	 //
      //[ped_sort_3(1:16,1,k),index_3(1:16,1,k)] = sort(ped_3(1:16,1,k));    
	  for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_3[j]<ped_3[i])begin
			temp[i]	=	ped_3[i];
			ped_3[i]	=	ped_3[np];
			ped_3[np]	=	temp[i];
			temp1[i]	=	index_3[i];
			index_3[i]	=	index_3[np];
			index_3[np]	=	temp1[i];
			end
			
		end
		end
		
		
     for(i=0;i<16;i=i+1'b1)begin
	  sign_3_1[i] = sign_buffer_3_1[index_3[i]];   
	  sign_3_2[i] = sign_buffer_3_2[index_3[i]];  
      sign_3_3[i] = sign_2_1[n]; 
      sign_3_4[i] = sign_2_2[n]; 
	  end
	  
	  
      for(i=0;i<2;i=i+1'b1)begin
      ped_4[24+2*n+i] = ped_sort_3[i];//26~25vs0:1
      
      sign_buffer_4_1[24+2*n+i] = sign_3_1[i];
      sign_buffer_4_2[24+2*n+i] = sign_3_2[i];
      sign_buffer_4_3[24+2*n+i] = sign_3_3[i];
      sign_buffer_4_4[24+2*n+i] = sign_3_4[i];
                       
     end
	 end
	///pedsort start
	
	end
	
	
    for(i=0;i<40;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_4[j]<ped_4[i])begin
			temp[i]	=	ped_4[i];
			ped_4[i]	=	ped_4[np];
			ped_4[np]	=	temp[i];
			temp1[i]	=	index_4[i];
			index_4[i]	=	index_4[np];
			index_4[np]	=	temp1[i];
			end
			
		end
		end
	
	//感覺可以不要sort這麼多 因為下面的都沒有用到n=8以後的//好像不行 不知道那個最小
	for(i=0;i<40;i=i+1'b1)begin
    sign_4_1[i] = sign_buffer_4_1[index_4[i]];//
	sign_4_2[i] = sign_buffer_4_2[index_4[i]];
	sign_4_3[i] = sign_buffer_4_3[index_4[i]];
	sign_4_4[i] = sign_buffer_4_4[index_4[i]];
	end      
	end
	
endmodule