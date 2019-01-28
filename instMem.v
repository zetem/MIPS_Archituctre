module instMem(adr , out , reset);
  
  input [7:0]adr;
  input reset;
  output reg [15:0]out;
  reg [15:0]insMem[0:64];
  
  always @(*)
  begin
     if(reset) begin
//		insMem[8'd0 ] = 16'b1001001000000101; //-- addi r1 = 5	
//		insMem[8'd1 ] = 16'b1001010000111011; //-- addi r2 = -5	
//		insMem[8'd2 ] = 16'b1001011010001111; //-- addi r3 = R2 +15 = 10
//		insMem[8'd3 ] = 16'b1001100010111111; //-- addi r4 = R2 - 1 = -6
//		insMem[8'd4 ] = 16'b1001101010000101; //-- addi r5 = R2 + 5 = 0
//		insMem[8'd5 ] = 16'b0000111100101000; //--nop
//		insMem[8'd6 ] = 16'b1001110101000110; //-- addi r6 = R5 + 6 = 6
//		insMem[8'd7 ] = 16'b0000000000000000; //--nop
//		insMem[8'd8 ] = 16'b0000000000000000; //--nop
//		insMem[8'd9 ] = 16'b1001111110000101; //-- addi r7 = R6 + 5 = 11
//		insMem[8'd10] = 16'b0001000111000000; //-- add R0 =R7 +R0 = 0
//		insMem[8'd11] = 16'b0000010010100000; //-- nop
//		insMem[8'd12] = 16'b0001011011000000; //-- add R3 =R3 +R0 = 10
//		insMem[8'd13] = 16'b0001100001100000; //-- add R4 =R1 +R4 = -1
//		insMem[8'd14] = 16'b0010001001010000; //-- SUB R1 =R1 - R2 = 10	
//		insMem[8'd15] = 16'b0011001001110000; //-- AND R1 =R1 &R6 = 00000010= 2
//		insMem[8'd16] = 16'b0100001100001000; //-- OR  R1 =R4 |R1 = 111111 = -1
//		insMem[8'd17] = 16'b0101001011001000; //-- XOR R1 =R3^R1 = 110101 = -11
//		insMem[8'd18] = 16'b1001010000000010; //-- Adi R2 = 2
//		insMem[8'd19] = 16'b0110001001010000; //-- SL  R1 =R1 <<R2 = 11010100
//		insMem[8'd20] = 16'b1001010010000010; //-- Adi R2 = R2 + 2 = 4 
//		insMem[8'd21] = 16'b1001011000111100; //-- Adi R3 = -4
//		insMem[8'd22] = 16'b0111001001010000; //-- SR  R1 =R1 >>R2 = 11111101 
//		insMem[8'd23] = 16'b1001001000001111; //-- addi r1 = 15
//		insMem[8'd24] = 16'b1011011001111011; //-- ST  Mem(R1-5 = 10) <- R3 = -4
//		
//		//insMem[8'd24] = 16'b1011011000111011; //-- ST  Mem(R1-5 = 10) <- R3 = -4
//		
//		insMem[8'd25] = 16'b1010111011001110; //-- Ld  R7 <- Mem(14 + R3 = 10) = -4
//		insMem[8'd26] = 16'b1010110111001110; //-- Ld  R6 <- Mem(14 + R7 = 4) = -4
//		insMem[8'd27] = 16'b0001011110111000; //-- Add R3 = R6 + R7 = -8
//		insMem[8'd28] = 16'b1011011110000100; //-- ST  Mem(R6 + 4 = 0) <- R3 = -8
//		insMem[8'd29] = 16'b1010001000000000; //-- Ld  R1 <- Mem(0 + R0 = 0) = -8
//		insMem[8'd30] = 16'b1001010000111011; //-- Adi R2 = -5
//		insMem[8'd31] = 16'b1001001000000000; //-- Adi R1 = 0
//		insMem[8'd32] = 16'b1100000001000001; //-- BR  R1 , 1 , YES
//		insMem[8'd33] = 16'b1001010000000000; //-- Adi R2 = 0	
//		insMem[8'd34] = 16'b1100000010111111; //-- BR  R2 , -1 , NOT	
//		insMem[8'd35] = 16'b1001001000000001; //-- Adi R1 = 1	
//		insMem[8'd36] = 16'b1100000001111011; //-- BR  R1 , -5 , NOT	
//		insMem[8'd37] = 16'b1100000000000000; //-- BR  R0 , 0 , YES	
//		insMem[8'd38] = 16'b1100000001111011; //-- BR  R1 , -5 , NOT 
//		insMem[8'd39] = 16'b1100000000111111; //-- BR  R0 , -1 , YES
//		insMem[8'd40] = 16'b0000010010100000; //-- nop
//		insMem[8'd41] = 16'b0000010010100000; //-- nop
//		insMem[8'd42] = 16'b0000010010100000; //-- nop
//		insMem[8'd43] = 16'b0000010010100000; //-- nop
//		insMem[8'd44] = 16'b0000010010100000; //-- nop
//		insMem[8'd45] = 16'b0000010010100000; //-- nop
//		insMem[8'd46] = 16'b0000010010100000; //-- nop
//		insMem[8'd47] = 16'b0000010010100000; //-- nop
//		insMem[8'd48] = 16'b0000010010100000; //-- nop
//		insMem[8'd49] = 16'b0000010010100000; //-- nop
//		insMem[8'd50] = 16'b0000010010100000; //-- nop
//		insMem[8'd51] = 16'b0000010010100000; //-- nop
//		insMem[8'd52] = 16'b0000010010100000; //-- nop
//		insMem[8'd53] = 16'b0000010010100000; //-- nop
//		insMem[8'd54] = 16'b0000010010100000; //-- nop
//		insMem[8'd55] = 16'b0000010010100000; //-- nop
//		insMem[8'd56] = 16'b0000010010100000; //-- nop
//		insMem[8'd57] = 16'b0000010010100000; //-- nop
//		insMem[8'd58] = 16'b0000010010100000; //-- nop
//		insMem[8'd59] = 16'b0000010010100000; //-- nop
//		insMem[8'd60] = 16'b0000010010100000; //-- nop
//		insMem[8'd61] = 16'b0000010010100000; //-- nop
//		insMem[8'd62] = 16'b0000010010100000; //-- nop
//		insMem[8'd63] = 16'b0000010010100000; //-- nop
//		
//		
		insMem[8'd0 ] = 16'b1001001000000001; //-- addi r1 = 1	
		insMem[8'd1 ] = 16'b1001010000000010; //-- addi r2 = 2	
		insMem[8'd2 ] = 16'b1001011000000011; //-- addi r3 = 3
		insMem[8'd3 ] = 16'b1001100000001000; //-- addi r4 = 8
		insMem[8'd4 ] = 16'b0110001001100000; //-- SL  R1 =R1 <<R4
		insMem[8'd5 ] = 16'b0110010010100000; //-- SL  R2 =R2 <<R4
		insMem[8'd6 ] = 16'b0110011011100000; //-- SL  R3 =R3 <<R4
		insMem[8'd7 ] = 16'b1001101000010011; //-- addi r5 = h13;
		insMem[8'd8 ] = 16'b0001001001101000; //-- add R1 =R1 +R5
		insMem[8'd9 ] = 16'b0001010010101000; //-- add R2 =R2 +R5
		insMem[8'd10] = 16'b0001011011101000; //-- add R3 =R3 +R5
		insMem[8'd11] = 16'b1011001001000000; //-- ST  Mem(R1) <- R1
		insMem[8'd12] = 16'b1011010010000000; //-- ST  Mem(R2) <- R2
		insMem[8'd13] = 16'b1011011011000000; //-- ST  Mem(R3) <- R3
		insMem[8'd14] = 16'b1010110001000000; //-- LD  R6 <-Mem(R1)
		insMem[8'd15] = 16'b1010111010000000; //-- LD  R7 <-Mem(R2)
		insMem[8'd16] = 16'b1010110010000000; //-- LD  R6 <-Mem(R2)
		insMem[8'd17] = 16'b1010111001000000; //-- LD  R7 <-Mem(R1)
		insMem[8'd18] = 16'b1010111011000000; //-- LD  R7 <-Mem(R3)
		insMem[8'd19] = 16'b0000010010100000; //-- nop
		insMem[8'd20] = 16'b0000010010100000; //-- nop
		insMem[8'd21] = 16'b0000010010100000; //-- nop
		insMem[8'd22] = 16'b0000010010100000; //-- nop
		insMem[8'd23] = 16'b0000010010100000; //-- nop
		insMem[8'd24] = 16'b0000010010100000; //-- nop
		insMem[8'd25] = 16'b0000010010100000; //-- nop
		insMem[8'd26] = 16'b0000010010100000; //-- nop
		insMem[8'd27] = 16'b0000010010100000; //-- nop
		insMem[8'd28] = 16'b0000010010100000; //-- nop
		insMem[8'd29] = 16'b0000010010100000; //-- nop
		insMem[8'd30] = 16'b0000010010100000; //-- nop
		insMem[8'd31] = 16'b0000010010100000; //-- nop
		insMem[8'd32] = 16'b0000010010100000; //-- nop
		insMem[8'd33] = 16'b0000010010100000; //-- nop
	  end 
	  



//insMem[8'd25] = 16'b1010111011001110; //-- Ld  R7 <- Mem(14 + R3 = 10) = -4


		
				
		
	 else
    out<=insMem[adr];
end
endmodule

