module hazard_detection_unit 
(
input [2:0]		decode_op_src1,
input [2:0]		decode_op_src2,
input [2:0]		ex_op_dest,
input [2:0]		mem_op_dest,
input [2:0]		wb_op_dest,
output	 reg	 pipline_stall_n,

input forwarding_en,
input mem_or_reg,
input branch_en
);
	
	
always@(*)
begin

	if ((!forwarding_en) | branch_en)
		begin
			if( ( ( decode_op_src1 == ex_op_dest) && (ex_op_dest != 3'b0) ) || ( (decode_op_src1 == mem_op_dest) && (mem_op_dest != 3'b0) ) || ((decode_op_src1== wb_op_dest) && (wb_op_dest != 3'b0) ) ||
				( ( decode_op_src2 == ex_op_dest) && (ex_op_dest != 3'b0) ) || ( (decode_op_src2 == mem_op_dest) && (mem_op_dest != 3'b0) ) || ((decode_op_src2== wb_op_dest) && (wb_op_dest != 3'b0) ) )
					
					pipline_stall_n=1'b1;
				
			else
					pipline_stall_n=1'b0;
		end
		
	else // in dota comment nabashan va reg file bejaye negedge bashe posedge
		begin
			if (  //( (decode_op_src1== wb_op_dest) && (decode_op_src1 != mem_op_dest) && (decode_op_src1 != ex_op_dest) && (decode_op_src1 != 3'b0) ) ||
				   //( (decode_op_src2== wb_op_dest) && (decode_op_src2 != 3'b0) ) ||
					( (decode_op_src1== ex_op_dest) && (ex_op_dest != 3'b0) && mem_or_reg ) ||
					( (decode_op_src2== ex_op_dest) && (ex_op_dest != 3'b0) && mem_or_reg ) )				
					pipline_stall_n=1'b1;
				
			else
					pipline_stall_n=1'b0;
				
		end
	
end 
endmodule