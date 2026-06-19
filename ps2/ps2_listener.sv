//PS2_Listener Module
//Created by Rex Paster
module ps2_listener (
    input  logic reset,

    input  logic ps2_clk,
    input  logic ps2_data,

    output logic [31:0] lastFourBytes, penultamateFourBytes
);

    //Data Collection via Shift Register
    //Shift Register Shifts on Negative Clock Edge as This is when data is known to be valid
    logic [87:0] raw_data;
    always_ff @(negedge ps2_clk or posedge reset) begin
        if (reset) begin
            raw_data <= 88'b0;
        end else begin
            // Shift left
            raw_data <= {raw_data[86:0], ps2_data};
        end
    end

    //Data Validation
    logic [7:0] validParity, validStart, validStop;

    always_comb begin //Parity Logic
        validParity[0] = (^raw_data[9:1] == 1);   //Check Byte1 Parity
        validParity[1] = (^raw_data[20:12] == 1); //Check Byte2 Parity
        validParity[2] = (^raw_data[31:23] == 1); //Check Byte3 Parity
        validParity[3] = (^raw_data[42:34] == 1); //Check Byte4 Parity
        validParity[4] = (^raw_data[53:45] == 1); //Check Byte5 Parity
        validParity[5] = (^raw_data[64:56] == 1); //Check Byte6 Parity
        validParity[6] = (^raw_data[75:67] == 1); //Check Byte7 Parity
        validParity[7] = (^raw_data[86:78] == 1); //Check Byte8 Parity
    end

    always_comb begin //StartBit Logic
        validStart[0] = (raw_data[10] == 0); //Check Byte1 StartBit
        validStart[1] = (raw_data[21] == 0); //Check Byte2 StartBit
        validStart[2] = (raw_data[32] == 0); //Check Byte3 StartBit
        validStart[3] = (raw_data[43] == 0); //Check Byte4 StartBit
        validStart[4] = (raw_data[54] == 0); //Check Byte5 StartBit
        validStart[5] = (raw_data[65] == 0); //Check Byte6 StartBit
        validStart[6] = (raw_data[76] == 0); //Check Byte7 StartBit
        validStart[7] = (raw_data[87] == 0); //Check Byte8 StartBit
    end

    always_comb begin //StopBit Logic
        validStop[0] = (raw_data[0] == 1); //Check Byte1 StopBit
        validStop[1] = (raw_data[11] == 1); //Check Byte2 StopBit
        validStop[2] = (raw_data[22] == 1); //Check Byte3 StopBit
        validStop[3] = (raw_data[33] == 1); //Check Byte4 StopBit
        validStop[4] = (raw_data[44] == 1); //Check Byte5 StopBit
        validStop[5] = (raw_data[55] == 1); //Check Byte6 StopBit
        validStop[6] = (raw_data[66] == 1); //Check Byte7 StopBit
        validStop[7] = (raw_data[77] == 1); //Check Byte8 StopBit
    end

    //Raw Data Conversion
    logic [7:0] scancode1, scancode2, scancode3, scancode4, scancode5, scancode6, scancode7, scancode8;
    reverser reverser_b1 (
        .original(raw_data[9:2]),
        .reversed(scancode1)
    );

    reverser reverser_b2 (
        .original(raw_data[20:13]),
        .reversed(scancode2)
    );

    reverser reverser_b3 (
        .original(raw_data[31:24]),
        .reversed(scancode3)
    );

    reverser reverser_b4 (
        .original(raw_data[42:35]),
        .reversed(scancode4)
    );

    reverser reverser_b5 (
        .original(raw_data[53:46]),
        .reversed(scancode5)
    );

    reverser reverser_b6 (
        .original(raw_data[64:57]),
        .reversed(scancode6)
    );

    reverser reverser_b7 (
        .original(raw_data[75:68]),
        .reversed(scancode7)
    );

    reverser reverser_b8 (
        .original(raw_data[86:79]),
        .reversed(scancode8)
    );


    //Output Logic
    always_comb begin
        lastFourBytes[7:0] = (validParity[0] & validStart[0] & validStop[0]) ? scancode1 : 8'b0;
        lastFourBytes[15:8] = (validParity[1] & validStart[1] & validStop[1]) ? scancode2 : 8'b0;
        lastFourBytes[23:16] = (validParity[2] & validStart[2] & validStop[2]) ? scancode3 : 8'b0;
        lastFourBytes[31:24] = (validParity[3] & validStart[3] & validStop[3]) ? scancode4 : 8'b0;
        penultamateFourBytes[7:0] = (validParity[4] & validStart[4] & validStop[4]) ? scancode5 : 8'b0;
        penultamateFourBytes[15:8] = (validParity[5] & validStart[5] & validStop[5]) ? scancode6 : 8'b0;
        penultamateFourBytes[23:16] = (validParity[6] & validStart[6] & validStop[6]) ? scancode7 : 8'b0;
        penultamateFourBytes[31:24] = (validParity[7] & validStart[7] & validStop[7]) ? scancode8 : 8'b0;
    end

endmodule

//Byte Reverser
module reverser (
    input logic [7:0] original,
    output logic [7:0] reversed
);
always_comb begin
    reversed[7] = original[0];
    reversed[6] = original[1];
    reversed[5] = original[2];
    reversed[4] = original[3];
    reversed[3] = original[4];
    reversed[2] = original[5];
    reversed[1] = original[6];
    reversed[0] = original[7];
end
endmodule