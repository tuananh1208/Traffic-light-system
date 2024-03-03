module crossroad_traffic_light(
    output reg [2:0] led1, led2, 
    output reg [6:0] led_out,
    input clk_in, rst
    );
    parameter RED = 3'b100, 
              GREEN = 3'b010,
              YELLOW = 3'b110,
              L1G_L2R = 2'b00, // led1 green  & led2 red
              L1Y_L2R = 2'b01, // led1 yellow & led2 red
              L1R_L2G = 2'b10, // led1 red    & led2 green
              L1R_L2Y = 2'b11, // led1 yellow & led2 green
              DIVISOR = 28'd125000000,
              YELLOW_delay = 4'd2, // yellow light countdown for 2s
              GREEN_delay = 4'd7,  // green light countdown for 7s
              RED_delay = 4'd9;    // red light countdown for 9s
    reg[1:0] state, next_state;
    reg GREEN_count_en = 0, YELLOW_count_en = 0, delay7s = 0, delay2s = 0;
    reg[27:0] clk_counter = 0;
    reg[27:0] count_delay = 0;
    reg clk; // 1hz clock

    // state - next_state
    always @(posedge clk_in, posedge rst) begin
        if (rst) state <= 2'b00;
        else state <= next_state;
    end
    
    // FSM
    always @(*) begin 
        case (state)
            L1G_L2R: begin
                led1 = GREEN;
                led2 = RED;
                GREEN_count_en = 1;
                YELLOW_count_en = 0;
                if (delay7s) next_state = L1Y_L2R;
                else next_state = L1G_L2R;
            end
            L1Y_L2R: begin
                led1 = YELLOW;
                led2 = RED;
                YELLOW_count_en = 1;
                GREEN_count_en = 0;
                    if (delay2s) next_state = L1R_L2G;
                else next_state = L1Y_L2R;
            end
            L1R_L2G: begin
                led1 = RED;
                led2 = GREEN;
                GREEN_count_en = 1;
                YELLOW_count_en = 0;
                if (delay7s) next_state = L1R_L2Y;
                else next_state = L1R_L2G;
            end
            L1R_L2Y: begin
                led1 = RED;
                led2 = YELLOW;
                YELLOW_count_en = 1;
                GREEN_count_en = 0;
                if (delay2s) next_state = L1G_L2R;
                else next_state = L1R_L2Y;
            end        
            default: next_state = L1G_L2R;
        endcase
    end
    
    // create green & yellow countdown
    always @(posedge clk) begin
    //if (clk == 1) begin
        if (GREEN_count_en || YELLOW_count_en)
            count_delay <= count_delay + 28'b1;
            if ((count_delay == GREEN_delay-1) && GREEN_count_en) begin
                delay7s <= 1;
                delay2s <= 0;
                count_delay <= 0;
            end
            else if ((count_delay == YELLOW_delay-1) && YELLOW_count_en) begin
                delay7s <= 0;
                delay2s <= 1;
                count_delay <= 0;            
            end
            else begin
                delay7s <= 0;
                delay2s <= 0;
            end     
       // end
    end      
      
    // create 1hz clock
    always @(posedge clk_in) begin
        clk_counter <= clk_counter + 1;
        if (clk_counter >= (DIVISOR-1)) 
            clk_counter <= 28'd0;
            clk <= (clk_counter < DIVISOR/2)?1'b1:1'b0;
    end
    
    
    // 7-segment led
    wire[6:0] led7;   
    assign led7 = (GREEN_count_en) ? RED_delay-1 - count_delay:
                  (YELLOW_count_en) ? YELLOW_delay-1 - count_delay:
                  10;
    always @(*) begin
            case (led7) 
                0: led_out = 7'b1000000;
                1: led_out = 7'b1111001;
                2: led_out = 7'b0100100;
                3: led_out = 7'b0110000;
                4: led_out = 7'b0011001;
                5: led_out = 7'b0010010;
                6: led_out = 7'b0000010;
                7: led_out = 7'b1111000;
                8: led_out = 7'b0000000;
                9: led_out = 7'b0010000;
                default: led_out = 7'b1111111;
            endcase
    end
    
    
endmodule



 
