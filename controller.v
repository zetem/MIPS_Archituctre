module controller 
(
input [3:0] opcode,
//input		rst,
output	reg	write_back_en, //s6
output	reg	write_back_result_mux, //s1 //if(1) memory to reg , if(0) output of alu
output	reg	mem_write_en,	//s3
output	reg	branch_en,	//s5
output	reg	mux_imm_or_reg	,//s4
output 		[2:0]alu_opcode //s2

);

reg [3:0] alu_opcode_tmp;

always@(*)begin

	write_back_en= 0;
	write_back_result_mux = 0;
	mem_write_en =0 ;
	branch_en =0;
	mux_imm_or_reg =0;

	if(opcode > 0 && opcode < 4'd9)
		begin
			alu_opcode_tmp = opcode-4'd1;
			write_back_en =1;
		end
		
		
	else if(opcode == 4'b 1001) //addi
		begin
			alu_opcode_tmp=4'b0;
			mux_imm_or_reg = 1;
			write_back_en = 1;
			
		end

	else if(opcode == 4'b1100) //branch
		begin
			branch_en=1;
		end
		
	else if(opcode == 4'b 1010) //load
		begin
			alu_opcode_tmp = 4'b 0;
			mux_imm_or_reg =1;
			write_back_en =1;
			write_back_result_mux =1 ; 
		end
		
	else if(opcode == 4'b 1011) //store
		begin
			alu_opcode_tmp = 4'b 0;
			mux_imm_or_reg =1;
			mem_write_en =1;
			
		end
	
		
	end

assign alu_opcode = alu_opcode_tmp[2:0];


endmodule
