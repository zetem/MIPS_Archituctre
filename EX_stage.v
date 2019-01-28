module EX_stage
(
input							clk,
input							rst,
input							enable,
input			   [62:0]	pipline_reg_in,
output	reg 	[37:0]	pipline_reg_out,
output			[2:0]		ex_op_dest,

//////////////////FW//////////////////
input 			[1:0]		forwarding_sel_1,
input 			[1:0]		forwarding_sel_2,
input 			[15:0]	Mem_data,
input 			[15:0]	WB_data,

output			mem_or_reg
);

reg [15:0] alu_input_1;
reg [15:0] alu_input_2;

wire [15:0] a , b ;
wire [2:0]  cmd ;
wire [15:0] r ;

wire mem_write;
wire [15:0] mem_data_ex;
wire [15:0] temp;

assign cmd	 = pipline_reg_in[56:54];
assign a 	 = pipline_reg_in[53:38];
assign b		 = pipline_reg_in[37:22];

always @(*)
begin
	case(forwarding_sel_1) 
		2'd0: alu_input_1 = a;
		2'd1:	alu_input_1 = Mem_data;
		2'd2:	alu_input_1 = WB_data;
	endcase
	case(forwarding_sel_2) 
		2'd0: alu_input_2 = b;
		2'd1:	alu_input_2 = Mem_data;
		2'd2:	alu_input_2 = WB_data;
	endcase
	
	if ( mem_write )
	alu_input_2 =b;
end

alu	alu_unit(alu_input_1 , alu_input_2 , cmd , r);
	
//////////////// HD ////////////////////
assign ex_op_dest = (pipline_reg_in[4]) ? pipline_reg_in[3:1] : 3'b0 ;
assign mem_or_reg = pipline_reg_in[0];

/////////////////FW//////////////////
assign mem_write = pipline_reg_in[21];
assign mem_data_ex  = pipline_reg_in[20:5];

assign temp = (forwarding_sel_2 == 2'd1) ? Mem_data : ( (forwarding_sel_2 == 2'd2) ? WB_data : mem_data_ex ) ;

///////////////////////////////////

always@(posedge clk)
	begin
	if(rst) pipline_reg_out = 38'b0;
	else if (!enable)
		begin
			pipline_reg_out[37:22] <= r;
			pipline_reg_out[21:5]  <= {mem_write , temp };
			pipline_reg_out[4:0]   <= pipline_reg_in[4:0];
		end
	end


endmodule