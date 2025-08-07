`timescale 1ns / 1ps
`ifndef CRC_V_
`define CRC_V_
// CRC polynomial coefficients: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
//                              0xEDB88320 (hex, обратный полином CRC32)
// CRC width:                   32 bits
// CRC shift direction:         right (little endian)
// Input word width:            8 bits

module crc32 (     input [31:0] crcIn,     input [7:0] data,     output [31:0] crcOut );
    wire [31:0] reflected_crcIn;     wire [7:0] reflected_data;     wire [31:0] next_crc;

    function [31:0] reflect32;         input [31:0] in;
        integer i;
        begin
            reflect32 = 32'b0;
            for (i = 0; i < 32; i = i + 1)
                reflect32[i] = in[31-i];
        end
    endfunction

    function [7:0] reflect8;         input [7:0] in;
        integer i;
        begin
            reflect8 = 8'b0;
            for (i = 0; i < 8; i = i + 1)
                reflect8[i] = in[7-i];
        end
    endfunction

    assign reflected_crcIn = reflect32(crcIn);     assign reflected_data = reflect8(data);
    assign next_crc[0] = reflected_crcIn[2] ^ reflected_crcIn[8] ^ reflected_data[2];
    assign next_crc[1] = reflected_crcIn[0] ^ reflected_crcIn[3] ^ reflected_crcIn[9] ^ reflected_data[0] ^ reflected_data[3];
    assign next_crc[2] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[4] ^ reflected_crcIn[10] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[4];
    assign next_crc[3] = reflected_crcIn[1] ^ reflected_crcIn[2] ^ reflected_crcIn[5] ^ reflected_crcIn[11] ^ reflected_data[1] ^ reflected_data[2] ^ reflected_data[5];
    assign next_crc[4] = reflected_crcIn[0] ^ reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[6] ^ reflected_crcIn[12] ^ reflected_data[0] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[6];
    assign next_crc[5] = reflected_crcIn[1] ^ reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[7] ^ reflected_crcIn[13] ^ reflected_data[1] ^ reflected_data[3] ^ reflected_data[4] ^ reflected_data[7];
    assign next_crc[6] = reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[14] ^ reflected_data[4] ^ reflected_data[5];
    assign next_crc[7] = reflected_crcIn[0] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_crcIn[15] ^ reflected_data[0] ^ reflected_data[5] ^ reflected_data[6];
    assign next_crc[8] = reflected_crcIn[1] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_crcIn[16] ^ reflected_data[1] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[9] = reflected_crcIn[7] ^ reflected_crcIn[17] ^ reflected_data[7];
    assign next_crc[10] = reflected_crcIn[2] ^ reflected_crcIn[18] ^ reflected_data[2];
    assign next_crc[11] = reflected_crcIn[3] ^ reflected_crcIn[19] ^ reflected_data[3];
    assign next_crc[12] = reflected_crcIn[0] ^ reflected_crcIn[4] ^ reflected_crcIn[20] ^ reflected_data[0] ^ reflected_data[4];
    assign next_crc[13] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[5] ^ reflected_crcIn[21] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[5];
    assign next_crc[14] = reflected_crcIn[1] ^ reflected_crcIn[2] ^ reflected_crcIn[6] ^ reflected_crcIn[22] ^ reflected_data[1] ^ reflected_data[2] ^ reflected_data[6];
    assign next_crc[15] = reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[7] ^ reflected_crcIn[23] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[7];
    assign next_crc[16] = reflected_crcIn[0] ^ reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[24] ^ reflected_data[0] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[4];
    assign next_crc[17] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[25] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[3] ^ reflected_data[4] ^ reflected_data[5];
    assign next_crc[18] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[2] ^ reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_crcIn[26] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[2] ^ reflected_data[4] ^ reflected_data[5] ^ reflected_data[6];
    assign next_crc[19] = reflected_crcIn[1] ^ reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_crcIn[27] ^ reflected_data[1] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[5] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[20] = reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_crcIn[28] ^ reflected_data[3] ^ reflected_data[4] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[21] = reflected_crcIn[2] ^ reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[7] ^ reflected_crcIn[29] ^ reflected_data[2] ^ reflected_data[4] ^ reflected_data[5] ^ reflected_data[7];
    assign next_crc[22] = reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_crcIn[30] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[5] ^ reflected_data[6];
    assign next_crc[23] = reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_crcIn[31] ^ reflected_data[3] ^ reflected_data[4] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[24] = reflected_crcIn[0] ^ reflected_crcIn[2] ^ reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[7] ^ reflected_data[0] ^ reflected_data[2] ^ reflected_data[4] ^ reflected_data[5] ^ reflected_data[7];
    assign next_crc[25] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[5] ^ reflected_data[6];
    assign next_crc[26] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[2] ^ reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[2] ^ reflected_data[3] ^ reflected_data[4] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[27] = reflected_crcIn[1] ^ reflected_crcIn[3] ^ reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[7] ^ reflected_data[1] ^ reflected_data[3] ^ reflected_data[4] ^ reflected_data[5] ^ reflected_data[7];
    assign next_crc[28] = reflected_crcIn[0] ^ reflected_crcIn[4] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_data[0] ^ reflected_data[4] ^ reflected_data[5] ^ reflected_data[6];
    assign next_crc[29] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[5] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[5] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[30] = reflected_crcIn[0] ^ reflected_crcIn[1] ^ reflected_crcIn[6] ^ reflected_crcIn[7] ^ reflected_data[0] ^ reflected_data[1] ^ reflected_data[6] ^ reflected_data[7];
    assign next_crc[31] = reflected_crcIn[1] ^ reflected_crcIn[7] ^ reflected_data[1] ^ reflected_data[7];
    assign crcOut = reflect32(next_crc);
endmodule
`endif // CRC_V_
