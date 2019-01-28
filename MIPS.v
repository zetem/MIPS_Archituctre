module MIPS ( input CLOCK_50 , input [17:0] SW , output [17:0] LEDR , output [7:0] HEX7 , HEX6 , 
inout		[15:0]	SRAM_DQ,
output 	[17:0]	SRAM_ADDR,
output				SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N
);

wire	[15:0] IF_reg ;
wire 	[62:0] ID_reg ;
wire	[37:0] EX_reg ;
wire	[36:0] MEM_reg ;
wire	[36:0] WR_reg;    


assign LEDR[0] = SW[0];
assign LEDR[1] = SW[1];


datapath dp ( CLOCK_50 , SW , IF_reg , ID_reg , EX_reg , MEM_reg , HEX6 , HEX7, 
SRAM_DQ, SRAM_ADDR, SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N
 );




endmodule 