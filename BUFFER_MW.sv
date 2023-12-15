module BUFFER_MW (

    input logic clk, rst,
    input logic [1:0]sel_wb_M,
    input logic rf_en_M,
    input logic [31:0] inst_M, pc_M, alu_out_M, out_data_M,
    output logic [1:0] sel_wb_W,
    output logic rf_en_W,
    output logic [31:0] inst_W, pc_W, alu_out_W, out_data_W,
    output logic [4:0] rd_W
);

always_ff @( posedge clk, posedge rst )
begin
    if (rst) begin

        inst_W <= 32'b0;
        pc_W <= 32'b0;
        alu_out_W <= 32'b0;
        out_data_W <= 32'b0;
        sel_wb_W = 2'b0;
        rf_en_W = 0;
        rd_W = 5'b0;

    end else begin
        inst_W <= inst_M;
        pc_W <= pc_M;
        alu_out_W <= alu_out_M;
        out_data_W <= out_data_M;
        sel_wb_W = sel_wb_M;
        rf_en_W = rf_en_M;
        rd_W <= inst_M[11: 7];
    end

end

endmodule