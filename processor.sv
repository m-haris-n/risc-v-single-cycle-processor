module processor
(
    input logic clk,
    input logic rst
);
    // wires
    logic        rf_en;
    logic        sel_a;
    logic        sel_b;
    logic [1:0]  sel_wb;
    logic        rd_en;
    logic        wr_en;

    logic         csr_wr;
    logic         csr_rd;
    logic         t_intr;
    logic         e_intr;
    logic         is_mret;
    logic         intr_flag;
    logic         csr_op_sel;

    logic [31:0] pc_in;
    logic [31:0] pc_out;
    logic [31:0] epc;
    logic [31:0] selected_pc;
    logic [31:0] inst;
    logic [ 4:0] rd;
    logic [ 4:0] rs1;
    logic [ 4:0] rs2;
    logic [ 6:0] opcode;
    logic [ 2:0] funct3;
    logic [ 6:0] funct7;
    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] opr_a;
    logic [31:0] opr_b;
    logic [31:0] imm;
    logic [31:0] wdata;
    logic [31:0] alu_out;
    logic [31:0] data_mem_out;
    logic [31:0] csr_data_out;

    logic [3 :0] aluop;
    logic [2:0] mem_mode;
    logic [2:0] br_type;
    logic br_taken;
    logic jump;

    // program counter
    pc pc_i
    (
        .clk(clk),
        .rst(rst),
        .pc_in(selected_pc),
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
        .rd_en(rd_en),
        .wr_en(wr_en),
        .addr(alu_out),
        .wdata(rdata2),
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
        .sel_a(sel_a),
        .sel_b(sel_b),
        .sel_wb(sel_wb),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .mem_mode(mem_mode),
        .br_type(br_type),
        .jump(jump),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_mret(is_mret),
        .csr_op_sel(csr_op_sel)

    );

    // alu
    alu alu_i
    (
        .aluop(aluop),
        .opr_a(opr_a),
        .opr_b(opr_b),
        .opr_res(alu_out)
    );


    //branch comparator
    branch_cond branch_cond_i
    (
        .rdata1(rdata1),
        .rdata2(rdata2),
        .br_type(br_type),
        .br_taken(br_taken)
    );


    //csr
    csr_reg csr_reg_i
    (
        .clk(clk),
        .rst(rst),
        .pc_input(pc_in),
        .addr(alu_out),
        .wdata(csr_op),
        .inst(inst),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .t_intr(t_intr),
        .e_intr(e_intr),
        .is_mret(is_mret),
        .rdata(csr_data_out),
        .epc(epc),
        .intr_flag(intr_flag)
    );

    //ALL MUX

    //sel_a_mux
    mux_2x1 sel_a_mux
    (
        .sel(sel_a),
        .input_a(rdata1),
        .input_b(pc_out),
        .out_y(opr_a)
    );

    //sel_b_mux for I-type
    mux_2x1 sel_b_mux
    (
        .sel(sel_b),
        .input_a(rdata2),
        .input_b(imm),
        .out_y(opr_b)
    );

    //csr operand selection mux
    mux_2x1 sel_csr_op
    (
        .sel(csr_op_sel),
        .input_a(rdata1),
        .input_b(imm),
        .out_y(csr_op)
    );

    //write back selection for load instructions
    mux_4x1 sel_wb_mux
    (
        .sel(sel_wb),
        .input_a(alu_out),
        .input_b(data_mem_out),
        .input_c(pc_out+4),
        .input_d(csr_data_out),
        .out_y(wdata)
    );

    mux_2x1 pc_sel_mux
    (
        .sel(br_taken | jump),
        .input_a(pc_out + 32'd4),
        .input_b(alu_out),
        .out_y(pc_in)
    );

    mux_2x1 pc_final_sel
    (
        .sel(intr_flag),
        .input_a(pc_in),
        .input_b(epc),
        .out_y(selected_pc)
    );

endmodule