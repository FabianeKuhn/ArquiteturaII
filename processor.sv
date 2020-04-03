`timescale 1ns / 1ps 
//First, we have to instantiate all interface with external modules as parameters
module processorFSM(ack1, ack2, outsend1, outsend2, outdata1, outdata2, clkCPU, rst);
   
  // Next thing, we must say what kind of interface they are: input, output or another (yes, it could be other obscure things)
  input clkCPU, ack1, ack2, rst; // Default type is wire
  output reg outsend1, outsend2;
  // Every output that is assigned on a sequential block (sync) must be of type reg, if its a combinational block (async), should be wire
  output reg [15:0] outdata1, outdata2;
 
  // Reg is the most basic data storage type, it represents flipflops,while wire represents efemeral wires that don't store value
  reg [15:0] datac1, datac2;
 
  // using enum is a good practice for instantiating fsm, because you can give a nickname to the states instead of a number
  // it could also be achieved through the keyword parameter, but enum attachs itself to these variables only
  typedef enum {sending, waiting} state_e;
  state_e fsm1, fsm2, nextfsm1, nextfsm2;


 
  // it executes before the simulations, for setting variable or automating tests, all regular logic
  // of other programming languages are permitted here
  // BEWARE: not synthesizeable, for simulation purposes only
  initial begin
    datac1 = $random;
    datac2 = 16'd0;
    fsm1 = waiting;
    fsm2 = waiting;
  end
  
  // Always is the main block for sequential logic
  // this one is trigged on the posedge of the clk, so everytime the clock goes from 1 to 0, it executes
  always@(posedge clkCPU) begin
    if (rst == 1)
      begin
		fsm1 = waiting;
      	fsm2 = waiting;
      end
    else
      begin
    	case(fsm1) // Fist state machine
      		sending: begin //sending represents a 0 for the fsm1, because its an enum
        // its a good practice to always explicitly say the range of bits involved on a operation, because its not always every bit
              outdata1[15:0] = datac1[15:0];
              outsend1 = 1'd1; // its a good practice to always say the full bits and type of a constant, even tho decimal can be ommited
            end
      		waiting: begin
        		outsend1 <= 1'b0;
      		end
    	endcase
      end
    // The last thing that happens on the cycle, is to update the fsm with the nextfsm, so the next cycle starts on the correct one
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
          sending: begin
            outdata2[15:0] <= datac2[15:0];
            outsend2 <= 1'b1;
          end
          waiting: begin
            outsend2 <= 1'b0;
          end
        endcase
      end
    // The last thing that happens on the cycle, is to update the fsm with the nextfsm, so the next cycle starts on the correct one
    fsm2 <= nextfsm2;
  end
 
 
  /* Always can be used as combinational block if trigged on * (anything)
    i.e. it executes all the time, if anything on the system changes, it executes
    you could use the block assign, but you would have to use other kind of logic for the functions
    that are not always the most intuitive
  */
  always@(*) begin
    case(fsm1)
      sending: begin
        // Here we make the transitions between states, assigning on the next state
        // We don't change the current state, or it would be updated everywhere at the same time, what could get things lost
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
 
endmodule