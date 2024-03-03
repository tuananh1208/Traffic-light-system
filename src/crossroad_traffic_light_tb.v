`timescale 1ns / 1ps


module crossroad_traffic_light_tb;
    wire [2:0] led1, led2; 
	wire [6:0] led7s;
    reg clk_in, rst;
    
    crossroad_traffic_light UUT(.led1(led1), .led2(led2), .clk_in(clk_in), .rst(rst), .led_out(led7s));

    initial begin
             clk_in = 1'b0; rst = 1'b0;
            forever #10 clk_in = ~clk_in;
    end    
endmodule
