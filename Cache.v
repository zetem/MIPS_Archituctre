module Cache ( 

input					clk ,
input					reset ,
input		[15:0]	write_data ,
input 				write_en, 
input		[15:0]	address ,
output	[15:0]	read_data,
output  				ready,
output 				hit,

///SRAM
output 			[15:0] 	SRAM_address,
output			[15:0] 	SRAM_wdata,
output						SRAM_write_en,
input				[15:0]	SRAM_read_data,
input							SRAM_read
 );


wire 		hit_1, hit_2, miss; 
wire 		[7:0]		index;
wire		[7:0]		tag;
wire 		[15:0]	read_data_1;
wire		[15:0]	read_data_2; 
wire 		[15:0]	read_valid_1;
wire		[15:0]	read_valid_2;
wire 		[7:0]		read_tag_1;
wire		[7:0]		read_tag_2;
wire 		[17:0]	address_ex;
		
 reg		[15:0]	data_1	[0:256];
 reg 		[15:0] 	data_2	[0:256];
 reg 					valid_1	[0:256];
 reg					valid_2	[0:256];
  
 reg 		[7:0]		tag_1		[0:256];
 reg 		[7:0]		tag_2		[0:256];
 
 reg					LRU		[0:256];
 
 
  always @(negedge clk)
  begin
  integer i;
  
  //SRAM_address = 16'hFFFF;
  if (reset)
  begin
	for (i=0 ; i<256 ; i = i+1 )
		begin
		valid_1[i] = 0;
		valid_2[i] = 0;
		end
	end
	
	else if(write_en)
		begin
			//SRAM_wdata = write_data;
			//SRAM_write_en = write_en;
			//SRAM_address = address;
			if (read_tag_1 == tag && read_data_1 != write_data)
					valid_1[index] = 0;
			if (read_tag_2 == tag && read_data_2 != write_data)
					valid_2[index] = 0;
		end
	
	else if( (hit == 0) && SRAM_read )
		begin
			//SRAM_address = address;
			if(read_valid_1 == 0)
			begin
				data_1[index] = SRAM_read_data;
				valid_1[index] <= 1;
				tag_1 [index]  = tag;
			end
			
			else if(read_valid_2 == 0)
			begin
				data_2[index] = SRAM_read_data;
				valid_2[index] <= 1;
				tag_2 [index]  = tag;
			end
			
			else if(read_LRU == 0 )
			begin
				data_1[index] = SRAM_read_data;
				valid_1[index] <= 1;
				tag_1 [index]  = tag;
			end
			
			else if(read_LRU ==1)
			begin
				data_2[index] = SRAM_read_data;
				valid_2[index] <= 1;
				tag_2 [index]  = tag;
			end
		end
	
	end
	
	always @(*)
   begin 
			if (hit_1)
			 LRU [index] = 0;  //: ( hit_2 ? 1 : LRU[index] );
			else if (hit_2)
			 LRU [index] = 1;
				
  end
  
  assign index 	= address[7:0];
  assign tag		= address[15:8];
  
  assign read_data_1  = data_1  [index];
  assign read_data_2  = data_2  [index];
  assign read_valid_1 = valid_1 [index];
  assign	read_valid_2 = valid_2 [index];
  assign read_tag_1   = tag_1   [index];
  assign read_tag_2   = tag_2   [index];
  assign	read_LRU 	 = LRU	  [index];

	
 
  
  assign hit_1 = ( (( tag == read_tag_1) && (read_valid_1 == 1)  && (write_en==0) ) || (address == 16'hFFFF )) ? 1:0;
  assign hit_2 = ( (( tag == read_tag_2) && (read_valid_2 == 1)  && (write_en==0) ) || (address == 16'hFFFF )) ? 1:0;  
 
  //assign hit_1 = ( (read_valid_1 == 1) && (address != 16'hFFFF ) && (write_en==0) ) ? 1:0;
  //assign hit_2 = ( (read_valid_2 == 1) && (address != 16'hFFFF ) && (write_en==0) ) ? 1:0;  
 
  assign hit   = hit_1 | hit_2;
 
  assign  read_data = hit_1 ?  read_data_1 : ( hit_2 ? read_data_2 : 16'hFFFF); 
 
  assign miss = ~hit;
  //assign SRAM_address = (hit) ?  16'hFFFF : SRAM_address  
 
  assign ready = SRAM_read;
  
  assign SRAM_write_en = write_en;
  assign address_ex = {2'b00 , address };
  assign SRAM_address  = (hit==0 ) ? address_ex : 18'h0FFFF;
  //assign SRAM_address  = address; 
  assign SRAM_wdata = write_data;
  //assign SRAM_wdata   = (hit) ? SRAM_wdata   : write_data;  
  //assign SRAM_write_en= (hit) ? SRAM_write_en   : write_en;  
  
  
  //assign read_data = (hit & SRAM_read) ? read_data : SRAM_read_data;  
  
endmodule



/*
module Cache ( 

input					clk ,
input					reset ,
input		[15:0]	write_data ,
input 				write_en, 
input		[15:0]	address ,
output	[15:0]	read_data,
output  				hit,

///SRAM
output 			[15:0] 	SRAM_address,
output			[15:0] 	SRAM_wdata,
output						SRAM_write_en,
input				[15:0]	SRAM_read_data,
input							SRAM_read
 );


wire 		hit_1, hit_2; 
wire 		[7:0]		index;
wire		[7:0]		tag;
wire 		[15:0]	read_data_1;
wire		[15:0]	read_data_2; 
wire 		[15:0]	read_valid_1;
wire		[15:0]	read_valid_2;
wire 		[7:0]		read_tag_1;
wire		[7:0]		read_tag_2;
		
 reg		[15:0]	data_1	[0:256];
 reg 		[15:0] 	data_2	[0:256];
 reg 					valid_1	[0:256];
 reg					valid_2	[0:256];
  
 reg 		[7:0]		tag_1		[0:256];
 reg 		[7:0]		tag_2		[0:256];
 
 reg					LRU		[0:256];
 
 
  always @(posedge clk)
  begin
  integer i;
  
  if (reset)
  begin
	for (i=0 ; i<256 ; i = i+1 )
		begin
		data_1[i] = 16'd0;
		data_2[i] = 16'd0;
		end
	end
		
	else if(write_en)
			begin
			if(read_valid_1 == 0)
			begin
				data_1[index] = write_data;
				valid_1[index] = 1;
			end
			else if(read_valid_2 == 0)
			begin
				data_2[index] = write_data;
				valid_2[index] = 1;
			end
			else if(read_LRU == 0 )
			begin
				data_1[index]= write_data;
				valid_1[index] = 1;
			end
			else if(read_LRU ==1)
			begin
				data_2[index] = write_data;
				valid_2[index] = 1;
			end
			end
			
			if (hit_1)
			 LRU [index] = 0;  //: ( hit_2 ? 1 : LRU[index] );
			else if (hit_2)
			 LRU [index] = 1;
				
  end
  
  assign index 	= address[7:0];
  assign tag		= address[15:8];
  
  assign read_data_1  = data_1  [index];
  assign read_data_2  = data_2  [index];
  assign read_valid_1 = valid_1 [index];
  assign	read_valid_2 = valid_2 [index];
  assign read_tag_1   = tag_1   [index];
  assign read_tag_2   = tag_2   [index];
  assign	read_LRU 	 = LRU	  [index];

	
 
  
  assign hit_1 = (( tag == read_tag_1) & read_valid_1 ) ? 1:0;
  assign hit_2 = (( tag == read_tag_2) & read_valid_2 ) ? 1:0;  
  assign hit   = hit_1 | hit_2;
 
  assign  read_data = hit_1 ?  read_data_1 : ( hit_2 ? read_data_2 : ( (SRAM_read) ?  SRAM_read_data : read_data )); 
 
  
  assign SRAM_address = (hit) ? SRAM_address : address;   
  assign SRAM_wdata   = (hit) ? SRAM_wdata   : write_data;  
  assign SRAM_write_en= (hit) ? SRAM_write_en   : write_en;  
  
  
  //assign read_data = (hit & SRAM_read) ? read_data : SRAM_read_data;  
  
endmodule */