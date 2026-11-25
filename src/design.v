`timescale 1ns/1ps

module adder_subtractor_8bit (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       mode,
    output reg  [7:0] result,
    output reg        cout,
    output reg        overflow
);

    wire [7:0] b_xor;
    wire [8:0] sum;

    assign b_xor = b ^ {8{mode}};
    assign sum   = {1'b0, a} + {1'b0, b_xor} + {8'b0, mode};

    always @(posedge clk) begin
        if (rst_n == 1'b0) begin
            result   = 8'd0;
            cout     = 1'b0;
            overflow = 1'b0;
        end else begin
            result   = sum[7:0];
            cout     = sum[8] ^ mode;
            overflow = (a[7] == b_xor[7]) & (sum[7] != a[7]);
        end
    end

endmodule