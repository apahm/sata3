`timescale 1ns / 1ps
`define DLY #1

module gtwizard_common_reset  #
(
    parameter     STABLE_CLOCK_PERIOD      = 8        // Period of the stable clock driving this state-machine, unit is [ns]
)
(    
    input  wire      STABLE_CLOCK,             //Stable Clock, either a stable clock from the PCB
    input  wire      SOFT_RESET,               //User Reset, can be pulled any time
    output reg      COMMON_RESET = 1'b0             //Reset QPLL
);


  localparam integer  STARTUP_DELAY    = 500;//AR43482: Transceiver needs to wait for 500 ns after configuration
  localparam integer WAIT_CYCLES      = STARTUP_DELAY / STABLE_CLOCK_PERIOD; // Number of Clock-Cycles to wait after configuration
  localparam integer WAIT_MAX         = WAIT_CYCLES + 10;                    // 500 ns plus some additional margin

  reg [7:0] init_wait_count = 0;
  reg       init_wait_done = 1'b0;
  wire      common_reset_i;
  reg       common_reset_asserted = 1'b0;

  localparam INIT = 1'b0;
  localparam ASSERT_COMMON_RESET = 1'b1;
    
  reg state = INIT;

  always @(posedge STABLE_CLOCK)
  begin
      // The counter starts running when configuration has finished and 
      // the clock is stable. When its maximum count-value has been reached,
      // the 500 ns from Answer Record 43482 have been passed.
      if (init_wait_count == WAIT_MAX) 
          init_wait_done <= `DLY  1'b1;
      else
        init_wait_count <= `DLY  init_wait_count + 1;
  end


  always @(posedge STABLE_CLOCK)
  begin
      if (SOFT_RESET == 1'b1)
       begin
         state <= INIT;
         COMMON_RESET <= 1'b0;
         common_reset_asserted <= 1'b0;
       end
      else
       begin
        case (state)
         INIT :
          begin
            if (init_wait_done == 1'b1) state <= ASSERT_COMMON_RESET;
          end
         ASSERT_COMMON_RESET :
          begin
            if(common_reset_asserted == 1'b0)
              begin
                COMMON_RESET <= 1'b1;
                common_reset_asserted <= 1'b1;
              end
            else
                COMMON_RESET <= 1'b0;
          end
          default:
              state <=  INIT; 
        endcase
       end
   end 


endmodule 
