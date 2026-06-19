module ps2_to_hack_decoder (
    input  logic [31:0] lastFourBytes,
    output logic [15:0] hack_code
);

    logic [7:0] b0, b1, b2;

    assign b0 = lastFourBytes[7:0];
    assign b1 = lastFourBytes[15:8];
    assign b2 = lastFourBytes[23:16];

    logic is_normal_release;
    logic is_extended_press;
    logic is_extended_release;

    assign is_normal_release   = (b1 == 8'hF0);
    assign is_extended_press   = (b1 == 8'hE0);
    assign is_extended_release = (b2 == 8'hE0) && (b1 == 8'hF0);

    always_comb begin
        hack_code = 16'd0;

        if (is_extended_release) begin
            hack_code = 16'd0;
        end

        else if (is_normal_release) begin
            hack_code = 16'd0;
        end

        else if (is_extended_press) begin
            unique case (b0)
                8'h6B: hack_code = 16'd130;
                8'h75: hack_code = 16'd131;
                8'h74: hack_code = 16'd132;
                8'h72: hack_code = 16'd133;
                8'h6C: hack_code = 16'd134;
                8'h69: hack_code = 16'd135;
                8'h7D: hack_code = 16'd136;
                8'h7A: hack_code = 16'd137;
                8'h70: hack_code = 16'd138;
                8'h71: hack_code = 16'd139;
                default: hack_code = 16'd0;
            endcase
        end

        else begin
            unique case (b0)
                8'h1C: hack_code = 16'd97;
                8'h32: hack_code = 16'd98;
                8'h21: hack_code = 16'd99;
                8'h23: hack_code = 16'd100;
                8'h24: hack_code = 16'd101;
                8'h2B: hack_code = 16'd102;
                8'h34: hack_code = 16'd103;
                8'h33: hack_code = 16'd104;
                8'h43: hack_code = 16'd105;
                8'h3B: hack_code = 16'd106;
                8'h42: hack_code = 16'd107;
                8'h4B: hack_code = 16'd108;
                8'h3A: hack_code = 16'd109;
                8'h31: hack_code = 16'd110;
                8'h44: hack_code = 16'd111;
                8'h4D: hack_code = 16'd112;
                8'h15: hack_code = 16'd113;
                8'h2D: hack_code = 16'd114;
                8'h1B: hack_code = 16'd115;
                8'h2C: hack_code = 16'd116;
                8'h3C: hack_code = 16'd117;
                8'h2A: hack_code = 16'd118;
                8'h1D: hack_code = 16'd119;
                8'h22: hack_code = 16'd120;
                8'h35: hack_code = 16'd121;
                8'h1A: hack_code = 16'd122;

                8'h16: hack_code = 16'd49;
                8'h1E: hack_code = 16'd50;
                8'h26: hack_code = 16'd51;
                8'h25: hack_code = 16'd52;
                8'h2E: hack_code = 16'd53;
                8'h36: hack_code = 16'd54;
                8'h3D: hack_code = 16'd55;
                8'h3E: hack_code = 16'd56;
                8'h46: hack_code = 16'd57;
                8'h45: hack_code = 16'd48;

                8'h29: hack_code = 16'd32;
                8'h0D: hack_code = 16'd9;
                8'h0E: hack_code = 16'd96;
                8'h4E: hack_code = 16'd45;
                8'h55: hack_code = 16'd61;
                8'h54: hack_code = 16'd91;
                8'h5B: hack_code = 16'd93;
                8'h5D: hack_code = 16'd92;
                8'h4C: hack_code = 16'd59;
                8'h52: hack_code = 16'd39;
                8'h41: hack_code = 16'd44;
                8'h49: hack_code = 16'd46;
                8'h4A: hack_code = 16'd47;

                8'h5A: hack_code = 16'd128;
                8'h66: hack_code = 16'd129;
                8'h76: hack_code = 16'd140;

                8'h05: hack_code = 16'd141;
                8'h06: hack_code = 16'd142;
                8'h04: hack_code = 16'd143;
                8'h0C: hack_code = 16'd144;
                8'h03: hack_code = 16'd145;
                8'h0B: hack_code = 16'd146;
                8'h83: hack_code = 16'd147;
                8'h0A: hack_code = 16'd148;
                8'h01: hack_code = 16'd149;
                8'h09: hack_code = 16'd150;
                8'h78: hack_code = 16'd151;
                8'h07: hack_code = 16'd152;

                default: hack_code = 16'd0;
            endcase
        end
    end

endmodule