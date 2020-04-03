// Arquitetura e Organização de computadores II - Fabiane e Gabriel
`timescale 1ns / 1ps 

module peripheralFSM (send, clk, rst, data, outack);
	
  output reg outack;
  reg [15:0] dataP;
  input send, clk, rst;
  input [15:0] data;

  // Using enum is a good practice for instantiating fsm, because you can give a nickname to the states instead of a number and it's easier to undestand the code
  // Waiting.= first state, acknowledging = second state
  enum {waiting, acknowledging} fsm, nextfsm;
  
  always @ (posedge clk)
	begin
      if (rst == 1)
        fsm = waiting;
      else
        begin
          case(fsm)
            // If the current state is the fist state
            waiting: begin
        	// Transitions between states, assigning on the next state
              if(send)
                nextfsm = acknowledging;
              else
                nextfsm = waiting;
            end
            // If the current state is the second state            
            acknowledging: begin
              if(send)
                nextfsm = acknowledging;
              else
                nextfsm = waiting;
            end
          endcase
        end
      // The current state is updated 
      fsm = nextfsm;
    end
        
  // Outputs
  always @ (*)
	begin
      case (fsm)	
        waiting: begin
          outack = 0;
        end
        acknowledging: begin
          dataP = data;
          outack = 1;
        end
      endcase
    end
  
  // Visualization - good to check if the process is right
  always @ (*)
    begin
      $display("------PERIPHERAL-------");            
      $display("perifFSM: %d",fsm);
      $display("data: %d",data);
      $display("dataP: %d",dataP);
      $display("outack: %d",outack);
    end

endmodule