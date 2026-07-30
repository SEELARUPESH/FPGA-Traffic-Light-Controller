module traffic_fsm (

    input wire clk,
    input wire rst,

    input wire timer_done,

    input wire emergency_ns,
    input wire emergency_ew,

    output reg ns_red,
    output reg ns_yellow,
    output reg ns_green,

    output reg ew_red,
    output reg ew_yellow,
    output reg ew_green,

    output wire [2:0] state

);

    //======================================================
    // State Definitions
    //======================================================

    parameter S0 = 3'b000;   // NS Green, EW Red
    parameter S1 = 3'b001;   // NS Yellow, EW Red
    parameter S2 = 3'b010;   // NS Red, EW Green
    parameter S3 = 3'b011;   // NS Red, EW Yellow
    parameter S4 = 3'b100;   // Emergency NS
    parameter S5 = 3'b101;   // Emergency EW

    //======================================================
    // State Registers
    //======================================================

    reg [2:0] current_state;
    reg [2:0] next_state;

    // Make current state available to timer.v
    assign state = current_state;

    //======================================================
    // State Register (Sequential Logic)
    //======================================================

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    //======================================================
    // Next-State Logic
    //======================================================

    always @(*)
    begin

        // Default: Stay in current state
        next_state = current_state;

        case(current_state)

            //====================================
            // S0 : NS Green, EW Red
            //====================================
            S0:
            begin
                if (emergency_ns)
                    next_state = S4;
                else if (emergency_ew)
                    next_state = S5;
                else if (timer_done)
                    next_state = S1;
            end

            //====================================
            // S1 : NS Yellow, EW Red
            //====================================
            S1:
            begin
                if (emergency_ns)
                    next_state = S4;
                else if (emergency_ew)
                    next_state = S5;
                else if (timer_done)
                    next_state = S2;
            end

            //====================================
            // S2 : NS Red, EW Green
            //====================================
            S2:
            begin
                if (emergency_ns)
                    next_state = S4;
                else if (emergency_ew)
                    next_state = S5;
                else if (timer_done)
                    next_state = S3;
            end

            //====================================
            // S3 : NS Red, EW Yellow
            //====================================
            S3:
            begin
                if (emergency_ns)
                    next_state = S4;
                else if (emergency_ew)
                    next_state = S5;
                else if (timer_done)
                    next_state = S0;
            end

            //====================================
            // S4 : Emergency North-South
            //====================================
            S4:
            begin
                if (!emergency_ns)
                    next_state = S0;
            end

            //====================================
            // S5 : Emergency East-West
            //====================================
            S5:
            begin
                if (!emergency_ew)
                    next_state = S0;
            end

            //====================================
            // Safety Recovery
            //====================================
            default:
                next_state = S0;

        endcase

    end

    //======================================================
    // Output Logic
    //======================================================

    always @(*)
    begin

        // Default: Turn OFF all lights
        ns_red    = 0;
        ns_yellow = 0;
        ns_green  = 0;

        ew_red    = 0;
        ew_yellow = 0;
        ew_green  = 0;

        case(current_state)

            //====================================
            // S0 : NS Green, EW Red
            //====================================
            S0:
            begin
                ns_green = 1;
                ew_red   = 1;
            end

            //====================================
            // S1 : NS Yellow, EW Red
            //====================================
            S1:
            begin
                ns_yellow = 1;
                ew_red    = 1;
            end

            //====================================
            // S2 : NS Red, EW Green
            //====================================
            S2:
            begin
                ns_red   = 1;
                ew_green = 1;
            end

            //====================================
            // S3 : NS Red, EW Yellow
            //====================================
            S3:
            begin
                ns_red    = 1;
                ew_yellow = 1;
            end

            //====================================
            // S4 : Emergency North-South
            //====================================
            S4:
            begin
                ns_green = 1;
                ew_red   = 1;
            end

            //====================================
            // S5 : Emergency East-West
            //====================================
            S5:
            begin
                ns_red   = 1;
                ew_green = 1;
            end

            //====================================
            // Default Safe State
            //====================================
            default:
            begin
                ns_red = 1;
                ew_red = 1;
            end

        endcase

    end

endmodule