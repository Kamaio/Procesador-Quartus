`timescale 1ns/1ps

module tb_top_level;

    reg clk;
    reg rst_n;
    wire [9:0] leds;
    wire [6:0] display0, display1, display2, display3, display4, display5;

    // Instanciación del módulo top_level
    top_level uut(
        .clk(clk),
        .rst_n(rst_n),
        .leds(leds),
        .display0(display0),
        .display1(display1),
        .display2(display2),
        .display3(display3),
        .display4(display4),
        .display5(display5)
    );

    // Generador de reloj correcto: periodo de 10 ns
    initial clk = 0;
    always #5 clk = ~clk; // Invierte clk cada 5 ns

    initial begin
        rst_n = 0;
        #12;
        rst_n = 1;
        #100;
        $finish;
    end

endmodule
