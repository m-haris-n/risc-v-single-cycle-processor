module imm_gen
(
    input  logic [11:0] imm,
    input  logic [ 2:0] funct3,
    output logic imm_val
);

    always_comb
    begin
        case (funct3)
            3'b011: imm_val = {20'b0,imm}
            3'b101: imm_val = {{27{imm[4]}},imm[4:0]}
            // if (imm[4] == 1'b1)
            // begin
            //     imm_val = {{27{imm[4]}},imm[4:0]}
            // end
            // else
            // begin
            //     imm_val = {27'b0,imm[4:0]}
            // end

            default: 
            begin
                3'b101: imm_val = {{20{imm[4]}},imm[4:0]}
            end
            // begin
            //     if (imm[11] == 1'b1)
            //     begin
            //         imm_val = {20'b1,imm}
            //     end
            //     else
            //     begin
            //         imm_val = {20'b0,imm}
            //     end
            // end
        endcase
    end
    
endmodule
