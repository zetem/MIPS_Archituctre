module PC (enable, inPC , adr_PC , reset ,clk );
  input 		enable;
  input 		[7:0] inPC;
  output	reg[7:0] adr_PC;
  input 		reset ,clk ;

always @(posedge clk)
begin
   
	if (reset==1)
    adr_PC=8'd0;
   
	else
	begin 
	if(!enable)	
		adr_PC <= inPC;
	end
	
 end 
   
 endmodule