module FSM();
input clk,reset;
parameter[2:0]S0,S1,S2;

always@(current_state or dat1 or data2)begin
	case(current_state)
	S0:	begin
		next_state = S1;
		end
	S1:	begin
		next_state = S2;
		end
	S2:	begin
		next_state = S0;
		end
	default:begin
			next_state = next_state;
			end
	
	
end

always@(posedge clk or negedge reset)begin
	if(~reset)
		current_state <=S0;
		else 
			current_state <= next_state;
end

endmodule

