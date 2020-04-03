// Arquitetura e Organização de computadores II - Fabiane e Gabriel
`include "processor.sv"
`include "peripheral.sv"

`timescale 1ns / 1ps


module testbench;
	// Inputs
	reg clkCPU;
  	reg clkP1;
  	reg clkP2;
  	reg reset;
  
	// Outputs
  	wire ACK1;
  	wire ACK2;
	wire SEND1;
  	wire SEND2;
  	wire [15:0] DATA1;
  	wire [15:0] DATA2;


  // Instantiate the Unit Under Test (UUT) - processor
	processorFSM uutCPU(
     	.ack1(ACK1),   
     	.ack2(ACK2),
      	.outsend1(SEND1),
     	.outsend2(SEND2),
      	.outdata1(DATA1),
      	.outdata2(DATA2),
      	.clkCPU(clkCPU),
		.rst(reset)
	);

  // Instantiate the Unit Under Test (UUT) - peripherical 1
	peripheralFSM uutPeripheral1(
      	.send(SEND1),  
      	.clk(clkP1),  
      	.rst(reset),
    	.data(DATA1),
      	.outack(ACK1)
	);
  
  // Instantiate the Unit Under Test (UUT) - peripherical 2
	peripheralFSM uutPeripheral2(
      	.send(SEND2),  
      	.clk(clkP2),  
      	.rst(reset),
    	.data(DATA2),
     	.outack(ACK2)
	);

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;

		// Initialize Inputs
		clkP1 = 0;  
		clkP2 = 0;
  		clkCPU = 0;
		reset = 1;
  	
		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
      	#100;
  	
		$finish;
	end  

  	// Clock configuration
	always #17 clkP1 = !clkP1;
	always #8 clkP2 = !clkP2;
	always #10 clkCPU = !clkCPU;
  
endmodule