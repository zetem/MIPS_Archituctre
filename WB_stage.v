module WB_stage
(
input			[36:0]		pipeline_reg_in,
output						reg_write_en,
output		[2:0]			reg_write_dest,
output		[15:0]		reg_write_data,
output		[2:0]			wb_op_dest
);

assign reg_write_data = (pipeline_reg_in[0]) ? pipeline_reg_in[20:5] : pipeline_reg_in[36:21];
assign reg_write_dest = pipeline_reg_in [3:1];
assign reg_write_en = pipeline_reg_in [4];


/////////////////HD////////////
assign wb_op_dest = (reg_write_en) ? reg_write_dest  : 3'b0;

endmodule
