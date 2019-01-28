module IF_stage
(  input 					clk,
	input						rst,
	input						instr_fetch_enable,
	input			[5:0]		imm_branch_offset,
	input						branch_enable,
	output 		[7:0]		pc,
	output 		[15:0]	instr
);

wire [7:0] pc_plus; 
wire [7:0] pc_add , imm_branch_offset_extend;
wire [15:0] instr_int;

assign imm_branch_offset_extend = { imm_branch_offset[5], imm_branch_offset[5], imm_branch_offset };
assign pc_add = ( branch_enable ) ? imm_branch_offset_extend : 8'd1;



PCALU pcalu (pc , pc_add , pc_plus);
PC m_pc ( instr_fetch_enable , pc_plus , pc , rst ,clk);
instMem instructionmem (pc , instr_int , rst);

assign instr = ( branch_enable ) ? 16'b0 : instr_int;

endmodule
