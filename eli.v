module eli();
function [47:0]eli;
	input reg signed[11:0]x;
    	reg signed[11:0]s8f[0:3];
	parameter signed sqrt_42 =	12'b0_110_0111_1011;//6.4807406984
	parameter signed sqrt_42_7 = 12'b0_001_0001_0100 ;//1.080123449
	parameter signed sqrt_42_6 = 12'b0_000_1110_1101 ;//0.925800998
	parameter signed sqrt_42_5 = 12'b0_000_1100_0101 ;//
	parameter signed sqrt_42_4 = 12'b0_000_1001_1110 ;//
	parameter signed sqrt_42_3 = 12'b0_000_0110_0110 ;//
	parameter signed sqrt_42_2 = 12'b0_000_0100_1111 ;//
	parameter signed sqrt_42_1 = 12'b0_000_0010_0111 ;//
	           
	parameter signed sqrt_42_m = 	12'b1_001_1000_0101;
	parameter signed sqrt_42_7_m =  	12'b1_110_1110_1100;
	parameter signed sqrt_42_6_m =  	12'b1_111_0001_0011;
	parameter signed sqrt_42_5_m =  	12'b1_111_0011_1011;
	parameter signed sqrt_42_4_m =  	12'b1_111_0110_0010;
	parameter signed sqrt_42_3_m =  	12'b1_111_1101_1001;
	parameter signed sqrt_42_2_m =  	12'b1_111_1011_0001;
	parameter signed sqrt_42_1_m =  	12'b1_111_1101_1001;
              
    begin
		
        if(sqrt_42_6 < x)begin
            s8f[0]=sqrt_42_7;
            s8f[1]=sqrt_42_5;
            s8f[2]=sqrt_42_3;
            s8f[3]=sqrt_42_1; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
		
        else if(sqrt_42_5<=x && x<sqrt_42_6)begin   
            s8f[0]=sqrt_42_5;
            s8f[1]=sqrt_42_7;
            s8f[2]=sqrt_42_3;
            s8f[3]=sqrt_42_1;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
		
        else if(sqrt_42_4<=x && x<sqrt_42_5) begin  
            s8f[0]=sqrt_42_5;
            s8f[1]=sqrt_42_3;
            s8f[2]=sqrt_42_7;
            s8f[3]=sqrt_42_1; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end		
		
        else if(sqrt_42_3<=x && x<sqrt_42_4)begin
            s8f[0]=sqrt_42_3;
            s8f[1]=sqrt_42_5;
            s8f[2]=sqrt_42_1;
            s8f[3]=sqrt_42_7;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(sqrt_42_2<=x && x<sqrt_42_3)begin
            s8f[0]=sqrt_42_3;
            s8f[1]=sqrt_42_1;
            s8f[2]=sqrt_42_5;
            s8f[3]=sqrt_42_1_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
		end
        else if(sqrt_42_1<=x && x<sqrt_42_2)begin    
            s8f[0]=sqrt_42_1;
            s8f[1]=sqrt_42_3;
            s8f[2]=sqrt_42_1_m;
            s8f[3]=sqrt_42_5; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
				end
        else if(0<=x && x<sqrt_42_1) begin    
            s8f[0]=sqrt_42_1;
            s8f[1]=sqrt_42_1_m;
            s8f[2]=sqrt_42_3;
            s8f[3]=sqrt_42_3_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
			end
		
        else if(sqrt_42_1_m<=x && x<0) begin    
            s8f[0]=sqrt_42_1_m;
            s8f[1]=sqrt_42_1;
            s8f[2]=sqrt_42_3_m;
            s8f[3]=sqrt_42_3; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
			end
        else if(x<=sqrt_42_1_m && x>sqrt_42_2_m) begin    
            s8f[0]=sqrt_42_1_m;
            s8f[1]=sqrt_42_3_m;
            s8f[2]=sqrt_42_1;
            s8f[3]=sqrt_42_5_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
			end
        else if(x<=sqrt_42_2_m && x>sqrt_42_3_m) begin      
            s8f[0]=sqrt_42_3_m;
            s8f[1]=sqrt_42_1_m;
            s8f[2]=sqrt_42_5_m;
            s8f[3]=sqrt_42_1; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
end			
        else if(x<=sqrt_42_3_m && x>sqrt_42_4_m)  begin 
            s8f[0]=sqrt_42_3_m;
            s8f[1]=sqrt_42_5_m;
            s8f[2]=sqrt_42_1_m;
            s8f[3]=sqrt_42_7_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
			end
        else if(x<=sqrt_42_4_m && x>sqrt_42_5_m)begin    
            s8f[0]=sqrt_42_5_m;
            s8f[1]=sqrt_42_3_m;
            s8f[2]=sqrt_42_7_m;
            s8f[3]=sqrt_42_1_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
			end
        else if(x<=sqrt_42_5_m && x>sqrt_42_6_m)   begin  
            s8f[0]=sqrt_42_5_m;
            s8f[1]=sqrt_42_7_m;
            s8f[2]=sqrt_42_3_m;
            s8f[3]=sqrt_42_1_m;
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};
			end
        else if(x<sqrt_42_6_m)  begin   
            s8f[0]=sqrt_42_7_m;
            s8f[1]=sqrt_42_5_m;
            s8f[2]=sqrt_42_3_m;
            s8f[3]=sqrt_42_1_m; 
			eli = {s8f[3],s8f[2],s8f[1],s8f[0]};			
			end			
        else begin
		s8f[0] = s8f[0];
		s8f[1] = s8f[1];
		s8f[2] = s8f[2];
		s8f[3] = s8f[3];
        eli = eli;
		end
    end
	
endfunction
endmodule


        
        
    
 
   
    
      
      
      
      
      
      


