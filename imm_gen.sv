module imm_gen
(
    input  logic [11:0] imm,
    input  logic [ 6:0] opcode,
    output logic [31:0] imm_val
);



    parameter ITYPEALO = 7'b0010011; // I type Arithmetic Logic Ops

    always_comb
    begin
        case (opcode)
            ITYPEALO:
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
