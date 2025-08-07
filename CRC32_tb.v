`timescale 1ns / 1ps
module crc32_tb;
    reg [31:0] crcIn;     reg [7:0] data;  
    wire [31:0] crcOut;
    integer i, j, k;

    reg [7:0] byte_stream [0:100000];
    integer stream_length;

    reg [7:0] ethernet_frames [0:34][0:1513]; // До 35 фреймов, каждый до 1514 байт
    integer frame_lengths [0:34]; // Длины фреймов

    crc32 uut (         .crcIn(crcIn),         .data(data),         .crcOut(crcOut)     );
    integer num_frames;

    initial begin
        for (i = 0; i < 100000; i = i + 1) begin
            byte_stream[i] = 8'h00;
        end

        // Генерация случайного количества фреймов (от 10 до 35)
        num_frames = $urandom_range(10, 35);
        $display("Number of frames: %0d", num_frames);

        // Генерация случайного потока байтов
        stream_length = 0;
        for (j = 0; j < num_frames; j = j + 1) begin
            // Случайная длина payload от 46 до 1500 байт
            frame_lengths[j] = $urandom_range(46, 1500);

            // Преамбула (7 байт)
            for (i = 0; i < 7; i = i + 1) begin
                byte_stream[stream_length + i] = 8'h55;
            end
            stream_length = stream_length + 7;

            // SFD (Start Frame Delimiter, 1 байт)
            byte_stream[stream_length] = 8'hD5;
            stream_length = stream_length + 1;

            // Destination MAC Address (6 байт, случайный)
            for (i = 0; i < 6; i = i + 1) begin
                byte_stream[stream_length + i] = $urandom_range(0, 255);
            end
            stream_length = stream_length + 6;

            // Source MAC Address (6 байт, случайный)
            for (i = 0; i < 6; i = i + 1) begin
                byte_stream[stream_length + i] = $urandom_range(0, 255);
            end
            stream_length = stream_length + 6;

            // EtherType (2 байта, случайный: 0x0800 для IPv4, 0x0806 для ARP, 0x86DD для IPv6)
            case ($urandom_range(0, 2))
                0: begin
                    byte_stream[stream_length] = 8'h08;
                    byte_stream[stream_length + 1] = 8'h00; // IPv4
                end
                1: begin
                    byte_stream[stream_length] = 8'h08;
                    byte_stream[stream_length + 1] = 8'h06; // ARP
                end
                2: begin
                    byte_stream[stream_length] = 8'h86;
                    byte_stream[stream_length + 1] = 8'hDD; // IPv6
                end
            endcase
            stream_length = stream_length + 2;

            // Payload (случайные данные)
            for (i = 0; i < frame_lengths[j]; i = i + 1) begin
                byte_stream[stream_length + i] = $urandom_range(0, 255);
            end
            stream_length = stream_length + frame_lengths[j];

            // Interframe Gap (IFG, случайная задержка от 12 до 24 байт)
            for (i = 0; i < $urandom_range(12, 24); i = i + 1) begin
                byte_stream[stream_length + i] = 8'h00; // Заполнение нулями
            end
            stream_length = stream_length + $urandom_range(12, 24);
        end

        $display("Byte Stream (Length: %0d bytes):", stream_length);
        for (i = 0; i < stream_length; i = i + 1) begin
            $write("%02X ", byte_stream[i]);
            if ((i + 1) % 16 == 0) $write("\n"); 
        end
        $write("\n");

        i = 0; j = 0;
        while (i < stream_length) begin

            if (byte_stream[i] == 8'h55 && byte_stream[i+1] == 8'h55 && byte_stream[i+2] == 8'h55 &&
                byte_stream[i+3] == 8'h55 && byte_stream[i+4] == 8'h55 && byte_stream[i+5] == 8'h55 &&
                byte_stream[i+6] == 8'h55 && byte_stream[i+7] == 8'hD5) begin
                
                i = i + 8; 

                k = 0;
                while (i < stream_length && !(byte_stream[i] == 8'h55 && byte_stream[i+1] == 8'h55 && 
                       byte_stream[i+2] == 8'h55 && byte_stream[i+3] == 8'h55 && 
                       byte_stream[i+4] == 8'h55 && byte_stream[i+5] == 8'h55 && 
                       byte_stream[i+6] == 8'h55 && byte_stream[i+7] == 8'hD5)) begin
                    ethernet_frames[j][k] = byte_stream[i];
                    i = i + 1;
                    k = k + 1;
                end

                $display("\nFrame %0d (Length: %0d bytes):", j, k);
                for (k = 0; k < frame_lengths[j] + 14; k = k + 1) begin
                    $write("%02X ", ethernet_frames[j][k]);
                    if ((k + 1) % 16 == 0) $write("\n"); 
                end
                $write("\n");

                crcIn = 32'hFFFFFFFF;                  data = 8'h00;

                for (k = 0; k < frame_lengths[j] + 14; k = k + 1) begin
                    data = ethernet_frames[j][k];
                    #10;
                    crcIn = crcOut;
                end
                $display("Final Calculated CRC32 for Frame %0d: %08X", j, crcOut);
                j = j + 1;
            end else begin
                i = i + 1;
            end
        end
        $finish;
    end
endmodule
