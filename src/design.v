`timescale 1ns/1ps

module adder_subtractor_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       mode,
    output wire [7:0] result,
    output wire       cout,
    output wire       overflow
);

    wire [7:0] b_xor;
    wire [8:0] sum;
    wire       carry_raw;

    assign b_xor = b ^ {8{mode}};
    assign sum = {1'b0, a} + {1'b0, b_xor} + {8'b0, mode};

    assign result    = sum[7:0];
    assign carry_raw = sum[8];

    assign cout = carry_raw ^ mode;
    assign overflow = (a[7] == b_xor[7]) && (result[7] != a[7]);

endmodule