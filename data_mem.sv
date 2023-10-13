module data_mem (
    input logic wr_en,
    input logic rd_en,
    input logic [31:0] addr,
    input logic [7:0] byte_input,
    input logic [15:0] halfword_input,
    input logic [31:0] word_input,
    input logic [63:0] doubleword_input,
    output logic [31:0] out_data
);

    logic [31:0] datamem [100];

    always_comb
    begin
        // case(wr_en)

        // 0:
        //     case(rd_en)
        //     0:
        //         out_data = datamem[addr] //zero extension
        //     1:
        //         out_data = datamem[addr] // sign extension
        //     endcase
        // 1:

        // endcase
    end


endmodule