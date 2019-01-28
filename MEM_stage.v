module MEM_stage
(
input				clk,
input				rst,
input				enable,
input				[37:0]	pipeline_reg_in,
output	reg	[36:0]	pipeline_reg_out,
output			[2:0]		mem_op_dest,

//output  							mem_or_reg

/////SRAM////
output						freeze,

inout			 	[15:0]	SRAM_DQ,
output 		 	[17:0]	SRAM_ADDR,
output						SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N , hit
);



wire mem_write_en;
wire [15:0] data, q , addr , addr_correct;
wire wants_to_read;
wire ready;
wire [17:0] addr_ex;
wire clk_s;

assign mem_write_en = pipeline_reg_in [21];	
assign data = pipeline_reg_in [20:5];
assign addr = pipeline_reg_in [37:22];

//RAM_ ram ( data, addr, clk , rst ,mem_write_en, q);
//////////////// SRAM /////////////////////

always@(posedge clk)
	begin
	if(rst) begin pipeline_reg_out= 37'b0; end
	else if (!enable)
			pipeline_reg_out <= {pipeline_reg_in[37:22], q , pipeline_reg_in[4:0]};
	else 
			pipeline_reg_out <= 37'd0;
	end

	
////////////// HD //////////////
assign mem_op_dest = (pipeline_reg_in[4])  ? pipeline_reg_in[3:1] : 3'b0 ;

///////////////SRAM/////////
wire Resetn;

assign wants_to_read = pipeline_reg_in[0] & pipeline_reg_in[4];
assign addr_ex = {2'b0 , addr_cache};
//assign clk_s = clk & freeze;
assign Resetn = (mem_write_en | wants_to_read); //& (~hit) ;
assign freeze = (~ready);

wire [15:0] addr_cache , write_data_cache, read_data_cache; 
wire SRAM_write_en_cache, read_cache;

assign addr_correct = ( Resetn ) ? addr : 16'hFFFF;

Cache cach ( clk ,rst ,
 data , mem_write_en , addr_correct , q , ready, hit , 
 addr_cache , write_data_cache, SRAM_write_en_cache, read_data_cache, read_cache );

SRAM_Controller sram ( clk , rst, 
 //SRAM_address, SRAM_write_data, SRAM_write_en, SRAM_read_data,ready,
 addr_ex ,		write_data_cache		, SRAM_write_en_cache , read_data_cache	, read_cache, 
 SRAM_DQ , SRAM_ADDR, SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N );
	
endmodule
