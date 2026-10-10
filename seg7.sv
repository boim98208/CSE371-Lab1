module seg7 (
    input  logic [3:0] digit, // 0..5 supported
    output logic [6:0] seg
);
    always_comb begin
        case (digit)
            4'd0: seg = 7'b1000000; // 0,
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            default: seg = 7'b1111111; // blank
        endcase
    end
endmodule

module seg7_testbench();
    logic clk;
    logic [3:0] digit;
    logic [6:0] seg;

    seg7 dut (
        .digit(digit),
        .seg(seg)
    );

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        repeat(1) @(posedge clk);
        digit <= 4'd0; repeat(2) @(posedge clk);
        digit <= 4'd1; repeat(2) @(posedge clk);
        digit <= 4'd2; repeat(2) @(posedge clk);
        digit <= 4'd3; repeat(2) @(posedge clk);
        digit <= 4'd4; repeat(2) @(posedge clk);
        digit <= 4'd5; repeat(2) @(posedge clk);
        digit <= 4'd14; repeat(2) @(posedge clk);
        $stop;
    end
endmodule