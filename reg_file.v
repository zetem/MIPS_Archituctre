module reg_file
(
	output reg [7:0] H0 , H1,
	input [2:0]	select,
	
	input	clk,
	input	rst,
	// write port 
	input				rg_wrt_enable,
	input		[2:0]	rg_wrt_dest,
	input		[15:0]rg_wrt_data,
		// read port 1
	input		[2:0]	rg_rd_addr1,
	output	[15:0]rg_rd_data1,
	// read port 2
	input 	[2:0]	rg_rd_addr2,
	output	[15:0]rg_rd_data2
);

//reg_file ( clk,rst, rg_ert_enable,	rg_wrt_dest, rg_wrt_data, rg_rd_addr1, rg_rd_data1, rg_rd_addr2, rg_rd_data2);


  reg		[15:0]	R	[0:7];
  
  always @(negedge clk)  // negedge
  begin
   if(rst)
     begin
       R[0]=16'd0;
       R[1]=16'd0;
       R[2]=16'd0;
       R[3]=16'd0;
       R[4]=16'd0;
       R[5]=16'd0;
       R[6]=16'd0;
       R[7]=16'd0;
    end
    
  else if(rg_wrt_enable && (rg_wrt_dest != 0 ))
      R[rg_wrt_dest]<= rg_wrt_data;
          
  end
  
      
  assign rg_rd_data1	=	R[rg_rd_addr1];
  assign rg_rd_data2	=	R[rg_rd_addr2];
  
  always @(*)
  begin
   if ( select < 8 )
	begin 
	case(R[select][7:0])
	4'h0: H0 = 7'b1000000;
	4'h1: H0 = 7'b1111001;
	4'h2: H0 = 7'b0100100;
	4'h3: H0 = 7'b0110000;
	4'h4: H0 = 7'b0011001;
	4'h5: H0 = 7'b0010010;
	4'h6: H0 = 7'b0000010;
	4'h7: H0 = 7'b1111000;
	4'h8: H0 = 7'b0000000;
	4'h9: H0 = 7'b0010000;
	4'hA: H0 = 7'b0001000;
	4'hB: H0 = 7'b0000011;
	4'hC: H0 = 7'b1100111;
	4'hD: H0 = 7'b0100001;
	4'hE: H0 = 7'b0000110;
	4'hF: H0 = 7'b0001110;
	endcase
	case(R[select][15:8])
	4'h0: H0 = 7'b1000000;
	4'h1: H0 = 7'b1111001;
	4'h2: H0 = 7'b0100100;
	4'h3: H0 = 7'b0110000;
	4'h4: H0 = 7'b0011001;
	4'h5: H0 = 7'b0010010;
	4'h6: H0 = 7'b0000010;
	4'h7: H0 = 7'b1111000;
	4'h8: H0 = 7'b0000000;
	4'h9: H0 = 7'b0010000;
	4'hA: H0 = 7'b0001000;
	4'hB: H0 = 7'b0000011;
	4'hC: H0 = 7'b1100111;
	4'hD: H0 = 7'b0100001;
	4'hE: H0 = 7'b0000110;
	4'hF: H0 = 7'b0001110;
	endcase
	end
	end
	
  endmodule

