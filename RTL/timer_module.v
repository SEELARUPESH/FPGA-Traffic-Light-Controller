module timer (

    input  wire clk,
    input  wire rst,

    input  wire [2:0] current_state,

    output reg timer_done

);

    //=========================================
    // Timer Values
    //=========================================

    parameter GREEN_TIME  = 5;
    parameter YELLOW_TIME = 2;

    //=========================================
    // State Definitions
    //=========================================

    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;

    //=========================================
    // Counter
    //=========================================

    reg [3:0] count;
    reg [3:0] max_count;

    //=========================================
    // Select Timer Duration
    //=========================================

    always @(*)
    begin

        case(current_state)

            S0: max_count = GREEN_TIME;
            S1: max_count = YELLOW_TIME;

            S2: max_count = GREEN_TIME;
            S3: max_count = YELLOW_TIME;

            S4: max_count = GREEN_TIME;
            S5: max_count = GREEN_TIME;

            default:
                max_count = GREEN_TIME;

        endcase

    end

    //=========================================
    // Timer Counter
    //=========================================

    always @(posedge clk or posedge rst)
    begin

        if(rst)
        begin
            count <= 0;
            timer_done <= 0;
        end

        else
        begin

            if(count == max_count-1)
            begin
                count <= 0;
                timer_done <= 1;
            end

            else
            begin
                count <= count + 1;
                timer_done <= 0;
            end

        end

    end

endmodule