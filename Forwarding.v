module Forwarding (src1 , src2 , dest_Mem , dest_WB , reg_write_en_Mem , reg_write_en_WB, sel_a , sel_b , forwarding_en);

input 			[2:0] src1 , src2 , dest_Mem , dest_WB;							
input				reg_write_en_Mem , reg_write_en_WB;   
output	reg	[1:0] sel_a , sel_b;

input forwarding_en;


always@(*)
begin
	if(forwarding_en)
	begin 
		
		if ((src1 == dest_Mem) && (reg_write_en_Mem) && (src1 != 3'b0))
			sel_a = 2'd1;
		else if ( (src1 == dest_WB) && (reg_write_en_WB) && (src1 != 3'b0) )
			sel_a = 2'd2;
		else 
			sel_a = 2'd0;
		
		
		if ((src2 == dest_Mem) && (reg_write_en_Mem) && (src2 != 3'b0) )
			sel_b = 2'd1;
		else if ( (src2 == dest_WB) && (reg_write_en_WB) && (src2 != 3'b0) )
			sel_b = 2'd2;
		else 
			sel_b = 2'd0;
			
	end
end                   

endmodule
