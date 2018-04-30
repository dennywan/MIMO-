//[llr1(:,:,k),llr_reg1(:,:,k)] = operation_llr(bit3_llr1(:,:,k),bit2_llr1(:,:,k),bit1_llr1(:,:,k));
//4*6 = 8x2 8x2 8x2
//=aa_1[i] aa_2[i] bb_1[i] bb_2[i] cc_1[i] cc_2[i]
//好像不用llr_reg1
function[llr,llr_reg] = operation_llr(bit3_llr,bit2_llr,bit1_llr) //#eml 
//llr  = zeros(4,6);
//llr_reg  = zeros(4,6);
//llr_1[0:4]
//llr_2
//llr_3
//llr_4
//llr_5
//llr_6
//{
//   llr(1,1) = bit3_llr(1,1) - bit3_llr(1,2);
//   llr(2,1) = bit3_llr(2,1) - bit3_llr(2,2);
//   llr(3,1) = bit3_llr(3,1) - bit3_llr(3,2);
//   llr(4,1) = bit3_llr(4,1) - bit3_llr(4,2);
//   llr(1,4) = -(bit3_llr(5,1) - bit3_llr(5,2));
//   llr(2,4) = -(bit3_llr(6,1) - bit3_llr(6,2));
//   llr(3,4) = -(bit3_llr(7,1) - bit3_llr(7,2));
//   llr(4,4) = -(bit3_llr(8,1) - bit3_llr(8,2));
//   llr(1,2) = -(bit2_llr(1,1) - bit2_llr(1,2));
//   llr(2,2) = -(bit2_llr(2,1) - bit2_llr(2,2));
//   llr(3,2) = -(bit2_llr(3,1) - bit2_llr(3,2));
//   llr(4,2) = -(bit2_llr(4,1) - bit2_llr(4,2));
//   llr(1,5) = -(bit2_llr(5,1) - bit2_llr(5,2));
//   llr(2,5) = -(bit2_llr(6,1) - bit2_llr(6,2));
//   llr(3,5) = -(bit2_llr(7,1) - bit2_llr(7,2));
//   llr(4,5) = -(bit2_llr(8,1) - bit2_llr(8,2));
//   llr(1,3) = -(bit1_llr(1,1) - bit1_llr(1,2));
//   llr(2,3) = -(bit1_llr(2,1) - bit1_llr(2,2));
//   llr(3,3) = -(bit1_llr(3,1) - bit1_llr(3,2));
//   llr(4,3) = -(bit1_llr(4,1) - bit1_llr(4,2));
//   llr(1,6) = -(bit1_llr(5,1) - bit1_llr(5,2));
//   llr(2,6) = -(bit1_llr(6,1) - bit1_llr(6,2));
//   llr(3,6) = -(bit1_llr(7,1) - bit1_llr(7,2));
//   llr(4,6) = -(bit1_llr(8,1) - bit1_llr(8,2));
//}
for(n=0;n<4;n=n+1'b1)begin
   if (aa_l[i] = 1000)begin
   llr_1[n]=  1 ;
	end
   else if (aa_2[i]==1000)begin
   llr_1[n]= -1 ;
	end
   else begin//aa_l[i]-aa_2[i]
   llr_1[n] = aa_l[i]-aa_2[i];
   end
end
   
for(n=4;n<8;n=n+1'b1)begin
   if (aa_1[i]==1000)begin
   llr_4[n-4]= -1 ;
	end
   else if (aa_2[i]==1000)begin
   llr_4[n-4]=  1 ;
	end
   else begin
   llr_4[n-4] =  -(aa_1[i] - aa_2[i]);
	end
end

for(n=0;n<4;n=n+1'b1)begin
   if (bb_1[i]==1000)begin
   llr_2[n]= -1 ;
	end
   else if (bb_2[i]==1000)begin
   llr_2[n]=  1 ;
	end
   else begin
   llr_2[n] = -(bb_1[i] - bb_2[i]);
	end
end

for(n=4;n<8;n=n+1'b1)begin
   if (bb_1[i]==1000)begin
   llr_5[n-4]= -1 ;
   end
   else if (bb_2[i]==1000)begin
   llr_5[n-4]=  1 ;
   end
   else begin
   llr_5[n-4] =  -(bb_1[i] - bb_2[i]);
   end
end


for(n=0;n<4;n=n+1'b1)begin
   if (cc_1[i]==1000)begin
   llr_3[n]= -1 ;
   end
   else if (cc_1[2]==1000)begin
   llr_3[n]=  1 ;
   end
   else begin
   llr_3[n] = -(cc_1[i] - cc_1[2]);
   end
end

for(n=4;n<8;n=n+1'b1)begin
   if (cc_1[i]==1000)begin
   llr_6[n-4]= -1 ;
   end
   else if (cc_1[2]==1000)begin
   llr_6[n-4]=  1 ;
   end
   else begin
   llr_6[n-4] =  -(cc_1[i] - cc_1[2]);
   end
end

     ////
    //llr_reg(1,1) = llr(1,1) < 0;
    //llr_reg(2,1) = llr(2,1) < 0;
    //llr_reg(3,1) = llr(3,1) < 0;
    //llr_reg(4,1) = llr(4,1) < 0;
    //llr_reg(1,2) = llr(1,2) < 0;
    //llr_reg(2,2) = llr(2,2) < 0;
    //llr_reg(3,2) = llr(3,2) < 0;
    //llr_reg(4,2) = llr(4,2) < 0;
    //llr_reg(1,3) = llr(1,3) < 0;
    //llr_reg(2,3) = llr(2,3) < 0;
    //llr_reg(3,3) = llr(3,3) < 0;
    //llr_reg(4,3) = llr(4,3) < 0;
    //llr_reg(1,4) = llr(1,4) < 0;
    //llr_reg(2,4) = llr(2,4) < 0;
    //llr_reg(3,4) = llr(3,4) < 0;
    //llr_reg(4,4) = llr(4,4) < 0;
    //llr_reg(1,5) = llr(1,5) < 0;
    //llr_reg(2,5) = llr(2,5) < 0;
    //llr_reg(3,5) = llr(3,5) < 0;
    //llr_reg(4,5) = llr(4,5) < 0;
    //llr_reg(1,6) = llr(1,6) < 0;
    //llr_reg(2,6) = llr(2,6) < 0;
    //llr_reg(3,6) = llr(3,6) < 0;
    //llr_reg(4,6) = llr(4,6) < 0;
	
	
endfunction
end