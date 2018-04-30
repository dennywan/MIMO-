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
	//實數虛部都有11個bit 乘2 所以要12bit
	//0:287還沒有想到是為什麼
	//288/8是36 但為啥剛好36
	//R的值有36個所以y也有36個?
	//可是我們的yin有兩個
	//這樣是一組的話
	//那要在哪做50組
	//我假設一次有兩個Y值進去
	reg [11:0]YDE1[0:7];
	reg [11:0]YDE2[0:7];
	//要50組y的話就要8*50-1
	//兩個R_matric進去
	reg [11:0] R_mat1 [0:35];
	reg [11:0] R_mat2 [0:35];
	           
	reg [11:0]R_mat1_reg;
	reg [11:0]R_mat2_reg;
	reg [11:0]YDE1_reg;
	reg [11:0]YDE2_reg;
	//要50組r的話就要36*50-1
	//r也有兩個
	
	reg [7:0]LLR[0:23];
	
	//reg [7:0]  R_mat;
	//R的值
	//reg [23:0] Y_cur;
	//由兩個[11:0]YDE組合
	//不知道為啥會這樣
	
	qam64varcal3(.clk(clk),.rstn(rstn),.YDE1(YDE1_reg),.YDE2(YDE2_reg),.R_mat1(R_mat1_reg).R_mat1(R_mat2_reg),.LLR(LLR));
	
	
	//輸出還沒想到
	//應該是llr值
	//如果24個llr值 那就輸出[11:0]reg[0:23]
	//應該啦
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
	

//正常計數器	

reg [11:0] System_cnt;
	//給他一個計數器
always @ (posedge clk or negedge rstn) begin
if (~rstn )
  System_cnt <= 12'd0;
else
  System_cnt <= System_cnt +12'd1; 

end


//in_space_cnt小於34時都是0 直到35時開始計數 0101
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
/////input_count從36秒開始計數 每次跳兩個 為了後面的 y cur
//always @ (posedge clk or negedge rstn) begin
//if (~rstn)
//  input_count <= 10'd0;
//else if  (input_count >= 10'd25)
//  input_count <= input_count;
//else
//  input_count <= ( System_cnt > 12'd35)? input_count +10'd2 : input_count; 
//
//end

//一次傳兩個y  看不太懂 最多跳到24
//always @ (posedge clk or negedge rstn) begin
//if (~rstn || System_cnt < 12'd36|| input_count >= 10'd24)
//  Y_cur <= 24'd0; 
//else
//  Y_cur <= {YDE[input_count],YDE[input_count+1]} ; 
//end      

reg [5:0] R_count;
//下面沒啥問題	 
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
//下面沒啥問題	 
///YDE input memory and feed into register///
always @ (posedge clk or negedge rstn) begin
if (~rstn )
  Y_count <= 6'd0;
else
  Y_count <=  (Y_count == 6'd9)? Y_count: Y_count +6'd1; 

end     
		
//連續進入
always @ (posedge clk or negedge rstn) begin
if (~rstn )
    YDE1_reg <= 8'd0;
	YDE2_reg <= 8'd0;
else
    YDE1_reg <= (Y_count < 6'd8)? YDE1[Y_count]:8'd0; 
	YDE2_reg <= (Y_count < 6'd8)? YDE2[Y_count]:8'd0; 
end             

endmodule


