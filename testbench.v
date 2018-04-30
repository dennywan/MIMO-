`timescale 1ns / 1ps

`define RECEIVED_SIGNAL_1 "y_input1.txt"
`define R_MATRIX_ROW_1 "R_input1.txt"
`define RECEIVED_SIGNAL_2 "y_input2.txt"
`define R_MATRIX_ROW_2 "R_input2.txt"
module testbench;
	
	reg clk;
	reg rstn;
	
	//reg [11:0]YDE[0:287];
	//3+8//+1signed
	//��Ƶ곡����11��bit ��2 �ҥH�n12bit
	//0:287�٨S���Q��O������
	//288/8�O36 ����ԣ��n36
	//R���Ȧ�36�өҥHy�]��36��?
	//�i�O�ڭ̪�yin�����
	//�o�ˬO�@�ժ���
	//���n�b����50��
	//�ڰ��]�@�������Y�ȶi�h
	reg [11:0]YDE1[0:7];
	reg [11:0]YDE2[0:7];
	//�n50��y���ܴN�n8*50-1
	//���R_matric�i�h
	reg [11:0] R_mat1 [0:35];
	reg [11:0] R_mat2 [0:35];
	           
	reg [11:0]R_mat1_reg;
	reg [11:0]R_mat2_reg;
	reg [11:0]YDE1_reg;
	reg [11:0]YDE2_reg;
	//�n50��r���ܴN�n36*50-1
	//r�]�����
	
	reg [7:0]LLR[0:23];
	
	//reg [7:0]  R_mat;
	//R����
	//reg [23:0] Y_cur;
	//�Ѩ��[11:0]YDE�զX
	//�����D��ԣ�|�o��
	
	qam64varcal3(.clk(clk),.rstn(rstn),.YDE1(YDE1_reg),.YDE2(YDE2_reg),.R_mat1(R_mat1_reg).R_mat1(R_mat2_reg),.LLR(LLR));
	
	
	//��X�٨S�Q��
	//���ӬOllr��
	//�p�G24��llr�� ���N��X[11:0]reg[0:23]
	//���Ӱ�
	initial begin
                clk = 0;
                rstn = 0;
                #20 rstn = 1;
                #5000 $finish;
        end
	
	initial $readmemb(`RECEIVED_SIGNAL1_1,y1);
	initial $readmemb(`RECEIVED_SIGNAL1_2,y2);
    initial $readmemb(`R_MATRIX_ROW_1,r1);
	initial $readmemb(`R_MATRIX_ROW_1,r2);
	
	 always 
          #5 clk = ~clk;
	

//���`�p�ƾ�	

reg [11:0] System_cnt;
	//���L�@�ӭp�ƾ�
always @ (posedge clk or negedge rstn) begin
if (~rstn )
  System_cnt <= 12'd0;
else
  System_cnt <= System_cnt +12'd1; 

end


//in_space_cnt�p��34�ɳ��O0 ����35�ɶ}�l�p�� 0101
//reg [1:0] in_space_cnt;
//
//always @ (posedge clk or negedge rstn) begin
//if (~rstn ||System_cnt < 12'd34)
//  in_space_cnt <= 2'd0;
//else if (in_space_cnt == 2'd2)
//  in_space_cnt <= 2'd1;
//else
//  in_space_cnt <= in_space_cnt +2'd1; 
//
//end
//
//
//reg [10:0] input_count;
/////input_count�q36��}�l�p�� �C������� ���F�᭱�� y cur
//always @ (posedge clk or negedge rstn) begin
//if (~rstn)
//  input_count <= 10'd0;
//else if  (input_count >= 10'd25)
//  input_count <= input_count;
//else
//  input_count <= ( System_cnt > 12'd35)? input_count +10'd2 : input_count; 
//
//end

//�@���Ǩ��y  �ݤ����� �̦h����24
//always @ (posedge clk or negedge rstn) begin
//if (~rstn || System_cnt < 12'd36|| input_count >= 10'd24)
//  Y_cur <= 24'd0; 
//else
//  Y_cur <= {YDE[input_count],YDE[input_count+1]} ; 
//end      

reg [5:0] R_count;
//�U���Sԣ���D	 
///R_matrix input memory and feed into register///
always @ (posedge clk or negedge rstn) begin
if (~rstn )
  R_count <= 6'd0;
else
  R_count <=  (R_count == 6'd37)? R_count: R_count +6'd1; 

end     
		
//R_MATRIX R88->R77->R78->R66->....->R17->R18
always @ (posedge clk or negedge rstn) begin
if (~rstn )
    R_mat1_reg <= 8'd0;
	R_mat2_reg <= 8'd0;
else
    R_mat1_reg <= (R_count < 6'd36)? R_mat1[R_count]:8'd0; 
	R_mat2_reg <= (R_count < 6'd36)? R_mat2[R_count]:8'd0; 
end             

reg [5:0] Y_count;
//�U���Sԣ���D	 
///YDE input memory and feed into register///
always @ (posedge clk or negedge rstn) begin
if (~rstn )
  Y_count <= 6'd0;
else
  Y_count <=  (Y_count == 6'd9)? Y_count: Y_count +6'd1; 

end     
		
//�s��i�J
always @ (posedge clk or negedge rstn) begin
if (~rstn )
    YDE1_reg <= 8'd0;
	YDE2_reg <= 8'd0;
else
    YDE1_reg <= (Y_count < 6'd8)? YDE1[Y_count]:8'd0; 
	YDE2_reg <= (Y_count < 6'd8)? YDE2[Y_count]:8'd0; 
end             

endmodule


