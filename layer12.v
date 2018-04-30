`timescale 1ns/1ps

module layer12();
always(posedge clk or negedge rstn)begin
for (n=0;n<8;n=n+1'b1)begin
	 
      a_7[n] = sign_6_1[n]*R23;
      b_7[n] = sign_6_2[n]*R24;
      c_7[n] = sign_6_3[n]*R25;
      d_7[n] = sign_6_4[n]*R26;
      e_7[n] = sign_6_5[n]*R27;
      f_7[n] = sign_6_6[n]*R28;
                      
      a_8[n] = sign_6_1[n]*R13;
      b_8[n] = sign_6_2[n]*R14;
      c_8[n] = sign_6_3[n]*R15;
      d_8[n] = sign_6_4[n]*R16;
      e_8[n] = sign_6_5[n]*R17;
      f_8[n] = sign_6_6[n]*R18;
                      
      L_error_7[n] = y2 - (a_7[n] + b_7[n] + c_7[n] + d_7[n] + e_7[n] + f_7[n]);
	  
	   {sign_pp_7[8*(n)+7],sign_pp_7[8*(n)+6],sign_pp_7[8*(n)+5],sign_pp_7[8*(n)+4],
		sign_pp_7[8*(n)+3],sign_pp_7[8*(n)+2],sign_pp_7[8*(n)+1],sign_pp_7[8*(n)+0]}=diff_64(L_error_7[n],R22);
     
      //sign_pp_7(8*(n-1)+1:8*n) = diff_64(L_error_7(n),R22);
	  
	   for(i=0;i<4;i=i+1'b1)begin
        sign_pp_7_reg[i]= sign_pp_7[8*(n)+i];
		end
      //sign_pp_7_reg(1~4) = sign_pp_7(8*(n-1)+1:8*n-4);
      
	  
      L_error_8[n]= y1 - (a_8[n] + b_8[n] + c_8[n] + d_8[n] + e_8[n] + f_8[n]);
	  
      //sign_pp_8(8*(n-1)+1:8*n) = diff_64(L_error_8(n),R11);
	   {sign_pp_8[8*(n)+7],sign_pp_8[8*(n)+6],sign_pp_8[8*(n)+5],sign_pp_8[8*(n)+4],
		sign_pp_8[8*(n)+3],sign_pp_8[8*(n)+2],sign_pp_8[8*(n)+1],sign_pp_8[8*(n)+0]}=diff_64(L_error_8[n],R11);
     
      //sign_pp_8_reg(1:4) = sign_pp_8(8*(n-1)+1:8*n-4);
        for(i=0;i<4;i=i+1'b1)begin
        sign_pp_8_reg[i]= sign_pp_8[8*(n)+i];
		end
		ped_reg_6 = ped_sort_6[n];
	  
     if(n==0||n==1) begin
     for (m=0;m<4;m=m+1'b1)begin
	 for(i=0;i<4;i=i+1'b1)begin
	  sign_buffer_7_1[4*m+i] = sign_pp_8_reg[m];
	  sign_buffer_7_2[4*m+i] = sign_pp_7_reg[i];
      //sign_buffer_7_1(4*(m-1)+1:4*m) = sign_pp_8_reg(m);  
      //sign_buffer_7_2(4*(m-1)+1:4*m) = sign_pp_7_reg(1:4);
      error_7[4*m+i]=y2-
			(sign_buffer_7_2[4*m+i]*R22+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
      //error_7(4*(m-1)+1:4*m) = y21...
       //                          - (	(	sign_buffer_7_2(	4*(m-1)+1:4*m	)*R22	)+a_7[n]+b_7[n]+c_7[n]+d_7[n]+e_7[n]+f_7[n]);
		//
		error_8[4*m+i]=y1-
			(sign_buffer_7_1[4*m+i]*R11+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
     // error_8(4*(m-1)+1:4*m) = y11...
      //                           - (	(	sign_buffer_7_1(	4*(m-1)+1:4*m	)*R11	)	+a_8[n]+b_8[n]+c_8[n]+d_8[n]+e_8[n]+f_8[n]);
//
		ped_7[4*m+i] 
			= ped_reg_6
			+ error_7[4*m+i]*error_7[4*m+i]
			+ error_8[4*m+i]*error_8[4*m+i];
     // ped_7(4*(m-1)+1:4*m) = ped_reg_6...
       //                        + error_7(4*(m-1)+1:4*m).*error_7(4*(m-1)+1:4*m)+error_8(4*(m-1)+1:4*m).*error_8(4*(m-1)+1:4*m);
       //                                                         
     end
	 end
	 //ped sort
      //[ped_sort_7(1:16,1,k),index_7(1:16,1,k)] = sort(ped_7(1:16,1,k)); 
		for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_7[j]<ped_7[i])begin
			temp[i]	=	ped_7[i];
			ped_7[i]	=	ped_7[np];
			ped_7[np]	=	temp[i];
			temp1[i]	=	index_7[i];
			index_7[i]	=	index_7[np];
			index_7[np]	=	temp1[i];
			end
			
		end
		end
			  
      //sin7
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_7_1[i] = sign_buffer_7_1[index_7[i]];   
	  sign_7_2[i] = sign_buffer_7_2[index_7[i]];  
      sign_7_3[i] = sign_6_1[n]; 
      sign_7_4[i] = sign_6_2[n];
	  sign_7_5[i] = sign_6_3[n];
	  sign_7_6[i] = sign_6_4[n];
	  sign_7_7[i] = sign_6_5[n];
	  sign_7_8[i] = sign_6_6[n];
	  end 
	  
     // sign_7_1(1:16) = sign_buffer_7(index_7(1:16)); 
	 // sign_7_2(1:16) = sign_buffer_7(index_7(1:16));  	  
     // sign_7_3(1:16) = sign_6_1(n);
     // sign_7_4(1:16) = sign_6_2(n);
     // sign_7_5(1:16) = sign_6_3(n);
     // sign_7_6(1:16) = sign_6_4(n);
     // sign_7_7(1:16) = sign_6_5(n);
     // sign_7_8(1:16) = sign_6_6(n);
      
      for(i=0;i<8;i=i+1'b1)begin
      ped_8[8*n+i] = ped_sort_7[i];
	  sign_buffer_8_1[8*n+i] = sign_7_1[i];
      sign_buffer_8_2[8*n+i] = sign_7_2[i];
      sign_buffer_8_3[8*n+i] = sign_7_3[i];
      sign_buffer_8_4[8*n+i] = sign_7_4[i];
	  sign_buffer_8_5[8*n+i] = sign_7_5[i];
      sign_buffer_8_6[8*n+i] = sign_7_6[i];
	  sign_buffer_8_7[8*n+i] = sign_7_7[i];
	  sign_buffer_8_8[8*n+i] = sign_7_8[i];
	  end 
	end
      //ped_8(8*(n-1)+1:8*n) = ped_sort_7(1:8);
      //                     
      //
      //sign_buffer_8_1(8*(n-1)+1:8*n) = sign_7_1(1:8); 
      //sign_buffer_8_2(8*(n-1)+1:8*n) = sign_7_2(1:8);
      //sign_buffer_8_3(8*(n-1)+1:8*n) = sign_7_3(1:8);
      //sign_buffer_8_4(8*(n-1)+1:8*n) = sign_7_4(1:8);
      //sign_buffer_8_5(8*(n-1)+1:8*n) = sign_7_5(1:8);
      //sign_buffer_8_6(8*(n-1)+1:8*n) = sign_7_6(1:8);
      //sign_buffer_8_7(8*(n-1)+1:8*n) = sign_7_7(1:8);
      //sign_buffer_8_8(8*(n-1)+1:8*n) = sign_7_8(1:8);
      
	  
     else if(n==2||n==3)begin
     for (m=0;m<4;m=m+1'b1)begin
	 for(i=0;i<4;i=i+1'b1)begin
	  sign_buffer_7_1[4*m+i] = sign_pp_8_reg[m];
	  sign_buffer_7_2[4*m+i] = sign_pp_7_reg[i];
      //sign_buffer_7_1(4*(m-1)+1:4*m) = sign_pp_8_reg(m);  
      //sign_buffer_7_2(4*(m-1)+1:4*m) = sign_pp_7_reg(1:4);
      error_7[4*m+i]=y2-
			(sign_buffer_7_2[4*m+i]*R22+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
      //error_7(4*(m-1)+1:4*m) = y21...
       //                          - (	(	sign_buffer_7_2(	4*(m-1)+1:4*m	)*R22	)+a_7[n]+b_7[n]+c_7[n]+d_7[n]+e_7[n]+f_7[n]);
		//
		error_8[4*m+i]=y1-
			(sign_buffer_7_1[4*m+i]*R11+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
     // error_8(4*(m-1)+1:4*m) = y11...
      //                           - (	(	sign_buffer_7_1(	4*(m-1)+1:4*m	)*R11	)	+a_8[n]+b_8[n]+c_8[n]+d_8[n]+e_8[n]+f_8[n]);
//
		ped_7[4*m+i] 
			= ped_reg_6
			+ error_7[4*m+i]*error_7[4*m+i]
			+ error_8[4*m+i]*error_8[4*m+i];
     // ped_7(4*(m-1)+1:4*m) = ped_reg_6...
       //                        + error_7(4*(m-1)+1:4*m).*error_7(4*(m-1)+1:4*m)+error_8(4*(m-1)+1:4*m).*error_8(4*(m-1)+1:4*m);
       //                                                         
     end
	 end
	 //ped sort
      //[ped_sort_7(1:16,1,k),index_7(1:16,1,k)] = sort(ped_7(1:16,1,k)); 
		for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_7[j]<ped_7[i])begin
			temp[i]	=	ped_7[i];
			ped_7[i]	=	ped_7[np];
			ped_7[np]	=	temp[i];
			temp1[i]	=	index_7[i];
			index_7[i]	=	index_7[np];
			index_7[np]	=	temp1[i];
			end
			
		end
		end
			  
      //sin7
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_7_1[i] = sign_buffer_7_1[index_7[i]];   
	  sign_7_2[i] = sign_buffer_7_2[index_7[i]];  
      sign_7_3[i] = sign_6_1[n]; 
      sign_7_4[i] = sign_6_2[n];
	  sign_7_5[i] = sign_6_3[n];
	  sign_7_6[i] = sign_6_4[n];
	  sign_7_7[i] = sign_6_5[n];
	  sign_7_8[i] = sign_6_6[n];
	  end 
	  
     // sign_7_1(1:16) = sign_buffer_7(index_7(1:16)); 
	 // sign_7_2(1:16) = sign_buffer_7(index_7(1:16));  	  
     // sign_7_3(1:16) = sign_6_1(n);
     // sign_7_4(1:16) = sign_6_2(n);
     // sign_7_5(1:16) = sign_6_3(n);
     // sign_7_6(1:16) = sign_6_4(n);
     // sign_7_7(1:16) = sign_6_5(n);
     // sign_7_8(1:16) = sign_6_6(n);
      for(i=0;i<6;i=i+1'b1)begin
      ped_8[6*n+i+4] = ped_sort_7[i];
	  sign_buffer_8_1[6*n+i+4] = sign_7_1[i];
      sign_buffer_8_2[6*n+i+4] = sign_7_2[i];
      sign_buffer_8_3[6*n+i+4] = sign_7_3[i];
      sign_buffer_8_4[6*n+i+4] = sign_7_4[i];
	  sign_buffer_8_5[6*n+i+4] = sign_7_5[i];
      sign_buffer_8_6[6*n+i+4] = sign_7_6[i];
	  sign_buffer_8_7[6*n+i+4] = sign_7_7[i];
	  sign_buffer_8_8[6*n+i+4] = sign_7_8[i];
	  end 
	end                                                                
     //ped_8(6*(n-1)+5:4+6*n) = ped_sort_7(1:6);
     //                     
     //
     //sign_buffer_8_1(6*(n-1)+5:4+6*n) = sign_7_1(1:6); 
     //sign_buffer_8_2(6*(n-1)+5:4+6*n) = sign_7_2(1:6);
     //sign_buffer_8_3(6*(n-1)+5:4+6*n) = sign_7_3(1:6);
     //sign_buffer_8_4(6*(n-1)+5:4+6*n) = sign_7_4(1:6);
     //sign_buffer_8_5(6*(n-1)+5:4+6*n) = sign_7_5(1:6);
     //sign_buffer_8_6(6*(n-1)+5:4+6*n) = sign_7_6(1:6);
     //sign_buffer_8_7(6*(n-1)+5:4+6*n) = sign_7_7(1:6);
     //sign_buffer_8_8(6*(n-1)+5:4+6*n) = sign_7_8(1:6);
      
      else if(n==4||n==5)begin
     for (m=0;m<4;m=m+1'b1)begin
	 for(i=0;i<4;i=i+1'b1)begin
	  sign_buffer_7_1[4*m+i] = sign_pp_8_reg[m];
	  sign_buffer_7_2[4*m+i] = sign_pp_7_reg[i];
      //sign_buffer_7_1(4*(m-1)+1:4*m) = sign_pp_8_reg(m);  
      //sign_buffer_7_2(4*(m-1)+1:4*m) = sign_pp_7_reg(1:4);
      error_7[4*m+i]=y2-
			(sign_buffer_7_2[4*m+i]*R22+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
      //error_7(4*(m-1)+1:4*m) = y21...
       //                          - (	(	sign_buffer_7_2(	4*(m-1)+1:4*m	)*R22	)+a_7[n]+b_7[n]+c_7[n]+d_7[n]+e_7[n]+f_7[n]);
		//
		error_8[4*m+i]=y1-
			(sign_buffer_7_1[4*m+i]*R11+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
     // error_8(4*(m-1)+1:4*m) = y11...
      //                           - (	(	sign_buffer_7_1(	4*(m-1)+1:4*m	)*R11	)	+a_8[n]+b_8[n]+c_8[n]+d_8[n]+e_8[n]+f_8[n]);
//
		ped_7[4*m+i] 
			= ped_reg_6
			+ error_7[4*m+i]*error_7[4*m+i]
			+ error_8[4*m+i]*error_8[4*m+i];
     // ped_7(4*(m-1)+1:4*m) = ped_reg_6...
       //                        + error_7(4*(m-1)+1:4*m).*error_7(4*(m-1)+1:4*m)+error_8(4*(m-1)+1:4*m).*error_8(4*(m-1)+1:4*m);
       //                                                         
     end
	 end
	 //ped sort
      //[ped_sort_7(1:16,1,k),index_7(1:16,1,k)] = sort(ped_7(1:16,1,k)); 
		for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_7[j]<ped_7[i])begin
			temp[i]	=	ped_7[i];
			ped_7[i]	=	ped_7[np];
			ped_7[np]	=	temp[i];
			temp1[i]	=	index_7[i];
			index_7[i]	=	index_7[np];
			index_7[np]	=	temp1[i];
			end
			
		end
		end
			  
      //sin7
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_7_1[i] = sign_buffer_7_1[index_7[i]];   
	  sign_7_2[i] = sign_buffer_7_2[index_7[i]];  
      sign_7_3[i] = sign_6_1[n]; 
      sign_7_4[i] = sign_6_2[n];
	  sign_7_5[i] = sign_6_3[n];
	  sign_7_6[i] = sign_6_4[n];
	  sign_7_7[i] = sign_6_5[n];
	  sign_7_8[i] = sign_6_6[n];
	  end 
	  
     // sign_7_1(1:16) = sign_buffer_7(index_7(1:16)); 
	 // sign_7_2(1:16) = sign_buffer_7(index_7(1:16));  	  
     // sign_7_3(1:16) = sign_6_1(n);
     // sign_7_4(1:16) = sign_6_2(n);
     // sign_7_5(1:16) = sign_6_3(n);
     // sign_7_6(1:16) = sign_6_4(n);
     // sign_7_7(1:16) = sign_6_5(n);
     // sign_7_8(1:16) = sign_6_6(n);
      for(i=0;i<4;i=i+1'b1)begin
      ped_8[12+4*n+i] = ped_sort_7[i];
	  sign_buffer_8_1[12+4*n+i] = sign_7_1[i];
      sign_buffer_8_2[12+4*n+i] = sign_7_2[i];
      sign_buffer_8_3[12+4*n+i] = sign_7_3[i];
      sign_buffer_8_4[12+4*n+i] = sign_7_4[i];
	  sign_buffer_8_5[12+4*n+i] = sign_7_5[i];
      sign_buffer_8_6[12+4*n+i] = sign_7_6[i];
	  sign_buffer_8_7[12+4*n+i] = sign_7_7[i];
	  sign_buffer_8_8[12+4*n+i] = sign_7_8[i];
	  end 
	end                                                                
     //ped_89(4*(n-1)+13:12+4*n) = ped_sort_7(1:6);
     //                     
     //
     //sign_buffer_8_1(4*(n-1)+13:12+4*n) = sign_7_1(1:4); 
     //sign_buffer_8_2(4*(n-1)+13:12+4*n) = sign_7_2(1:4);
     //sign_buffer_8_3(4*(n-1)+13:12+4*n) = sign_7_3(1:4);
     //sign_buffer_8_4(4*(n-1)+13:12+4*n) = sign_7_4(1:4);
     //sign_buffer_8_5(4*(n-1)+13:12+4*n) = sign_7_5(1:4);
     //sign_buffer_8_6(4*(n-1)+13:12+4*n) = sign_7_6(1:4);
     //sign_buffer_8_7(4*(n-1)+13:12+4*n) = sign_7_7();
     //sign_buffer_8_8(4*(n-1)+13:12+4*n) = sign_7_8();
      
     else if(n==6||n==7)begin
     for (m=0;m<4;m=m+1'b1)begin
	 for(i=0;i<4;i=i+1'b1)begin
	  sign_buffer_7_1[4*m+i] = sign_pp_8_reg[m];
	  sign_buffer_7_2[4*m+i] = sign_pp_7_reg[i];
      //sign_buffer_7_1(4*(m-1)+1:4*m) = sign_pp_8_reg(m);  
      //sign_buffer_7_2(4*(m-1)+1:4*m) = sign_pp_7_reg(1:4);
      error_7[4*m+i]=y2-
			(sign_buffer_7_2[4*m+i]*R22+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
      //error_7(4*(m-1)+1:4*m) = y21...
       //                          - (	(	sign_buffer_7_2(	4*(m-1)+1:4*m	)*R22	)+a_7[n]+b_7[n]+c_7[n]+d_7[n]+e_7[n]+f_7[n]);
		//
		error_8[4*m+i]=y1-
			(sign_buffer_7_1[4*m+i]*R11+
			a_5[n]+b_5[n]+c_5[n]+d_5[n]+e_7[n]+f_7[n]);
     // error_8(4*(m-1)+1:4*m) = y11...
      //                           - (	(	sign_buffer_7_1(	4*(m-1)+1:4*m	)*R11	)	+a_8[n]+b_8[n]+c_8[n]+d_8[n]+e_8[n]+f_8[n]);
//
		ped_7[4*m+i] 
			= ped_reg_6
			+ error_7[4*m+i]*error_7[4*m+i]
			+ error_8[4*m+i]*error_8[4*m+i];
     // ped_7(4*(m-1)+1:4*m) = ped_reg_6...
       //                        + error_7(4*(m-1)+1:4*m).*error_7(4*(m-1)+1:4*m)+error_8(4*(m-1)+1:4*m).*error_8(4*(m-1)+1:4*m);
       //                                                         
     end
	 end
	 //ped sort
      //[ped_sort_7(1:16,1,k),index_7(1:16,1,k)] = sort(ped_7(1:16,1,k)); 
		for(i=0;i<16;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_7[j]<ped_7[i])begin
			temp[i]	=	ped_7[i];
			ped_7[i]	=	ped_7[np];
			ped_7[np]	=	temp[i];
			temp1[i]	=	index_7[i];
			index_7[i]	=	index_7[np];
			index_7[np]	=	temp1[i];
			end
			
		end
		end
			  
      //sin7
	  for(i=0;i<16;i=i+1'b1)begin
	  sign_7_1[i] = sign_buffer_7_1[index_7[i]];   
	  sign_7_2[i] = sign_buffer_7_2[index_7[i]];  
      sign_7_3[i] = sign_6_1[n]; 
      sign_7_4[i] = sign_6_2[n];
	  sign_7_5[i] = sign_6_3[n];
	  sign_7_6[i] = sign_6_4[n];
	  sign_7_7[i] = sign_6_5[n];
	  sign_7_8[i] = sign_6_6[n];
	  end 
	  
     // sign_7_1(1:16) = sign_buffer_7(index_7(1:16)); 
	 // sign_7_2(1:16) = sign_buffer_7(index_7(1:16));  	  
     // sign_7_3(1:16) = sign_6_1(n);
     // sign_7_4(1:16) = sign_6_2(n);
     // sign_7_5(1:16) = sign_6_3(n);
     // sign_7_6(1:16) = sign_6_4(n);
     // sign_7_7(1:16) = sign_6_5(n);
     // sign_7_8(1:16) = sign_6_6(n);
      for(i=0;i<2;i=i+1'b1)begin
      ped_8[24+2*n+i] = ped_sort_7[i];
	  sign_buffer_8_1[24+2*n+i] = sign_7_1[i];
      sign_buffer_8_2[24+2*n+i] = sign_7_2[i];
      sign_buffer_8_3[24+2*n+i] = sign_7_3[i];
      sign_buffer_8_4[24+2*n+i] = sign_7_4[i];
	  sign_buffer_8_5[24+2*n+i] = sign_7_5[i];
      sign_buffer_8_6[24+2*n+i] = sign_7_6[i];
	  sign_buffer_8_7[24+2*n+i] = sign_7_7[i];
	  sign_buffer_8_8[24+2*n+i] = sign_7_8[i];
	  end 
	end                                                                
                            
      //ped_8(2*(n-1)+25:24+2*n) = ped_sort_7(1:2);
      //                     
      //
      //sign_buffer_8_1(2*(n-1)+25:24+2*n) = sign_7_1(1:2); 
      //sign_buffer_8_2(2*(n-1)+25:24+2*n) = sign_7_2(1:2);
      //sign_buffer_8_3(2*(n-1)+25:24+2*n) = sign_7_3(1:2);
      //sign_buffer_8_4(2*(n-1)+25:24+2*n) = sign_7_4(1:2);
      //sign_buffer_8_5(2*(n-1)+25:24+2*n) = sign_7_5(1:2);
      //sign_buffer_8_6(2*(n-1)+25:24+2*n) = sign_7_6(1:2);
      //sign_buffer_8_7(2*(n-1)+25:24+2*n) = sign_7_7(1:2);
      //sign_buffer_8_8(2*(n-1)+25:24+2*n) = sign_7_8(1:2);
     
//終於算玩了
	end
    
	
	for(i=0;i<40;i=i+1'b1)begin

		np=i;
		
			for(j=i+1'b1;j<17;j=j+1'b1)begin
		
			if(ped_8[j]<ped_8[i])begin
			temp[i]	=	ped_8[i];
			ped_8[i]	=	ped_8[np];
			ped_8[np]	=	temp[i];
			temp1[i]	=	index_8[i];
			index_8[i]	=	index_8[np];
			index_8[np]	=	temp1[i];
			end
			
		end
		end
	//[ped_sort_8(1:40,1,k),index_8(1:40,1,k)] = sort(ped_8(1:40,1,k));
    
	//sign_8_1[i] = sign_buffer_8_1[index_8[i]];
	for(i=0;i<40;i=i+1'b1)begin
    sign_8_1[i] = sign_buffer_8_1[index_8[i]];//
	sign_8_2[i] = sign_buffer_8_2[index_8[i]];
	sign_8_3[i] = sign_buffer_8_3[index_8[i]];
	sign_8_4[i] = sign_buffer_8_4[index_8[i]];
	sign_8_5[i] = sign_buffer_8_5[index_8[i]];
	sign_8_6[i] = sign_buffer_8_6[index_8[i]];
	sign_8_7[i] = sign_buffer_8_7[index_8[i]];
	sign_8_8[i] = sign_buffer_8_8[index_8[i]];
	end
	
	//sign_8_1(1:40) = sign_buffer_8_1(index_8(1:40));
	//sign_8_2(1:40) = sign_buffer_8_2(index_8(1:40));
	//sign_8_3(1:40) = sign_buffer_8_3(index_8(1:40));
	//sign_8_4(1:40) = sign_buffer_8_4(index_8(1:40));
	//sign_8_5(1:40) = sign_buffer_8_5(index_8(1:40));
	//sign_8_6(1:40) = sign_buffer_8_6(index_8(1:40));
	//sign_8_7(1:40) = sign_buffer_8_7(index_8(1:40));
	//sign_8_8(1:40) = sign_buffer_8_8(index_8(1:40));
	//si_1[i] = sign_8_1[i];
	for(i=0;i<40;i=i+1'b1)begin
	si_1[i] = sign_8_1[i];
	si_2[i] = sign_8_2[i];
	si_3[i] = sign_8_3[i];
	si_4[i] = sign_8_4[i];
	si_5[i] = sign_8_5[i];
	si_6[i] = sign_8_6[i];
	si_7[i] = sign_8_7[i];
	si_8[i] = sign_8_8[i];
	end
    //40*8
    //y2最後才用到用來比對pedsort和si_temp
    //前面都是在算y後面才在算
	
    //要得是si跟
    
    //再做一次y2的以防錯誤
    //if(ped_sort_8(1,1,k)>0.05)
    //         [ped_sort(:,:,k),si_temp(:,:,k)] = qam64error(y2(:,:,k),R2(:,:,k));
    //         
    //        if(ped_sort_8(1,1,k)>ped_sort(1,1,k))
    //         si(:,:,k)=si_temp(:,:,k);
    //         ped_sort_8(:,:,k)=ped_sort(:,:,k);
    //        end
    //end
    //這裡看不太懂
	
	
    //for i=1:4
    //si2(:,i,k)=si(:,2*i-1,k);
    //si2(:,i+4,k)=si(:,2*i,k);
    //end
	for(i=0;i<40;i=i+1'b1)begin
	//好像是下面的一絲
	si2_1[i] = si_1[i];
	si2_5[i] = si_2[i];
	si2_2[i] = si_3[i];
	si2_6[i] = si_4[i];
	si2_3[i] = si_5[i];
	si2_7[i] = si_6[i];
	si2_4[i] = si_7[i];
	si2_8[i] = si_8[i];
	end
end
endmodule
	