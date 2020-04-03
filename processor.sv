// Arquitetura e Organização de computadores II - Fabiane e Gabriel
`timescale 1ns / 1ps 

module processorFSM(ack1, ack2, outsend1, outsend2, outdata1, outdata2, clkCPU, rst);
   
  input clkCPU, ack1, ack2, rst;
  output reg outsend1, outsend2;
  output reg [15:0] outdata1, outdata2;
  reg [15:0] datac1, datac2;
  
  // Using enum is a good practice for instantiating fsm, because you can give a nickname to the states instead of a number and it's easier to undestand the code
  // sending.= first state, waiting = second state 
  enum {sending, waiting} fsm1, fsm2, nextfsm1, nextfsm2;
 
  // For simulation purposes only
  initial begin
    // Use a random number to the peripheral 1
    datac1 = $random%10;
    // Use a the number 2 to the peripheral 2 
    datac2 = 16'd2;
    fsm1 = waiting;
    fsm2 = waiting;
  end
  
  always@(posedge clkCPU) begin
    if (rst == 1)
      begin
		fsm1 = waiting;
      	fsm2 = waiting;
      end
    else
      begin
    	case(fsm1) // Fist state machine
      		sending: begin // Sending is the first state
              outdata1[15:0] = datac1[15:0];
              outsend1 = 1'd1; 
            end
      		waiting: begin // Waiting is the second state
        		outsend1 <= 1'b0;
      		end
    	endcase
      end
     // The current state is updated
    fsm1 <= nextfsm1; 
  end
 
  always@(posedge clkCPU) begin
     if (rst == 1)
       begin
         fsm1 = waiting;
         fsm2 = waiting;
       end
    else
      begin
        case(fsm2) // Second state machine
          sending: begin // Sending is the first state
            outdata2[15:0] <= datac2[15:0];
            outsend2 <= 1'b1;
          end
          waiting: begin // Waiting is the second state
            outsend2 <= 1'b0;
          end
        endcase
      end
    // The current state is updated
    fsm2 <= nextfsm2;
  end
 
 
// Transitions between states, assigning on the next state
  always@(*) begin
    case(fsm1)
      sending: begin
        if(ack1)
          nextfsm1 = waiting;
        else
          nextfsm1 = sending;
      end
      waiting: begin
        if(ack1)
          nextfsm1 = waiting;
        else
          nextfsm1 = sending;
      end
    endcase
   
    case(fsm2)
      sending: begin
        if(ack2)
          nextfsm2 = waiting;
        else
          nextfsm2 = sending;
      end
      waiting: begin
        if(ack2)
          nextfsm2 = waiting;
        else
          nextfsm2 = sending;
      end
    endcase
  end
  
 // Visualization - good to check if the process is right
  always @ (*)
    begin
      $display("------PROCESSOR: PERIPHERAL 1-------");      
      $display("outdata1: %d",outdata1);
      $display("outsend1: %d",outsend1);
      $display("ack1: %d",ack1);
      $display("------PROCESSOR: PERIPHERAL 2-------");            
      $display("outdata2: %d",outdata2);
      $display("outsend2: %d",outsend2);
      $display("ack2: %d",ack2);
    end
 
endmodule