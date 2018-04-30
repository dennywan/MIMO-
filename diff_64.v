//function [signal_out] = diff_64(l_error,R)

function [12*8-1:0]diff_64;

input [11:0]L_error_3;
input [11:0]R66;
//reg_L         = zeros(1,1);
//reg_1         = zeros(1,1);
//reg_2         = zeros(1,1);
//reg_4         = zeros(1,1);
//t1            = zeros(1,1);
//t2            = zeros(1,1);
//t3            = zeros(1,1);
//t4            = zeros(1,1);
//t5            = zeros(1,1);
//t6            = zeros(1,1);
//T             = zeros(1,1);
//sign_reg      = zeros(1,1);
//signal_reg_1  = zeros(1,8);
//signal_reg    = zeros(1,8);
//signal_out    = zeros(1,8);
parameter [11:0]pos1 = 12'd256;
parameter [11:0]pos3 = 12'd768;
parameter [11:0]pos5 = 12'd1280;
parameter [11:0]pos7 = 12'd1792;
parameter [11:0]neg1 = ;//之後想//
parameter [11:0]neg3 = ;
parameter [11:0]neg5 = ;
parameter [11:0]neg7 = ;
parameter signed sqrt_42 =	12'b0_110_0111_1011;//6.4807406984


reg [3:0]signal_reg_1[0:7];

begin

if(L_error_3[11]=1'b1)begin
		reg_L = L_error_3[];//幫我想2補數
	end
else begin
		reg_L = L_error_3;
	end
	
if(R66[11]=1'b1)begin
		R66[];//幫我想2補數
	end
else begin
		R66 = R66;
	end

reg_1   = R66/12'b0_110_0111_1011;
//parameter signed sqrt_42 =	12'b0_110_0111_1011;//6.4807406984
reg_2    = reg_1 * 2'd2;
reg_4    = reg_1 * 3'd4;

t1 = (reg_L>reg_1) ? 1'b1:1'b0;
t2 = (reg_L>reg_2) ? 1'b1:1'b0;
t3 = (reg_L>(reg_1+reg_2)) ? 1'b1:1'b0;
t4 = (reg_L>reg_4) ? 1'b1:1'b0;
t5 = (reg_L>(reg_1+reg_4)) ? 1'b1:1'b0;
t6 = (reg_L>(reg_2+reg_4)) ? 1'b1:1'b0;
T =  t1+t2+t3+t4+t5+t6;
sign_L = ( L_error_3[11]==1'b0 && L_error_3!= 12'b0) ? 1'b1:1'b0;
sign_R = ( R66[11]==1'b0 && R66!= 12'b0) ? 1'b1:1'b0;
sign_reg = sign_L^sign_R ;//xor

//sign_reg(1,1) = xor(sign(l_error)>0,sign(R)>0);
//如果指令內的參數大於0, 那就會傳回1, 如果等於0, 那就會傳回0, 如果是小於0, 那麼就會傳回-1,

if(T == 3'd0)begin
    signal_reg_1[0] = pos1; 	//%  1
    signal_reg_1[1] = neg1;	// % -1
    signal_reg_1[2] = pos3; 	//%  3
    signal_reg_1[3] = neg3;	// % -3
    signal_reg_1[4] = pos5; 	//%  5
    signal_reg_1[5] = neg5;	// % -5
    signal_reg_1[6] = pos7; 	//%  7
    signal_reg_1[7] = neg7;	// % -7
	end	                    
else if(T == 3'd1)begin	            
    signal_reg_1[0] = pos1; 	//%  1
    signal_reg_1[1] = pos3; 	//%  3
    signal_reg_1[2] = neg1;	// % -1
    signal_reg_1[3] = pos5; 	//%  5
    signal_reg_1[4] = neg3;	// % -3
    signal_reg_1[5] = pos7; 	//%  7
    signal_reg_1[6] = neg5;	// % -5
    signal_reg_1[7] = neg7;	// % -7
	end
else if(T == 3'd2)begin	           
    signal_reg_1[0] = pos3; 	//%  3
    signal_reg_1[1] = pos1; 	//%  1
    signal_reg_1[2] = pos5; 	//%  5
    signal_reg_1[3] = neg1;	// % -1
    signal_reg_1[4] = pos7; 	//%  7
    signal_reg_1[5] = neg3;	// % -3
    signal_reg_1[6] = neg5;	// % -5
    signal_reg_1[7] = neg7;	// % -7
	end
else if(T == 3'd3)	begin           
    signal_reg_1[0] = pos3; 	//%  3
    signal_reg_1[1] = pos5; 	//%  5
    signal_reg_1[2] = pos1; 	//%  1
    signal_reg_1[3] = pos7; 	//%  7
    signal_reg_1[4] = neg1;	// % -1
    signal_reg_1[5] = neg3;	// % -3
    signal_reg_1[6] = neg5;	// % -5
    signal_reg_1[7] = neg7;	// % -7
	end
else if(T == 3'd4)	begin         
    signal_reg_1[0] = pos5; 	//%  5
    signal_reg_1[1] = pos3; 	//%  3
    signal_reg_1[2] = pos7; 	//%  7
    signal_reg_1[3] = pos1; 	//%  1
    signal_reg_1[4] = neg1;	// % -1
    signal_reg_1[5] = neg3;	// % -3
    signal_reg_1[6] = neg5;	// % -5
    signal_reg_1[7] = neg7;	// % -7
	end
else if(T == 3'd5)	 begin           
    signal_reg_1[0] = pos5; 	//%  5
    signal_reg_1[1] = pos7; 	//%  7
    signal_reg_1[2] = pos3; 	//%  3
    signal_reg_1[3] = pos1; 	//%  1
    signal_reg_1[4] = neg1;	// % -1
    signal_reg_1[5] = neg3;	// % -3
    signal_reg_1[6] = neg5;	// % -5
    signal_reg_1[7] = neg7;	// % -7
	end
else if(T == 3'd6)	 begin           
    signal_reg_1[0] = pos7; 	//%  7
    signal_reg_1[1] = pos5; 	//%  5
    signal_reg_1[2] = pos3; 	//%  3
    signal_reg_1[3] = pos1; 	//%  1
    signal_reg_1[4] = neg1;	// % -1
    signal_reg_1[5] = neg3;	// % -3
    signal_reg_1[6] = neg5;	// % -5
    signal_reg_1[7] = neg7;	// % -7
	end


if (sign_reg == 1'b0)begin
    signal_reg[0] = signal_reg_1[0];
    signal_reg[1] = signal_reg_1[1];
    signal_reg[2] = signal_reg_1[2];
    signal_reg[3] = signal_reg_1[3];
    signal_reg[4] = signal_reg_1[4];
    signal_reg[5] = signal_reg_1[5];
    signal_reg[6] = signal_reg_1[6];
    signal_reg[7] = signal_reg_1[7];
	end
else begin
    signal_reg[0] = become(signal_reg_1[0]);
    signal_reg[1] = become(signal_reg_1[1]);
    signal_reg[2] = become(signal_reg_1[2]);
    signal_reg[3] = become(signal_reg_1[3]);
    signal_reg[4] = become(signal_reg_1[4]);
    signal_reg[5] = become(signal_reg_1[5]);
    signal_reg[6] = become(signal_reg_1[6]);
    signal_reg[7] = become(signal_reg_1[7]);
end

	
	signal_out[0] = signal_reg[0] / sqrt_42;//把前面的1/根號42等等等長數拿來用
	signal_out[1] = signal_reg[1] / sqrt_42;//不要除sqrt42
	signal_out[2] = signal_reg[2] / sqrt_42;//後面會用到比對一樣的值
	signal_out[3] = signal_reg[3] / sqrt_42;
	signal_out[4] = signal_reg[4] / sqrt_42;
	signal_out[5] = signal_reg[5] / sqrt_42;
	signal_out[6] = signal_reg[6] / sqrt_42;
	signal_out[7] = signal_reg[7] / sqrt_42;
	
	diff_64={signal_out[7],signal_out[6],signal_out[5],signal_out[4],signal_out[3],signal_out[2],signal_out[1],signal_out[0]};
end       

endfunction