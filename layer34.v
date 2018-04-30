`timescale 1ns/1ps

module layer56(clk,rstn,y4,y3,R45,R46,R47,R48,R35,R36,R37,R38,ped_sort_4,sign_4_1,sign_4_2,sign_4_3,sign_4_4)
                                                                         
reg[11:0]a_5[0:7];                                                       
reg[11:0]b_5[0:7];                                                       
reg[11:0]c_5[0:7];      
reg[11:0]d_5[0:7];      
                        
reg[11:0]a_6[0:7];      
reg[11:0]b_6[0:7];      
reg[11:0]c_6[0:7];      
reg[11:0]d_6[0:7];
reg[11:0] L_error_5[0:7];
reg [11:0]sign_pp_5[0:59];
reg [11:0]sign_pp_5_reg[0:59];
reg[11:0] L_error_6[0:7];
reg [11:0]sign_pp_6[0:59];
reg [11:0]sign_pp_6_reg[0:59];


//  12 real
always @ (posedge clk or negedge rstn) begin  
    for (n=0;n<8;n=n+1'b1)begin
      a_5[n] = sign_4_1[n]*R45;
      b_5[n] = sign_4_2[n]*R46;
      c_5[n] = sign_4_3[n]*R47;
      d_5[n] = sign_4_4[n]*R48;
                       
      a_6[n] = sign_4_1[n]*R35;
      b_6[n] = sign_4_2[n]*R36;
      c_6[n] = sign_4_3[n]*R37;
      d_6[n] = sign_4_4[n]*R38;

      L_error_5[n] = y4 - (a_5[n] + b_5[n] + c_5[n] + d_5[n]);
	  
	  {sign_pp_5[8*(n)+7],sign_pp_5[8*(n)+6],sign_pp_5[8*(n)+5],sign_pp_5[8*(n)+4],
		sign_pp_5[8*(n)+3],sign_pp_5[8*(n)+2],sign_pp_5[8*(n)+1],sign_pp_5[8*(n)+0]}=diff_64(L_error_5[n],R44);
      
     
      for(i=0;i<4;i=i+1'b1)begin
        sign_pp_5_reg[i]= sign_pp_5[8*(n)+i];
		end
	  
      L_error_6[n] = y3- (a_6[n] + b_6[n] + c_6[n] + d_6[n]);
	  
	  {sign_pp_6[8*(n)+7],sign_pp_6[8*(n)+6],sign_pp_6[8*(n)+5],sign_pp_6[8*(n)+4],
		sign_pp_6[8*(n)+3],sign_pp_6[8*(n)+2],sign_pp_6[8*(n)+1],sign_pp_6[8*(n)+0]}=diff_64(L_error_6[n],R33);
	  
     for(i=0;i<4;i=i+1'b1)begin
        sign_pp_6_reg[i]= sign_pp_5[8*(n)+i];
		end
      
      
      ped_reg_4 = ped_sort_4[n];
      
      if(n==0||n==1)begin
      for (m=0;m<4;m=m+1'b1)begin
	  for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_5_1[4*m+i] = sign_pp_6_reg[m];
			sign_buffer_5_2[4*m+i] = sign_pp_5_reg[i];
			
			error_5[4*m+i]=y4-
			(sign_buffer_5_2[4*m+i]*R44+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
			
			error_6[4*m+i]=y3-
			(sign_buffer_5_2[4*m+i]*R33+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
		
			ped_5[4*m+i] 
			= ped_reg_4
			+ error_5[4*m+i]*error_5[4*m+i]
			+ error_6[4*m+i]*error_6[4*m+i];
			end
      //sign_buffer_5_1(4*(m-1)+1:4*m) = sign_pp_6_reg(m);  
      //sign_buffer_5_2(4*(m-1)+1:4*m) = sign_pp_5_reg(1~4);
      
      //error_5(4*(m-1)+1:4*m) = y41...
        //                         - (	sign_buffer_5_2[4*(m-1)+1:4*m)]*R44+ a_5[n] +b_5[n]...
             //                                                      +c_5[n]+d_5[n]	);

      //error_6(4*(m-1)+1:4*m,1,k) = y31...
           //                      - (	sign_buffer_5_1(4*(m-1)+1:4*m,1,k)*R33+a_6[n] +b_6[n]...
             //                                                      +c_6[n]+d_6[n]	);
                                                                  
                                                                
      //ped_5(4*(m-1)+1:4*m) = ped_reg_4...
                            //   + error_5[4*(m-1)+1:4*m].*error_5[4*(m-1)+1:4*m]+error_6[4*(m-1)+1:4*m]).*error_6[4*(m-1)+1:4*m];
                           
      end
	  //sort
       //[ped_sort_5(1:16,1,k),index_5(1:16,1,k)] = sort(ped_5(1:16,1,k));  
       for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_5[j]<ped_5[i])begin
			temp[i]	=	ped_5[i];
			ped_5[i]	=	ped_5[np];
			ped_5[np]	=	temp[i];
			temp1[i]	=	index_5[i];
			index_5[i]	=	index_5[np];
			index_5[np]	=	temp1[i];
			end
			
		end
		end
		
	   //sign5
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_5_1[i] = sign_buffer_5_1[index_5[i]];   
	  sign_5_2[i] = sign_buffer_5_2[index_5[i]];  
      sign_5_3[i] = sign_4_1[n]; 
      sign_5_4[i] = sign_4_2[n];
	  sign_5_5[i] = sign_4_3[n];
	  sign_5_6[i] = sign_4_4[n];
	  end 
	  
      //sign_5_1(1:16) = sign_buffer_5_1(index_5(1:16,1,k));
	  //sign_5_2(1:16) = sign_buffer_5_2(index_5(1:16,1,k));  	  
      //sign_5_3(1:16) = sign_4_1(n);   
      //sign_5_4(1:16)= sign_4_2(n);   
      //sign_5_5(1:16)= sign_4_3(n);  
      //sign_5_6(1:16)= sign_4_4(n);   
      
	  //sing buffer 6
	  for(i=0;i<8;i=i+1'b1)begin
      ped_6[8*n+i] = ped_sort_5[i];
	  sign_buffer_6_1[8*n+i] = sign_5_1[i];
      sign_buffer_6_2[8*n+i] = sign_5_2[i];
      sign_buffer_6_3[8*n+i] = sign_5_3[i];
      sign_buffer_6_4[8*n+i] = sign_5_4[i];
	  sign_buffer_6_5[8*n+i] = sign_5_5[i];
      sign_buffer_6_6[8*n+i] = sign_5_6[i];
	  end
	  
	  end
      //ped_6(8*(n-1)+1:8*n) = ped_sort_5(1:8);
      
      //sign_buffer_6_1(8*(n-1)+1:8*n) = sign_5_1(1:8);
      //sign_buffer_6_2(8*(n-1)+1:8*n) = sign_5_2(1:8);
      //sign_buffer_6_3(8*(n-1)+1:8*n) = sign_5_3(1:8);
      //sign_buffer_6_4(8*(n-1)+1:8*n) = sign_5_4(1:8);                     
      //sign_buffer_6_5(8*(n-1)+1:8*n) = sign_5_5(1:8);     
      //sign_buffer_6_6(8*(n-1)+1:8*n) = sign_5_6(1:8);     
      
      else if(n==2||n==3)begin
      for (m=0;m<4;m=m+1'b1)begin
	  for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_5_1[4*m+i] = sign_pp_6_reg[m];
			sign_buffer_5_2[4*m+i] = sign_pp_5_reg[i];
			
			error_5[4*m+i]=y4-
			(sign_buffer_5_2[4*m+i]*R44+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
			
			error_6[4*m+i]=y3-
			(sign_buffer_5_2[4*m+i]*R33+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
		
			ped_5[4*m+i] 
			= ped_reg_4
			+ error_5[4*m+i]*error_5[4*m+i]
			+ error_6[4*m+i]*error_6[4*m+i];
			end
      //sign_buffer_5_1(4*(m-1)+1:4*m) = sign_pp_6_reg(m);  
      //sign_buffer_5_2(4*(m-1)+1:4*m) = sign_pp_5_reg(1~4);
      
      //error_5(4*(m-1)+1:4*m) = y41...
        //                         - (	sign_buffer_5_2[4*(m-1)+1:4*m)]*R44+ a_5[n] +b_5[n]...
             //                                                      +c_5[n]+d_5[n]	);

      //error_6(4*(m-1)+1:4*m,1,k) = y31...
           //                      - (	sign_buffer_5_1(4*(m-1)+1:4*m,1,k)*R33+a_6[n] +b_6[n]...
             //                                                      +c_6[n]+d_6[n]	);
                                                                  
                                                                
      //ped_5(4*(m-1)+1:4*m) = ped_reg_4...
                            //   + error_5[4*(m-1)+1:4*m].*error_5[4*(m-1)+1:4*m]+error_6[4*(m-1)+1:4*m]).*error_6[4*(m-1)+1:4*m];
                           
      end
	  //sort
       //[ped_sort_5(1:16,1,k),index_5(1:16,1,k)] = sort(ped_5(1:16,1,k));  
       for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_5[j]<ped_5[i])begin
			temp[i]	=	ped_5[i];
			ped_5[i]	=	ped_5[np];
			ped_5[np]	=	temp[i];
			temp1[i]	=	index_5[i];
			index_5[i]	=	index_5[np];
			index_5[np]	=	temp1[i];
			end
			
		end
		end
		
	   //sign5
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_5_1[i] = sign_buffer_5_1[index_5[i]];   
	  sign_5_2[i] = sign_buffer_5_2[index_5[i]];  
      sign_5_3[i] = sign_4_1[n]; 
      sign_5_4[i] = sign_4_2[n];
	  sign_5_5[i] = sign_4_3[n];
	  sign_5_6[i] = sign_4_4[n];
	  end 
	  
      //sign_5_1(1:16) = sign_buffer_5_1(index_5(1:16,1,k));
	  //sign_5_2(1:16) = sign_buffer_5_2(index_5(1:16,1,k));  	  
      //sign_5_3(1:16) = sign_4_1(n);   
      //sign_5_4(1:16)= sign_4_2(n);   
      //sign_5_5(1:16)= sign_4_3(n);  
      //sign_5_6(1:16)= sign_4_4(n);   
      
	  for(i=0;i<6;i=i+1'b1)begin
	   ped_6[6*n+i+4] = ped_sort_5[i];//5~10vs0~5
      
      sign_buffer_6_1[i+6*n] = sign_5_1[i];
      sign_buffer_6_2[i+6*n] = sign_5_2[i];
      sign_buffer_6_3[i+6*n] = sign_5_3[i];
      sign_buffer_6_4[i+6*n] = sign_5_4[i];
	  sign_buffer_6_5[i+6*n] = sign_5_5[i];
	  sign_buffer_6_6[i+6*n] = sign_5_6[i];
	                                   
      end                              
	end
      //ped_6(6*(n-1)+5:4+6*n,1) = ped_sort_5(1:6);
      
      //sign_buffer_6_1(6*(n-1)+5:4+6*n,1) = sign_5_1(1:6);
      //sign_buffer_6_2(6*(n-1)+5:4+6*n,1) = sign_5_2(1:6);
      //sign_buffer_6_3(6*(n-1)+5:4+6*n,1) = sign_5_3(1:6);
      //sign_buffer_6_4(6*(n-1)+5:4+6*n,1) = sign_5_4(1:6);                     
      //sign_buffer_6_5(6*(n-1)+5:4+6*n,1) = sign_5_5(1:6);     
      //sign_buffer_6_6(6*(n-1)+5:4+6*n,1) = sign_5_6(1:6);       
      
      else if(n==4||n==5)begin
      for (m=0;m<4;m=m+1'b1)begin
	  for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_5_1[4*m+i] = sign_pp_6_reg[m];
			sign_buffer_5_2[4*m+i] = sign_pp_5_reg[i];
			
			error_5[4*m+i]=y4-
			(sign_buffer_5_2[4*m+i]*R44+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
			
			error_6[4*m+i]=y3-
			(sign_buffer_5_2[4*m+i]*R33+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
		
			ped_5[4*m+i] 
			= ped_reg_4
			+ error_5[4*m+i]*error_5[4*m+i]
			+ error_6[4*m+i]*error_6[4*m+i];
			end
      //sign_buffer_5_1(4*(m-1)+1:4*m) = sign_pp_6_reg(m);  
      //sign_buffer_5_2(4*(m-1)+1:4*m) = sign_pp_5_reg(1~4);
      
      //error_5(4*(m-1)+1:4*m) = y41...
        //                         - (	sign_buffer_5_2[4*(m-1)+1:4*m)]*R44+ a_5[n] +b_5[n]...
             //                                                      +c_5[n]+d_5[n]	);

      //error_6(4*(m-1)+1:4*m,1,k) = y31...
           //                      - (	sign_buffer_5_1(4*(m-1)+1:4*m,1,k)*R33+a_6[n] +b_6[n]...
             //                                                      +c_6[n]+d_6[n]	);
                                                                  
                                                                
      //ped_5(4*(m-1)+1:4*m) = ped_reg_4...
                            //   + error_5[4*(m-1)+1:4*m].*error_5[4*(m-1)+1:4*m]+error_6[4*(m-1)+1:4*m]).*error_6[4*(m-1)+1:4*m];
                           
      end
	  //sort
       //[ped_sort_5(1:16,1,k),index_5(1:16,1,k)] = sort(ped_5(1:16,1,k));  
       for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_5[j]<ped_5[i])begin
			temp[i]	=	ped_5[i];
			ped_5[i]	=	ped_5[np];
			ped_5[np]	=	temp[i];
			temp1[i]	=	index_5[i];
			index_5[i]	=	index_5[np];
			index_5[np]	=	temp1[i];
			end
			
		end
		end
		
	   //sign5
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_5_1[i] = sign_buffer_5_1[index_5[i]];   
	  sign_5_2[i] = sign_buffer_5_2[index_5[i]];  
      sign_5_3[i] = sign_4_1[n]; 
      sign_5_4[i] = sign_4_2[n];
	  sign_5_5[i] = sign_4_3[n];
	  sign_5_6[i] = sign_4_4[n];
	  end 
	  
      //sign_5_1(1:16) = sign_buffer_5_1(index_5(1:16,1,k));
	  //sign_5_2(1:16) = sign_buffer_5_2(index_5(1:16,1,k));  	  
      //sign_5_3(1:16) = sign_4_1(n);   
      //sign_5_4(1:16)= sign_4_2(n);   
      //sign_5_5(1:16)= sign_4_3(n);  
      //sign_5_6(1:16)= sign_4_4(n);   
   
      for(i=0;i<4;i=i+1'b1)begin
	   ped_6[12+4*n+i] = ped_sort_5[i];//5~10vs0~5
      
      sign_buffer_6_1[12+4*n+i] = sign_5_1[i];
      sign_buffer_6_2[12+4*n+i] = sign_5_2[i];
      sign_buffer_6_3[12+4*n+i] = sign_5_3[i];
      sign_buffer_6_4[12+4*n+i] = sign_5_4[i];
	  sign_buffer_6_5[12+4*n+i] = sign_5_5[i];
	  sign_buffer_6_6[12+4*n+i] = sign_5_6[i];
	                                   
      end                              
	end
      //ped_6(4*(n-1)+13:12+4*n) = ped_sort_5(1:4);
      //
      //sign_buffer_6_1(4*(n-1)+13:12+4*n) = sign_5_1(1:4);
      //sign_buffer_6_2(4*(n-1)+13:12+4*n) = sign_5_2(1:4);
      //sign_buffer_6_3(4*(n-1)+13:12+4*n) = sign_5_3(1:4);
      //sign_buffer_6_4(4*(n-1)+13:12+4*n) = sign_5_4(1:4);                     
      //sign_buffer_6_5(4*(n-1)+13:12+4*n) = sign_5_5(1:4);     
      //sign_buffer_6_6(4*(n-1)+13:12+4*n) = sign_5_6(1:4);     
      
      else if(n==6||n==7)begin
      for (m=0;m<4;m=m+1'b1)begin
	  for(i=0;i<4;i=i+1'b1)begin
			sign_buffer_5_1[4*m+i] = sign_pp_6_reg[m];
			sign_buffer_5_2[4*m+i] = sign_pp_5_reg[i];
			
			error_5[4*m+i]=y4-
			(sign_buffer_5_2[4*m+i]*R44+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
			
			error_6[4*m+i]=y3-
			(sign_buffer_5_2[4*m+i]*R33+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]);
		
			ped_5[4*m+i] 
			= ped_reg_4
			+ error_5[4*m+i]*error_5[4*m+i]
			+ error_6[4*m+i]*error_6[4*m+i];
			end
      //sign_buffer_5_1(4*(m-1)+1:4*m) = sign_pp_6_reg(m);  
      //sign_buffer_5_2(4*(m-1)+1:4*m) = sign_pp_5_reg(1~4);
      
      //error_5(4*(m-1)+1:4*m) = y41...
        //                         - (	sign_buffer_5_2[4*(m-1)+1:4*m)]*R44+ a_5[n] +b_5[n]...
             //                                                      +c_5[n]+d_5[n]	);

      //error_6(4*(m-1)+1:4*m,1,k) = y31...
           //                      - (	sign_buffer_5_1(4*(m-1)+1:4*m,1,k)*R33+a_6[n] +b_6[n]...
             //                                                      +c_6[n]+d_6[n]	);
                                                                  
                                                                
      //ped_5(4*(m-1)+1:4*m) = ped_reg_4...
                            //   + error_5[4*(m-1)+1:4*m].*error_5[4*(m-1)+1:4*m]+error_6[4*(m-1)+1:4*m]).*error_6[4*(m-1)+1:4*m];
                           
      end
	  //sort
       //[ped_sort_5(1:16,1,k),index_5(1:16,1,k)] = sort(ped_5(1:16,1,k));  
       for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_5[j]<ped_5[i])begin
			temp[i]	=	ped_5[i];
			ped_5[i]	=	ped_5[np];
			ped_5[np]	=	temp[i];
			temp1[i]	=	index_5[i];
			index_5[i]	=	index_5[np];
			index_5[np]	=	temp1[i];
			end
			
		end
		end
		
	   //sign5
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_5_1[i] = sign_buffer_5_1[index_5[i]];   
	  sign_5_2[i] = sign_buffer_5_2[index_5[i]];  
      sign_5_3[i] = sign_4_1[n]; 
      sign_5_4[i] = sign_4_2[n];
	  sign_5_5[i] = sign_4_3[n];
	  sign_5_6[i] = sign_4_4[n];
	  end 
	  
	  for(i=0;i<2;i=i+1'b1)begin
	   ped_6[24+2*n+i] = ped_sort_5[i];//26~25vs0:1
      
      sign_buffer_6_1[24+2*n+i] = sign_5_1[i];
      sign_buffer_6_2[24+2*n+i] = sign_5_2[i];
      sign_buffer_6_3[24+2*n+i] = sign_5_3[i];
      sign_buffer_6_4[24+2*n+i] = sign_5_4[i];
	  sign_buffer_6_5[24+2*n+i] = sign_5_5[i];
	  sign_buffer_6_6[24+2*n+i] = sign_5_6[i];
	                                   
      end                              
	end
      //ped_6(2*(n-1)+25:24+2*n) = ped_sort_5(1:2);
      //
      //sign_buffer_6_1(2*(n-1)+25:24+2*n) = sign_5_1(1:2);
      //sign_buffer_6_2(2*(n-1)+25:24+2*n) = sign_5_2(1:2);
      //sign_buffer_6_3(2*(n-1)+25:24+2*n) = sign_5_3(1:2);
      //sign_buffer_6_4(2*(n-1)+25:24+2*n) = sign_5_4(1:2);                     
      //sign_buffer_6_5(2*(n-1)+25:24+2*n) = sign_5_5(1:2);     
      //sign_buffer_6_6(2*(n-1)+25:24+2*n) = sign_5_6(1:2);     
          
          
      end
    
	
	for(i=0;i<40;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_6[j]<ped_6[i])begin
			temp[i]	=	ped_6[i];
			ped_6[i]	=	ped_6[np];
			ped_6[np]	=	temp[i];
			temp1[i]	=	index_6[i];
			index_6[i]	=	index_6[np];
			index_6[np]	=	temp1[i];
			end
			
		end
		end
    //[ped_sort_6(1:40,1,k),index_6(1:40,1,k)] = sort(ped_6(1:40,1,k));
    for(i=0;i<40;i=i+1'b1)begin
    sign_6_1[i] = sign_buffer_6_1[index_6[i]];//
	sign_6_2[i] = sign_buffer_6_2[index_6[i]];
	sign_6_3[i] = sign_buffer_6_3[index_6[i]];
	sign_6_4[i] = sign_buffer_6_4[index_6[i]];
	sign_6_5[i] = sign_buffer_6_5[index_6[i]];
	sign_6_6[i] = sign_buffer_6_6[index_6[i]];
	
	end      
	//sign_6_1(1:40) = sign_buffer_6_1(index_6(1:40));//
	//sign_6_2(1:40) = sign_buffer_6_2(index_6(1:40));
	//sign_6_3(1:40) = sign_buffer_6_3(index_6(1:40));
	//sign_6_4(1:40) = sign_buffer_6_4(index_6(1:40));
    //sign_6_5(1:40) = sign_buffer_6_5(index_6(1:40));
	//sign_6_6(1:40) = sign_buffer_6_6(index_6(1:40));
	
end
endmodule
