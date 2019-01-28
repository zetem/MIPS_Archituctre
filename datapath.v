module datapath 
(
input			clk ,
input			[17:0] S,

output 		[15:0] IF_reg,
output 	 	[62:0] ID_reg ,
output 		[37:0] EX_reg ,
output 		[36:0] MEM_reg ,
output		[7:0]	H0,
output		[7:0]	H1,   

//////////// SRAM ////////
inout				[15:0]	SRAM_DQ,
output 		 	[17:0]	SRAM_ADDR,
output						SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N

);


//wire [15:0] instr;
wire 			[7:0]		pc;

wire			[2:0]		reg_read_addr_1;
wire			[2:0]		reg_read_addr_2;
wire			[15:0]	reg_read_data1;
wire			[15:0]	reg_read_data2;

wire						branch_taken;
wire 			[5:0]		branch_offset_imm;

wire 						reg_write_en;
wire 			[2:0]		reg_write_dest;
wire 			[15:0]	reg_write_data;

wire			[2:0]		decoding_op_src1;
wire			[2:0]		decoding_op_src2;
wire			[2:0]		ex_op_dest;
wire 			[2:0]		mem_op_dest;
wire 			[2:0]		wb_op_dest;
wire						pipline_stall_n;

wire 			[2:0]		src1 , src2;
wire			[2:0]		dest_Mem;
wire 						reg_write_en_Mem;

wire 			[1:0]		sel_a;
wire 			[1:0]		sel_b;

wire 						rst;

wire						forwarding_en; 
wire 						mem_or_reg;

wire 			[15:0]	Mem_reg_data;

wire 						branch_en;
wire 						freeze;
wire 						hit;
/////////////////////////////////////////////////////
assign rst = S[1];
assign forwarding_en = S[0];

/////////////////////////////////
wire		fetch_en;
assign	fetch_en =  pipline_stall_n | freeze;

IF_stage ifstage (clk, rst, fetch_en , branch_offset_imm ,branch_taken, pc, IF_reg);

////////////////////////////////
wire ID_stall;
assign ID_stall = pipline_stall_n | freeze; 

ID_stage idstage (clk, rst, ID_stall , freeze ,ID_reg, IF_reg , branch_offset_imm ,branch_taken,  reg_read_addr_1, reg_read_addr_2 ,
						reg_read_data1  , reg_read_data2 , decoding_op_src1 , decoding_op_src2 , branch_en); 
						
reg_file REGFILE(H0 , H1 , S[17:15] , clk,rst,reg_write_en ,reg_write_dest, reg_write_data, 
					reg_read_addr_1, reg_read_data1 , reg_read_addr_2 , reg_read_data2);

/////////////////////////////////

EX_stage exstage ( clk, rst, freeze , ID_reg, EX_reg, ex_op_dest, sel_a, sel_b, Mem_reg_data, reg_write_data, mem_or_reg );


////////////////////////////////
MEM_stage memstage(clk, rst, freeze , EX_reg, MEM_reg, mem_op_dest,
 freeze ,SRAM_DQ, SRAM_ADDR, SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N ,hit );


////////////////////////////////
WB_stage wbstage(MEM_reg, reg_write_en, reg_write_dest, reg_write_data, wb_op_dest);


//////////////// HD //////////////////

hazard_detection_unit HD ( decoding_op_src1, decoding_op_src2 , ex_op_dest, mem_op_dest, wb_op_dest, pipline_stall_n , forwarding_en , mem_or_reg, branch_en);


/////////////////FW ///////////////////
assign src1 = ID_reg[62:60];
assign src2 = ID_reg[59:57];

assign reg_write_en_Mem = EX_reg[4];
//assign dest_Mem = (EX_reg[4] & (~EX_reg[0]) )  ?  EX_reg[3:1] : 3'd0;
assign dest_Mem = (EX_reg[0])  ?  3'd0 : EX_reg[3:1];
assign Mem_reg_data = EX_reg[37:22];


Forwarding fw (src1 , src2 , dest_Mem , reg_write_dest , reg_write_en_Mem , reg_write_en, sel_a, sel_b, forwarding_en);

///////////////SRAM///////////////////

endmodule

