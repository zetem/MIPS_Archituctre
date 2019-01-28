module alu(a , b , cmd , r);
  
  input signed [15:0] 	a , b ;
  input signed	[2:0] cmd ;
  output reg [15:0] r ; 
  
  always @(*)
  begin
  
  if			(cmd==3'b000)
    begin
    r	=	a	+	b;
    end 
	 
  else if	(cmd==3'b001)
    begin
    r	=	a	-	b;
    end
	 
  else if	(cmd==3'b010)
    begin
    r	=	a	&	b;
    end  
	 
  else if	(cmd==3'b011)
    begin
    r =	a	| b;
    end  
  else if	(cmd==3'b100)
    begin
    r =	a	^ b;
    end  
		 	
  else if	(cmd==3'b101)
    begin
    r = a <<< b;    
    end
	 
  else if	(cmd==3'b110)
    begin
    r = a >>> b; 
	 end
	 
  else if	(cmd==3'b111)
    begin
    r = a >> b; 
    end 
  end
  
endmodule 