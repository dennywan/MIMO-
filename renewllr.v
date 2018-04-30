//for n = 1:8
//[bit1_llr1(n,:,k),bit2_llr1(n,:,k),bit3_llr1(n,:,k)] = ...
//         renew_llr_2_previously(ped_sort_8(:,1,k),si2(:,n,k),1,8);                    
//flag_1 = 1;
//flag_2 = 1;
//flag_3 = 1;
//flag_4 = 1;
//flag_5 = 1;
//flag_6 = 1;
//ped_reg_1 = zeros(k,1);
//ped_reg_2 = zeros(k,1);
//ped_reg_3 = zeros(k,1);
//ped_reg_4 = zeros(k,1);
//ped_reg_5 = zeros(k,1);
//ped_reg_6 = zeros(k,1);
//aa = zeros(1,2);
//bb = zeros(1,2);
//cc = zeros(1,2);
//
max_llr=1000;
   
function[aa,bb,cc] = renew_llr_2_previously(ped_sort,sign_buffer,n,k);
 //#eml
parameter n=1;
parameter k=8;
for (a = 0; a< k ; a= a+1'b1)begin
    if(flag_1 == 1 || flag_2 == 1)begin
        if(sign_buffer(a,n,1) == 1/sqrt(42) || sign_buffer(a,n,1) == -1/sqrt(42) || 
		sign_buffer(a,n,1) == 7/sqrt(42) || sign_buffer(a,n,1) == -7/sqrt(42))begin
           ped_reg_1(flag_1,1) = ped_sort(a,1,1);
           flag_1 = flag_1 + 1;
		   end
        else if(sign_buffer(a,n,1) == 3/sqrt(42) || sign_buffer(a,n,1) == -3/sqrt(42) ||
		sign_buffer(a,n,1) == 5/sqrt(42) || sign_buffer(a,n,1) == -5/sqrt(42))begin
           ped_reg_2(flag_2,1) = ped_sort(a,1,1);
           flag_2 = flag_2 + 1;
		   end
        end
    else begin
        break
    end
end
	
 
        if(flag_1 == 1) begin                                                                                                                               
//             ped_reg_1(1) = buffer_1bit(n,1);                                                                                                                  
            ped_reg_1(1) = max_llr;                                                                                                                                   
//             for b = 1:n-1                                                                                                                                     
//                 ped_reg_1(1) = ped_reg_1(1) + error(1,b);                                                                                                     
		end                                                                                                                                               
        else if(flag_2 == 1)    begin                                                                                                                           
//             ped_reg_2(1) = buffer_1bit(n,2);                                                                                                                  
            ped_reg_2(1) = max_llr;                                                                                                                                   
//             for b = 1:n-1                                                                                                                                     
//                 ped_reg_2(1) = ped_reg_2(1) + error(1,b);                                                                                                     
//             end                                                                                                                                               
        end  
////
for(a = 0; a< k ; a= a+1'b1)begin
    if(flag_3 == 1 || flag_4 == 1)begin
        if(sign_buffer(a,n,1) == 5/sqrt(42) || sign_buffer(a,n,1) == -5/sqrt(42) || 
		sign_buffer(a,n,1) == 7/sqrt(42) || sign_buffer(a,n,1) == -7/sqrt(42))begin
           ped_reg_3(flag_3,1) = ped_sort(a,1,1);
           flag_3 = flag_3 + 1;
		   end
        else if(sign_buffer(a,n,1) == 1/sqrt(42) || sign_buffer(a,n,1) == -1/sqrt(42) ||
		sign_buffer(a,n,1) == 3/sqrt(42) || sign_buffer(a,n,1) == -3/sqrt(42))begin
           ped_reg_4(flag_4,1) = ped_sort(a,1,1);
           flag_4 = flag_4 + 1;
        end
	end
    else begin
        break
    end
end     


        if(flag_3 == 1)begin                                                                                                                                   
//             ped_reg_3(1) = buffer_2bit(n,1);                                                                                                                  
             ped_reg_3(1) = max_llr;                                                                                                                                  
//             for b = 1:n-1                                                                                                                                     
//                 ped_reg_3(1) = ped_reg_3(1) + error(1,b);                                                                                                     
          end                                                                                                                                               
        else if(flag_4 == 1)begin                                                                                                                                
//             ped_reg_4(1) = buffer_2bit(n,2);                                                                                                                  
             ped_reg_4(1) = max_llr;                                                                                                                                  
//             for b = 1:n-1                                                                                                                                     
//                 ped_reg_4(1) = ped_reg_4(1) + error(1,b);                                                                                                     
//             end                                                                                                                                               
        end  
////

for (a = 0; a< k ; a= a+1'b1)begin
    if(flag_5 == 1 || flag_6 == 1)begin
        if(sign_buffer(a,n,1) == 1/sqrt(42) || sign_buffer(a,n,1) == 3/sqrt(42) ||
		sign_buffer(a,n,1) == 5/sqrt(42) || sign_buffer(a,n,1) == 7/sqrt(42))begin
           ped_reg_5(flag_5,1) = ped_sort(a,1,1);
           flag_5 = flag_5 + 1;
		   end
        else if(sign_buffer(a,n,1) == -1/sqrt(42) || sign_buffer(a,n,1) == -3/sqrt(42) || 
		sign_buffer(a,n,1) == -5/sqrt(42) || sign_buffer(a,n,1) == -7/sqrt(42))begin
           ped_reg_6(flag_6,1) = ped_sort(a,1,1);
           flag_6 = flag_6 + 1;
		   end
        end
    else begin
        break
    end
end     
      

	  if(flag_5 == 1)begin                                                                                                                                   
//             ped_reg_5(1) = buffer_3bit(n,1);                                                                                                                  
             ped_reg_5(1) = max_llr;                                                                                                                                  
//             for b = 1:n-1                                                                                                                                     
//                 ped_reg_5(1) = ped_reg_5(1) + error(1,b);                                                                                                     
            end                                                                                                                                               
        else if(flag_6 == 1)begin                                                                                                                             
//             ped_reg_6(1) = buffer_3bit(n,2);                                                                                                                  
             ped_reg_6(1) = max_llr;                                                                                                                                  
//             for b = 1:n-1                                                                                                                                     
//                 ped_reg_6(1) = ped_reg_6(1) + error(1,b);                                                                                                     
//             end                                                                                                                                               
        end 
		
		for(i=0;i<8;i=i+1'b1)begin
		aa_1[i] = ped_reg_1[1];
		aa_2[i] = ped_reg_2[1];
		bb_1[i] = ped_reg_3[1];
		bb_2[i] = ped_reg_4[1];
		cc_1[i] = ped_reg_5[1];
		cc_2[i] = ped_reg_6[1];
		//ped_reg_1是8x1 1個數塞進aa?
		end
		
endfunction