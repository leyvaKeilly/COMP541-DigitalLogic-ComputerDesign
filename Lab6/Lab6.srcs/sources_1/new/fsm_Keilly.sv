//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/28/2017 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module fsm_Keilly(
    input wire clock,
    input wire up, down, center,         // List of inputs to FSM
    output logic countUp, paused        // List of outputs of FSM
                                        // The outputs must be synthesized as combinational logic!
    );


      // The next line is our state encoding
      // You enumerate states, and the compiler decides state encoding

    enum { CountingUp, CountingDown, PausingUp, ResumingUp, ResumingDown, PausingDown, PausedUp, PausedDown} state, next_state;

      // -- OR --   
      // You can specify state encoding

   // enum { STATE0=2'b00, STATE1=2'b01, STATE2=2'b10, ... etc. } state, next_state;



        // Instantiate the state storage elements (flip-flops)
        always_ff @(posedge clock)
           state <= next_state;


        // Define next_state logic => combinational
        // Every case must either be a conditional expression
        //   or an "if" with a matching "else"
    always_comb     
      case (state)
            CountingUp: next_state <= (center ? PausingUp : (down ? CountingDown : CountingUp));
            CountingDown: next_state <= (center ? PausingDown : (up ? CountingUp : CountingDown));
            PausingUp: next_state <= (~center ? PausedUp : PausingUp);
            ResumingUp: next_state <= (~center ? CountingUp : ResumingUp);
            ResumingDown: next_state <= (~center ? CountingDown : ResumingDown);
            PausingDown: next_state <= (~center ? PausedDown : PausingDown);
            PausedUp: next_state <= (center ? ResumingUp : (down ? PausedDown : PausedUp));
            PausedDown: next_state <= (center ? ResumingDown : (up ? PausedUp : PausedDown));
            default: next_state <= state;
      endcase


        // Define output logic => combinational
        // Every case must either be a conditional expression
        //   or an "if" with a matching "else"
    always_comb     
      case (state)
           // STATE1: {out1, out2, out3, ...} <= ...;
            CountingUp: {countUp, paused} <= {1'b1, 1'b0};
            CountingDown: {countUp, paused} <= {1'b0, 1'b0};
            PausingUp: {countUp, paused} <= {1'b1, 1'b1};
            ResumingUp: {countUp, paused} <= {1'b1, 1'b0};
            ResumingDown: {countUp, paused} <= {1'b0, 1'b0};
            PausingDown: {countUp, paused} <= {1'b0, 1'b1};
            PausedUp: {countUp, paused} <= {1'b1, 1'b1};
            PausedDown: {countUp, paused} <= {1'b0, 1'b1};
            default: {countUp, paused} <= {1'b1, 1'b0};
      endcase

endmodule
