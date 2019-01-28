module ID_stage
(
input							clk,
input							rst,
input							instruction_decode_en,
input 						enable,

output	reg	[62:0]	pipeline_reg_out,
input				[15:0]	instruction_in,
output			[5:0]		branch_offset_imm,
output						branch_taken,
output			[2:0]		reg_read_addr_1,
output			[2:0]		reg_read_addr_2,
input				[15:0]	reg_read_data_1,
input				[15:0]	reg_read_data_2,
output			[2:0]		decoding_op_src1,
output			[2:0]		decoding_op_src2,

/////////////FW///////////////////
output branch_en_stall
);

reg 				[15:0]		instruction;
wire 				[3:0]			op; 

/////////////////////////////////////////////////
always @(posedge clk)
begin 
	if(rst)
		instruction = 16'b0;
	else if ( ~instruction_decode_en )
		instruction <= instruction_in; 
end
//////////////////////////////////////////////////

assign op = (instruction_decode_en)? 4'b0 : instruction[15:12];
//assign op = instruction[15:12];
assign branch_en_stall = ( instruction_in[15:12] == 4'b1100 ) ? 1 : 0;

assign reg_read_addr_1 =  instruction[8:6]; 
assign reg_read_addr_2 = ( instruction[15:12] == 4'b1011 )  ?  instruction[11:9] : instruction[5:3]; // if store 

assign branch_offset_imm = instruction [5:0];

wire write_back_en,write_back_result_mux, mem_write_en,mux_imm_or_reg;
wire branch_en;
wire [15:0] offset , reg_read_data_2_mux;
wire [2:0]alu_opcode;

controller Ctrlr( op ,write_back_en,write_back_result_mux, mem_write_en, branch_en,mux_imm_or_reg ,alu_opcode);

assign offset = { instruction[5], instruction[5], instruction[5], instruction[5], instruction[5], instruction[5], instruction[5], instruction[5], instruction[5], instruction[5], instruction[5:0] };
assign reg_read_data_2_mux = (mux_imm_or_reg) ? offset : reg_read_data_2;


always@(posedge clk)
	begin
	if(rst) begin pipeline_reg_out=63'b0; end
	
	else if ( !enable )
		begin 	
			pipeline_reg_out[62:60] <= decoding_op_src1;				//{reg_read_addr_1};
			pipeline_reg_out[59:57] <= decoding_op_src2;				//{reg_read_addr_2};
			
			pipeline_reg_out[56:22] <= {alu_opcode, reg_read_data_1 , reg_read_data_2_mux };
			pipeline_reg_out[21:5] <= {mem_write_en , reg_read_data_2 }; /// it will be have some changes
			pipeline_reg_out[4:0] <= {write_back_en , instruction[11:9], write_back_result_mux};
		end
	end

 
	
wire condition ;
	
assign	condition = (reg_read_data_1 == 16'b0 ) ? 1:0;
assign	branch_taken = branch_en & condition;

///////////////////// HD /////////////// 
assign decoding_op_src1 = ( (instruction[15:12] == 4'b0) )     //NOP
									 ? 3'b0 : reg_read_addr_1;
assign decoding_op_src2 = ( (instruction[15:12] == 4'b1010) || //load
									 //(instruction[15:12] == 4'b1011) || //store
									 (instruction[15:12] == 4'b1001) || //immidiate
									 (instruction[15:12] == 4'b1100) || //branch
									 (instruction[15:12] == 4'b0) )     //NOP
									 ? 3'b0 : reg_read_addr_2;	
endmodule
