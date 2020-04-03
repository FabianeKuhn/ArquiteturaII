`timescale 1ns / 1ps 

module peripheralFSM (send, clk, rst, dataP, outack);
	output reg outack;

  input send, clk, rst;
  input [15:0] dataP;

  // using enum is a good practice for instantiating fsm, because you can give a nickname to the states instead of a number
  // it could also be achieved through the keyword parameter, but enum attachs itself to these variables only
  typedef enum {waiting, acknowledging} state_e; 
  state_e fsm, nextfsm;
  
  reg [15:0] data;


  always @ (posedge clk)
	begin
      if (rst == 1)
        fsm = waiting;
      else
        begin
          case(fsm)
            waiting: begin
        	// Here we make the transitions between states, assigning on the next state
        	// We don't change the current state, or it would be updated everywhere at the same time, what could get things lost
              if(send)
                nextfsm <= acknowledging;
              else
                nextfsm <= waiting;
            end
            acknowledging: begin
              if(send)
                nextfsm <= acknowledging;
              else
                nextfsm <= waiting;
            end
          endcase
        end
    end
        
	// Outputs
  always @ (*)
	begin
      case ({fsm})	
        waiting: begin
          outack <= 0;
        end
        acknowledging: begin
          data <= dataP;
          outack <= 1;
        end
      endcase
    end  

endmodule