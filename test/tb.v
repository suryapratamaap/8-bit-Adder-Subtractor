`timescale 1ns/1ps

module tb;
    reg  [7:0] a;
    reg  [7:0] b;
    reg        mode;
    wire [7:0] result;
    wire       cout;
    wire       overflow;

    integer    pass_count;
    integer    fail_count;
    reg [39:0] status;     

    adder_subtractor_8bit uut (
        .a       (a),
        .b       (b),
        .mode    (mode),
        .result  (result),
        .cout    (cout),
        .overflow(overflow)
    );

    task uji;
        input [7:0] ta;
        input [7:0] tbv;
        input       tmode;
        input [7:0] exp_result;
        input       exp_cout;
        input       exp_ovf;
        begin
            a    = ta;
            b    = tbv;
            mode = tmode;
            #10;

            if (result === exp_result && cout === exp_cout && overflow === exp_ovf) begin
                status     = "LULUS";
                pass_count = pass_count + 1;
            end else begin
                status     = "GAGAL";
                fail_count = fail_count + 1;
            end

            $display("A=%3d (%b) | B=%3d (%b) | mode=%b (%s) | result=%3d (%b) | cout=%b | overflow=%b | %s",
                     a, a, b, b, mode, (mode ? "SUB" : "ADD"),
                     result, result, cout, overflow, status);
        end
    endtask

    initial begin
      
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        pass_count = 0;
        fail_count = 0;
        a = 8'd0; b = 8'd0; mode = 1'b0;
        #10;

        $display("=== 8-bit Adder-Subtractor ===");

        // ---------------- Pengujian Penjumlahan (mode = 0) ----------------
        //   (a, b, mode, result, cout, overflow)
        uji(8'd10,  8'd5,  1'b0, 8'd15,  1'b0, 1'b0);  // 10 + 5   = 15
        uji(8'd100, 8'd50, 1'b0, 8'd150, 1'b0, 1'b1);  // 100 + 50 = 150 (signed overflow)
        uji(8'd255, 8'd1,  1'b0, 8'd0,   1'b1, 1'b0);  // 255 + 1  = 0, carry-out = 1
        uji(8'd0,   8'd0,  1'b0, 8'd0,   1'b0, 1'b0);  // 0 + 0    = 0
        uji(8'd127, 8'd1,  1'b0, 8'd128, 1'b0, 1'b1);  // 127 + 1  = 128 (signed overflow)

        // ---------------- Pengujian Pengurangan (mode = 1) ----------------
        uji(8'd10,  8'd5,  1'b1, 8'd5,   1'b0, 1'b0);  // 10 - 5   = 5
        uji(8'd100, 8'd50, 1'b1, 8'd50,  1'b0, 1'b0);  // 100 - 50 = 50
        uji(8'd5,   8'd10, 1'b1, 8'd251, 1'b1, 1'b0);  // 5 - 10   = 251 (-5), borrow = 1
        uji(8'd255, 8'd1,  1'b1, 8'd254, 1'b0, 1'b0);  // 255 - 1  = 254
        uji(8'd0,   8'd0,  1'b1, 8'd0,   1'b0, 1'b0);  // 0 - 0    = 0

        // ---------------- Tambahan: overflow pada pengurangan ----------------
        uji(8'd128, 8'd1,  1'b1, 8'd127, 1'b0, 1'b1);  // (-128) - 1 -> overflow

        $display("=== Selesai: %0d lulus, %0d gagal ===", pass_count, fail_count);
        $finish;
    end

endmodule