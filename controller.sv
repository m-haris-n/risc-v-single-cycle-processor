module controller
(
    input  logic [6:0] opcode,
    input  logic [6:0] funct7,
    input  logic [2:0] funct3,
    output logic [3:0] aluop,
    output logic       rf_en,
    output logic       sel_b
);

    // ALU OPS
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter SLL = 4'b0010;
    parameter SLT = 4'b0011;
    parameter SLTU = 4'b0100;
    parameter XOR = 4'b0101;
    parameter SRL = 4'b0110;
    parameter SRA = 4'b0111;
    parameter OR = 4'b1000;
    parameter AND = 4'b1001;
    parameter NULL = 4'b1010;

    always_comb
    begin
        case(opcode)
            7'b0110011: //R-Type
            begin
                rf_en = 1'b1;
                sel_b = 1'b0;
                case(funct3)
                    3'b000:
                    begin
                        case(funct7)
                            7'b0000000: aluop = ADD; //ADD
                            7'b0100000: aluop = SUB; //SUB
                        endcase
                    end
                    3'b001: aluop = SLL; //SLL
                    3'b010: aluop = SLT; //SLT
                    3'b011: aluop = SLTU; //SLTU
                    3'b100: aluop = XOR; //XOR
                    3'b101:
                    begin
                        case(funct7)
                            7'b0000000: aluop = SRL; //SRL
                            7'b0100000: aluop = SRA; //SRA
                        endcase
                    end
                    3'b110: aluop = OR; //OR
                    3'b111: aluop = AND; //AND
                endcase
            end
            7'b0010011: // I-type
            begin
                rf_en = 1'b1;
                sel_b = 1'b1;
                case (funct3)
                3'b000: aluop = ADD; //ADDI
                3'b010: aluop = SLT; //SLTI
                3'b011: aluop = SLTU; //SLTIU
                3'b100: aluop = XOR; //XORI
                3'b110: aluop = OR; //ORI
                3'b111: aluop = AND; //ANDI
                3'b001: aluop = SLL; //SLLI
                3'b101:
                begin
                    case (funct7)
                    7'b0000000: aluop = SRL; //SRLI
                    7'b0100000: aluop = SRL; //SRAI
                    endcase
                end
                endcase
            end
            default:
            begin
                rf_en = 1'b0;
                sel_b = 1'b0;
            end
        endcase
    end

endmodule