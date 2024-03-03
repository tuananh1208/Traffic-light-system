module top(
    output led4_b, led4_g, led4_r, led5_b, led5_g, led5_r, 
    output [6:0] ck_io,
    input clk, btn
    );
    wire[2:0] led1, led2;
    assign {led4_r, led4_g, led4_b} = led1;
    assign {led5_r, led5_g, led5_b} = led2;
    crossroad_traffic_light crl(.led1(led1), .led2(led2),.led_out(ck_io), .clk_in(clk), .rst(btn));
endmodule
