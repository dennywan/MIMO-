`timescale 1ns/1ps

module Detector_TOP(clk,
					rstn,
					YDE1,
					YDE2,
					R_mat1,
					R_mat2,
					LLR
					);

//應該會有12imag 34imag 12real 34real

input clk,rstn;

input [7:0] R_mat1;//
input [7:0] R_mat2;//

input [10:0]YDE1;
input [10:0]YDE2;

reg [7:0]LLR[0:23];

//register declare
reg [8*36-1:0] R_element;
reg [5:0] R_mat_count;

reg [11 :0] Y_8;
reg [23 :0] Y_7;
reg [47 :0] Y_6;
reg [83 :0] Y_5;
reg [107:0] Y_4;
reg [131:0] Y_3;
reg [167:0] Y_2;
reg [191:0] Y_1;

reg [6:0] system_cnt;
reg [4:0] system_cnt_16;

reg [3:0] llr_out_cnt16;

//Detector_TOP wire declare

//////R matrix element wire  
wire [7:0] R88,R77,R78,R66,R67,R68,R55,R56,R57,R58,R44,R45,R46,R47,R48,
           R33,R34,R35,R36,R37,R38,R22,R23,R24,R25,R26,R27,R28,
			  R11,R12,R13,R14,R15,R16,R17,R18;
wire [14:0] ped8_1,ped8_2;//,ped8_3,ped8_4,ped8_5,ped8_6,ped8_7,ped8_8
wire [17:0] ped7_1,ped7_2;//,ped7_3,ped7_4,ped7_5,ped7_6,ped7_7,ped7_8
wire [20:0] ped6_1,ped6_2;//,ped6_3,ped6_4,ped6_5,ped6_6,ped6_7,ped6_8
wire [23:0] ped5_1,ped5_2;//,ped5_3,ped5_4,ped5_5,ped5_6,ped5_7,ped5_8
wire [26:0] ped4_1,ped4_2;//,ped4_3,ped4_4,ped4_5,ped4_6,ped4_7,ped4_8
wire [29:0] ped3_1,ped3_2;//,ped3_3,ped3_4,ped3_5,ped3_6,ped3_7,ped3_8
wire [32:0] ped2_1,ped2_2;//,ped2_3,ped2_4,ped2_5,ped2_6,ped2_7,ped2_8
wire [35:0] ped1_1,ped1_2;//,ped1_3,ped1_4,ped1_5,ped1_6,ped1_7,ped1_8

wire [4:0]  layer7_cnt,layer6_cnt,layer5_cnt,layer4_cnt,layer3_cnt,layer2_cnt,layer1_cnt ;

//llr wire declare
wire [8:0] imag4_bit1,imag4_bit2,imag4_bit3;
wire [8:0] imag3_bit1,imag3_bit2,imag3_bit3;
wire [8:0] imag2_bit1,imag2_bit2,imag2_bit3;
wire [8:0] imag1_bit1,imag1_bit2,imag1_bit3;
wire [8:0] real4_bit1,real4_bit2,real4_bit3;
wire [8:0] real3_bit1,real3_bit2,real3_bit3;
wire [8:0] real2_bit1,real2_bit2,real2_bit3;
wire [8:0] real1_bit1,real1_bit2,real1_bit3;

                                               
wire [15:0] R_row7;
wire [23:0] R_row6;
wire [31:0] R_row5;
wire [39:0] R_row4;
wire [47:0] R_row3;
wire [55:0] R_row2;
wire [63:0] R_row1;

assign R_row7 = {R78,R77};                        
assign R_row6 = {R68,R67,R66};                    
assign R_row5 = {R58,R57,R56,R55};                
assign R_row4 = {R48,R47,R46,R45,R44};            
assign R_row3 = {R38,R37,R36,R35,R34,R33};        
assign R_row2 = {R28,R27,R26,R25,R24,R23,R22};    
assign R_row1 = {R18,R17,R16,R15,R14,R13,R12,R11};

/////////////////////feed R_mat into R_element in sequential order 
/////////////////////(8,8) (7,7) (7,8) (6,6) (6,7) (6,8) ........(1,1)... (1,8)                           
assign {R88,R77,R78,R66,R67,R68} = {R_element[8*36-1:8*35] ,R_element[8*35-1:8*34] , R_element[8*34-1:8*33] 
                                      ,R_element[8*33-1:8*32],R_element[8*32-1:8*31],R_element[8*31-1:8*30]};
assign {R55,R56,R57,R58,R44,R45} = {R_element[8*30-1:8*29] ,R_element[8*29-1:8*28] , R_element[8*28-1:8*27] 
                                      ,R_element[8*27-1:8*26],R_element[8*26-1:8*25],R_element[8*25-1:8*24]};
assign {R46,R47,R48,R33,R34,R35} = {R_element[8*24-1:8*23] ,R_element[8*23-1:8*22] , R_element[8*22-1:8*21] 
                                      ,R_element[8*21-1:8*20],R_element[8*20-1:8*19],R_element[8*19-1:8*18]};
assign {R36,R37,R38,R22,R23,R24} = {R_element[8*18-1:8*17] ,R_element[8*17-1:8*16] , R_element[8*16-1:8*15] 
                                      ,R_element[8*15-1:8*14],R_element[8*14-1:8*13],R_element[8*13-1:8*12]};
assign {R25,R26,R27,R28,R11,R12} = {R_element[8*12-1:8*11] ,R_element[8*11-1:8*10] , R_element[8*10-1:8*9] 
                                           ,R_element[8*9-1:8*8],R_element[8*8-1:8*7],R_element[8*7-1:8*6]};
assign {R13,R14,R15,R16,R17,R18} = {R_element[8*6-1:8*5] ,R_element[8*5-1:8*4] , R_element[8*4-1:8*3] 
                                      ,R_element[8*3-1:8*2],R_element[8*2-1:8*1],R_element[8*1-1:8*0]};
									  									  
////////////////////////////	
layer8_process layer8_process(.clk(clk),.rstn(rstn),.Y_cur(Y_8),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),.R88(R88),
               .ped8_1(ped8_1),.ped8_2(ped8_2));

layer7_process layer7_process(.clk(clk),.rstn(rstn),.Y_cur_7(Y_7[23:12]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R78_77(R_row7),.layer7_cnt(layer7_cnt),.ped8_1(ped8_1),.ped8_2(ped8_2),.ped7_1(ped7_1),.ped7_2(ped7_2));
						
								
layer6_process layer6_process(.clk(clk),.rstn(rstn),.Y_cur_6(Y_6[47:36]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R68_67_66(R_row6),.layer6_cnt(layer6_cnt),.ped7_1(ped7_1),.ped7_2(ped7_2),.ped6_1(ped6_1),.ped6_2(ped6_2)); 

					   						
				
layer5_process layer5_process(.clk(clk),.rstn(rstn),.Y_cur_5(Y_5[83:72]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R58_57_56_55(R_row5),.layer5_cnt(layer5_cnt),.ped6_1(ped6_1),.ped6_2(ped6_2),.ped5_1(ped5_1),.ped5_2(ped5_2));
 					
					
layer4_process layer4_process(.clk(clk),.rstn(rstn),.Y_cur_4(Y_4[107:96]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R48_47_46_45_44(R_row4),.layer4_cnt(layer4_cnt),.ped5_1(ped5_1),.ped5_2(ped5_2),.ped4_1(ped4_1),.ped4_2(ped4_2));
					
				
			
layer3_process layer3_process(.clk(clk),.rstn(rstn),.Y_cur_3(Y_3[131:120]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R38_37_36_35_34_33(R_row3),.layer3_cnt(layer3_cnt),.ped4_1(ped4_1),.ped4_2(ped4_2),.ped3_1(ped3_1),.ped3_2(ped3_2));
					
					
					
layer2_process layer2_process(.clk(clk),.rstn(rstn),.Y_cur_2(Y_2[167:156]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R28_27_26_25_24_23_22(R_row2),.layer2_cnt(layer2_cnt),.ped3_1(ped3_1),.ped3_2(ped3_2),.ped2_1(ped2_1),.ped2_2(ped2_2));
					
				
				
layer1_process layer1_process(.clk(clk),.rstn(rstn),.Y_cur_1(Y_1[191:180]),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),
               .R18_17_16_15_14_13_12_11(R_row1),.layer1_cnt(layer1_cnt),.ped2_1(ped2_1),.ped2_2(ped2_2),.ped1_1(ped1_1),.ped1_2(ped1_2));
					
	               

llr8 llr8(.clk (clk),.rstn(rstn),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),.ped5_1(ped5_1),.ped5_2(ped5_2),
					.imag4_bit1(imag4_bit1),.imag4_bit2(imag4_bit2),.imag4_bit3(imag4_bit3));

llr7 llr7(.clk (clk),.rstn(rstn),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),.ped4_1(ped4_1),.ped4_2(ped4_2),
					.imag3_bit1(imag3_bit1),.imag3_bit2(imag3_bit2),.imag3_bit3(imag3_bit3));

llr6 llr6(.clk (clk),.rstn(rstn),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),.ped3_1(ped3_1),.ped3_2(ped3_2),
					.imag2_bit1(imag2_bit1),.imag2_bit2(imag2_bit2),.imag2_bit3(imag2_bit3));

llr5 llr5(.clk (clk),.rstn(rstn),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),.ped2_1(ped2_1),.ped2_2(ped2_2),
					.imag1_bit1(imag1_bit1),.imag1_bit2(imag1_bit2),.imag1_bit3(imag1_bit3));

llr4_1 llr4_1(.clk (clk),.rstn(rstn),.system_cnt(system_cnt),.system_cnt_16(system_cnt_16),.ped1_1(ped1_1),.ped1_2(ped1_2),            
.real1_bit1(real1_bit1),.real1_bit2(real1_bit2),.real1_bit3(real1_bit3),.real2_bit1(real2_bit1),.real2_bit2(real2_bit2),.real2_bit3(real2_bit3), 
.real3_bit1(real3_bit1),.real3_bit2(real3_bit2),.real3_bit3(real3_bit3),.real4_bit1(real4_bit1),.real4_bit2(real4_bit2),.real4_bit3(real4_bit3));

						  
always @ (posedge clk or negedge rstn) begin
if(~rstn ) 
  R_element <= 288'd0;
else if (R_mat_count < 6'd37) begin
  {R_element[8*36-1:8*35] ,R_element[8*35-1:8*34] , R_element[8*34-1:8*33] ,R_element[8*33-1:8*32],
   R_element[8*32-1:8*31],R_element[8*31-1:8*30],R_element[8*30-1:8*29],R_element[8*29-1:8*28],
        R_element[8*28-1:8*27],R_element[8*27-1:8*26],R_element[8*26-1:8*25],R_element[8*25-1:8*24],
        R_element[8*24-1:8*23],R_element[8*23-1:8*22],R_element[8*22-1:8*21],R_element[8*21-1:8*20],
        R_element[8*20-1:8*19],R_element[8*19-1:8*18],R_element[8*18-1:8*17],R_element[8*17-1:8*16],
        R_element[8*16-1:8*15],R_element[8*15-1:8*14],R_element[8*14-1:8*13],R_element[8*13-1:8*12],
        R_element[8*12-1:8*11],R_element[8*11-1:8*10],R_element[8*10-1:8*9],R_element[8*9-1:8*8],
        R_element[8*8-1:8*7],R_element[8*7-1:8*6],R_element[8*6-1:8*5],R_element[8*5-1:8*4],
        R_element[8*4-1:8*3],R_element[8*3-1:8*2],R_element[8*2-1:8*1],R_element[8*1-1:8*0]}<= 
        {R_element[8*35-1:8*34] , R_element[8*34-1:8*33] ,R_element[8*33-1:8*32],
   R_element[8*32-1:8*31],R_element[8*31-1:8*30],R_element[8*30-1:8*29],R_element[8*29-1:8*28],
        R_element[8*28-1:8*27],R_element[8*27-1:8*26],R_element[8*26-1:8*25],R_element[8*25-1:8*24],
        R_element[8*24-1:8*23],R_element[8*23-1:8*22],R_element[8*22-1:8*21],R_element[8*21-1:8*20],
        R_element[8*20-1:8*19],R_element[8*19-1:8*18],R_element[8*18-1:8*17],R_element[8*17-1:8*16],
        R_element[8*16-1:8*15],R_element[8*15-1:8*14],R_element[8*14-1:8*13],R_element[8*13-1:8*12],
        R_element[8*12-1:8*11],R_element[8*11-1:8*10],R_element[8*10-1:8*9],R_element[8*9-1:8*8],
        R_element[8*8-1:8*7],R_element[8*7-1:8*6],R_element[8*6-1:8*5],R_element[8*5-1:8*4],
        R_element[8*4-1:8*3],R_element[8*3-1:8*2],R_element[8*2-1:8*1],R_element[8*1-1:8*0],R_mat};
end     
end

//Wait until 36 R_mat element come into design
always @ (posedge clk or negedge rstn) begin
if(~rstn) 
R_mat_count <= 6'd0;
else 
R_mat_count <= (R_mat_count == 6'd37)? R_mat_count : R_mat_count + 6'd1;
end

always @ (posedge clk or negedge rstn) begin
if(~rstn) 
system_cnt <= 7'd0;
else if (system_cnt >= 7'd127)
system_cnt <= system_cnt;
else
system_cnt <= (R_mat_count >= 6'd36)? system_cnt + 7'd1 : system_cnt;
end

always @ (posedge clk or negedge rstn) begin
if(~rstn) 
system_cnt_16 <= 5'd0;
else if (system_cnt_16 >= 5'd4)
system_cnt_16 <= 5'd1;
else
system_cnt_16 <= (R_mat_count >= 6'd36)? system_cnt_16 + 5'd1 : system_cnt_16;
end

always @ (posedge clk or negedge rstn) begin
if(~rstn | system_cnt < 7'd45) 
llr_out_cnt16 <= 4'd0;
else if (llr_out_cnt16 >= 4'd4)
llr_out_cnt16 <= 4'd1;
else
llr_out_cnt16 <= llr_out_cnt16 + 4'd1 ;
end

always @ (posedge clk or negedge rstn) begin
if(~rstn | system_cnt < 7'd45)  begin            
imag4_bit1_temp  <= 99'b0 ;
imag4_bit2_temp  <= 99'b0 ;
imag4_bit3_temp  <= 99'b0 ;
imag3_bit1_temp  <= 72'b0 ;
imag3_bit2_temp  <= 72'b0 ;
imag3_bit3_temp  <= 72'b0 ;
imag2_bit1_temp  <= 54'b0 ;
imag2_bit2_temp  <= 54'b0 ;
imag2_bit3_temp  <= 54'b0 ;
imag1_bit1_temp  <= 27'b0 ;
imag1_bit2_temp  <= 27'b0 ;             
imag1_bit3_temp  <= 27'b0 ;
end       
else if (llr_out_cnt16 == 4'd1) begin         
imag4_bit1_temp  <={ imag4_bit1_temp [9*10-1:0] ,imag4_bit1} ;
imag4_bit2_temp  <={ imag4_bit2_temp [9*10-1:0] ,imag4_bit2} ;
imag4_bit3_temp  <={ imag4_bit3_temp [9*10-1:0] ,imag4_bit3} ;
imag2_bit1_temp  <={ imag2_bit1_temp [9*5-1:0] ,imag2_bit1} ;
imag2_bit2_temp  <={ imag2_bit2_temp [9*5-1:0] ,imag2_bit2} ;
imag2_bit3_temp  <={ imag2_bit3_temp [9*5-1:0] ,imag2_bit3} ;                
end
else if (llr_out_cnt16 == 4'd3) begin         
imag3_bit1_temp  <={ imag3_bit1_temp [9*8-1:0] ,imag3_bit1} ;
imag3_bit2_temp  <={ imag3_bit2_temp [9*8-1:0] ,imag3_bit2} ;
imag3_bit3_temp  <={ imag3_bit3_temp [9*8-1:0] ,imag3_bit3} ;
imag1_bit1_temp  <={ imag1_bit1_temp [9*2-1:0] ,imag1_bit1} ;
imag1_bit2_temp  <={ imag1_bit2_temp [9*2-1:0] ,imag1_bit2} ;
imag1_bit3_temp  <={ imag1_bit3_temp [9*2-1:0] ,imag1_bit3} ;                  
end
else  begin                                      
imag4_bit1_temp  <= imag4_bit1_temp ;
imag4_bit2_temp  <= imag4_bit2_temp ;
imag4_bit3_temp  <= imag4_bit3_temp ;
imag3_bit1_temp  <= imag3_bit1_temp ;
imag3_bit2_temp  <= imag3_bit2_temp ;
imag3_bit3_temp  <= imag3_bit3_temp ;
imag2_bit1_temp  <= imag2_bit1_temp ;
imag2_bit2_temp  <= imag2_bit2_temp ;
imag2_bit3_temp  <= imag2_bit3_temp ;
imag1_bit1_temp  <= imag1_bit1_temp ;
imag1_bit2_temp  <= imag1_bit2_temp ;
imag1_bit3_temp  <= imag1_bit3_temp ;
end     
end 

always @ (posedge clk or negedge rstn) begin
if(~rstn) begin
   Y_8 <=  12'b0;
   Y_7 <=  24'b0;
   Y_6 <=  48'b0;
   Y_5 <=  84'b0;
   Y_4 <= 108'b0;
   Y_3 <= 132'b0;
   Y_2 <= 168'b0;
   Y_1 <= 192'b0;
end
else  begin
case (system_cnt_16)
   5'd1 :begin  
	Y_8                     <=  Y_cur[23:12] ;   
	{Y_7[23 :12],Y_7[11:0]} <= {Y_7[11 :0],Y_cur[11:0]};
	end
   5'd2 :begin 
	{Y_6[47 :12],Y_6[11:0]} <= {Y_6[35 :0],Y_cur[23:12]} ;
	{Y_5[83 :12],Y_5[11:0]} <= {Y_5[71 :0],Y_cur[11:0]};
	end
   5'd3 :begin 
	{Y_4[107:12],Y_4[11:0]} <= {Y_4[95 :0],Y_cur[23:12]} ;
	{Y_3[131:12],Y_3[11:0]} <= {Y_3[119:0],Y_cur[11:0]} ;
	end
   5'd4 :begin 
	{Y_2[167:12],Y_2[11:0]} <= {Y_2[155:0],Y_cur[23:12]} ;
	{Y_1[191:12],Y_1[11:0]} <= {Y_1[179:0],Y_cur[11:0]} ;
	end
default begin
   Y_8 <= Y_8;
   Y_7 <= Y_7;
   Y_6 <= Y_6;
   Y_5 <= Y_5;
   Y_4 <= Y_4;
   Y_3 <= Y_3;
   Y_2 <= Y_2;
   Y_1 <= Y_1;
	end
endcase  
end
end

endmodule
