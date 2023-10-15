module processor
(
    input logic clk,
    input logic rst
);
    // wires
    logic        rf_en;
    logic        sel_b;
    logic        sel_wb;
    logic        rd_en;
    logic        wr_en;
    logic [31:0] pc_out;
    logic [31:0] inst;
    logic [ 4:0] rd;
    logic [ 4:0] rs1;
    logic [ 4:0] rs2;
    logic [ 6:0] opcode;
    logic [ 2:0] funct3;
    logic [ 6:0] funct7;
    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] opr_b;
    logic [31:0] imm;
    logic [31:0] wdata;
    logic [31:0] alu_out;
    logic [31:0] data_mem_out;
    logic [3 :0] aluop;
    logic [2:0] mem_mode;

    // program counter
    pc pc_i
    (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_out + 32'd4),
        .pc_out(pc_out)
    );

    // instruction memory
    inst_mem inst_mem_i
    (
        .addr(pc_out),
        .data(inst)
    );

    data_mem data_mem_i
    (
        .clk(clk),
        .addr(alu_out),
        .mem_mode(mem_mode),
        .out_data(data_mem_out)
    );

    // instruction decoder
    inst_dec inst_dec_i
    (
        .inst(inst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7)
    );

    //immediate generator
    imm_gen imm_gen_i
    (
        .inst(inst),
        .imm(imm)
    );

    // register file
    reg_file reg_file_i
    (
        .clk(clk),
        .rf_en(rf_en),
        .waddr(rd),
        .rs1(rs1),
        .rs2(rs2),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .wdata(wdata)
    );



    // controller
    controller controller_i
    (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .aluop(aluop),
        .rf_en(rf_en),
        .sel_b(sel_b),
        .sel_wb(sel_wb),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .mem_mode(mem_mode)
    );

    // alu
    alu alu_i
    (
        .aluop(aluop),
        .opr_a(rdata1),
        .opr_b(opr_b),
        .opr_res(alu_out)
    );


    //ALL MUX

    //sel_b_mux for I-type
    mux_2x1 sel_b_mux
    (
        .sel(sel_b),
        .input_a(rdata2),
        .input_b(imm),
        .out_y(opr_b)
    );

    //write back selection for load instructions
    mux_2x1 wdata_sel_mux
    (
        .sel(sel_wb),
        .input_a(alu_out),
        .input_b(data_mem_out),
        .out_y(wdata)
    );

endmodule