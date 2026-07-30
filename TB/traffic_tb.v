`timescale 1ns/1ps

module traffic_tb;

    //=========================================================
    // Testbench Signals
    //=========================================================

    reg clk;
    reg rst;
    reg emergency_ns;
    reg emergency_ew;

    wire ns_red;
    wire ns_yellow;
    wire ns_green;

    wire ew_red;
    wire ew_yellow;
    wire ew_green;

    //=========================================================
    // Instantiate DUT (Device Under Test)
    //=========================================================

    top DUT (

        .clk(clk),
        .rst(rst),

        .emergency_ns(emergency_ns),
        .emergency_ew(emergency_ew),

        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),

        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)

    );

    //=========================================================
    // Waveform Generation
    //=========================================================

    initial
    begin
        $dumpfile("traffic.vcd");
        $dumpvars(0, traffic_tb);
    end

    //=========================================================
    // Console Monitor
    //=========================================================

    initial
    begin
        $monitor(
        "Time=%0t | NS(R,Y,G)=%b%b%b | EW(R,Y,G)=%b%b%b | EM_NS=%b EM_EW=%b",
        $time,
        ns_red, ns_yellow, ns_green,
        ew_red, ew_yellow, ew_green,
        emergency_ns, emergency_ew
        );
    end

    //=========================================================
    // Clock Generation
    //=========================================================

    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //=========================================================
    // Test Cases
    //=========================================================

    initial
    begin

        $display("==========================================");
        $display(" Traffic Light Controller Simulation");
        $display("==========================================");

        //-------------------------------------
        // Initialize Inputs
        //-------------------------------------

        rst = 1;
        emergency_ns = 0;
        emergency_ew = 0;

        //-------------------------------------
        // Apply Reset
        //-------------------------------------

        #20;
        rst = 0;

        //-------------------------------------
        // Normal Operation
        //-------------------------------------

        #100;

        //-------------------------------------
        // Emergency on North-South
        //-------------------------------------

        $display("North-South Emergency Activated");

        emergency_ns = 1;

        #40;

        emergency_ns = 0;

        $display("North-South Emergency Cleared");

        //-------------------------------------
        // Normal Operation
        //-------------------------------------

        #100;

        //-------------------------------------
        // Emergency on East-West
        //-------------------------------------

        $display("East-West Emergency Activated");

        emergency_ew = 1;

        #40;

        emergency_ew = 0;

        $display("East-West Emergency Cleared");

        //-------------------------------------
        // Continue Simulation
        //-------------------------------------

        #100;

        $display("==========================================");
        $display("Simulation Completed Successfully");
        $display("==========================================");

        $finish;

    end

endmodule