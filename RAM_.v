module RAM_ ( input [15:0] data , input [15:0] addr , input clk , input reset , input write_en , output [15:0] q  );



 reg		[15:0]	M	[0:64];
  
  always @(posedge clk)
  begin
  integer i;
  
  if (reset)
  begin
	for (i=0 ; i<63 ; i = i+1 )
		M[i] = 16'd0;
	end
		
	else if(write_en)
			M[addr]<= data;
				
  end
  
      
  assign q	=	M[addr];
  
endmodule