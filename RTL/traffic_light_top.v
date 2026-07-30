module top (

    input wire clk,
    input wire rst,

    input wire emergency_ns,
    input wire emergency_ew,

    output wire ns_red,
    output wire ns_yellow,
    output wire ns_green,

    output wire ew_red,
    output wire ew_yellow,
    output wire ew_green

);

    //==========================================
    // Internal Signals
    //==========================================

    wire timer_done;
    wire [2:0] state;

    //==========================================
    // Traffic FSM Instance
    //==========================================

    traffic_fsm FSM (

        .clk(clk),
        .rst(rst),

        .timer_done(timer_done),

        .emergency_ns(emergency_ns),
        .emergency_ew(emergency_ew),

        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),

        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green),

        .state(state)

    );

    //==========================================
    // Timer Instance
    //==========================================

    timer TIMER (

        .clk(clk),
        .rst(rst),

        .current_state(state),

        .timer_done(timer_done)

    );

endmodule