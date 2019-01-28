module SRAM_Controller (

input clk,
input rst,
//input Resetn,

// to memory stage unit 
input 			[17:0] 	SRAM_address,
input				[15:0] 	SRAM_write_data,
input							SRAM_write_en,
output	reg	[15:0]	SRAM_read_data,
output						ready,

// to SRAM
inout		reg	[15:0]	SRAM_Data,
output	reg 	[17:0]	SRAM_Address,
output	reg				SRAM_WE_n, //
output	reg				SRAM_OE_n,
output	reg				SRAM_UB_n,
output	reg				SRAM_LB_n,
output	reg				SRAM_CE_n


);


reg [1:0] count_clk;


//assign ready = (Resetn) ? 0 : 1; 

always @(negedge clk)
	begin
	
		if (rst)
		count_clk = 2'b11;
		//ready = 1;
		
		
		else if(!ready)
		begin 
			count_clk = count_clk + 2'd1;
			
			//if (count_clk == 2'b11)
			//count_clk <= 2'd0;
			//ready = 1;
		end
		
		else if( (SRAM_address != 18'hFFFF) && (SRAM_write_en==0) )begin  // if (SRAM_address != 16'hZZZZ && SRAM_write_en==0)
		//ready = 0 ; //<=
		count_clk = 2'd0;
		end
		
	end
 

 assign ready = ( (count_clk != 2'b11) ) ? 0 : 1;
 
 
always @(*)
	begin
		SRAM_OE_n =0;
		SRAM_UB_n =0;
		SRAM_LB_n =0;
		SRAM_CE_n =0;
		
		SRAM_read_data = SRAM_Data;
		SRAM_Address = SRAM_address;
		
	end
	
always @( negedge clk)
	begin
		if (SRAM_write_en)
			begin
				SRAM_Data = SRAM_write_data;
				SRAM_WE_n = 0;
			end
		else 
			begin
				SRAM_Data = 16'hZZZZ;
				SRAM_WE_n = 1;
			end
	end

endmodule
