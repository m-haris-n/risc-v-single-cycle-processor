module BUFFER_DE (
    input logic clk, rst, sel_a_D, sel_b_D, wr_en_D, rd_en_D, jump_D,
    input logic [1:0] sel_wb_D,
    input logic [2:0] mem_mode_D, br_type_D,
    input logic [31:0] pc_D, rdata1_D, rdata2_D, imm_D, inst_D,

    output logic [31:0] pc_E, rdata1_E, rdata2_E, imm_E, inst_E,
    output logic sel_a_E, sel_b_E, wr_en_E, rd_en_E, jump_E,
    output logic [1:0] sel_wb_E,
    output logic [2:0] mem_mode_E, br_type_E


);

always_ff @( posedge clk, posedge rst )
begin
    if (rst) begin

        pc_E <= 32'b0;
        rdata1_E <= 32'b0;
        rdata2_E <= 32'b0;
        imm_E <= 32'b0;
        inst_E <= 32'b0;

        sel_a_E <= 0;
        sel_b_E <= 0;
        wr_en_E <= 0;
        rd_en_E <= 0;
        jump_E <= 0;

        sel_wb_E <= 2'b0;

        mem_mode_E <= 3'b0;
        br_type_E <= 3'b0;


    end else begin

        pc_E <= pc_D;
        rdata1_E <= rdata1_D;
        rdata2_E <= rdata2_D;
        imm_E <= imm_D;
        inst_E <= inst_D;

        sel_a_E <= sel_a_D;
        sel_b_E <= sel_b_D;
        wr_en_E <= wr_en_D;
        rd_en_E <= rd_en_D;
        jump_E <= jump_D;

        sel_wb_E <= sel_wb_D;

        mem_mode_E <= mem_mode_D;
        br_type_E <= br_type_D;

    end

end

endmodule