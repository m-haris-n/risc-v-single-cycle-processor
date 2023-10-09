module imm_gen
(
    input  logic [11:0] imm,
    input  logic [ 2:0] funct3,
    output logic imm_val
);

    always_comb
    begin
        case (funct3)
            3'b011:
                imm_val = {20'b0,imm};
            3'b101:
                imm_val = {{27{imm[4]}},imm[4:0]};


            default:
            begin
                imm_val = {{20{imm[4]}},imm[4:0]};
            end

        endcase
    end

endmodule
