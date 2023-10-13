module controller
(
    input  logic [6:0] opcode,
    input  logic [6:0] funct7,
    input  logic [2:0] funct3,
    output logic [3:0] aluop,
    output logic       rf_en,
    output logic       sel_b
);


    parameter RTYPE = 7'b0110011;
    parameter ITYPEALO = 7'b0010011; // I type Arithmetic Logic Ops
    parameter ITYPELOAD = 7'b0000011; // I type Arithmetic Logic Ops
    parameter ITYPEJALR = 7'b1101111; // I type JALR
    parameter STYPE = 7'b0100011; // I type JALR
    parameter BTYPE = 7'b1100011; // I type JALR
    parameter UTYPELUI = 7'b0110111; // I type JALR
    parameter UTYPEAUIPC = 7'b0010111; // I type JALR
    parameter JTYPE = 7'b0010111; // I type JALR


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
         RTYPE: //R-Type
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
                    3'b001: aluop = SLL; //Shift Left Logical
                    3'b010: aluop = SLT; //Set Less Than
                    3'b011: aluop = SLTU; //Set Less Than Unsigned
                    3'b100: aluop = XOR; //XOR
                    3'b101:
                    begin
                        case(funct7)
                            7'b0000000: aluop = SRL; //Shift Right Logical
                            7'b0100000: aluop = SRA; //Shift Right Arithmetic
                        endcase
                    end
                    3'b110: aluop = OR; //OR
                    3'b111: aluop = AND; //AND
                endcase
            end
            ITYPEALO: // I-type Arithmetic Logic Ops
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
            // ITYPELOAD: // I-type Load
            // begin
            //     case (funct3)
            //         3'b000: //load byte

            //         3'b001: //load half word

            //         3'b010: //load word

            //         3'b100: //load byte unsigned

            //         3'b101: //load half unsigned


            //         default:
            //     endcase
            // end

            // ITYPEJALR: //I-type (Jump And Link Return)
            // begin

            // end

            // STYPE: //S-type
            // begin
            //     case (funct3)

            //         3'b000: //store byte

            //         3'b001: //store halfword

            //         3'b010: //store word

            //         default:
            //     endcase
            // end
            // BTYPE: //B-type
            // begin
            //     case (funct3)
            //         3'b000: // ==

            //         3'b001: // !=

            //         3'b100: // <

            //         3'b101: // >=

            //         3'b110: // < (unsigned)

            //         3'b111: // >= (unsigned)


            //         default:
            //     endcase
            // end

            // UTYPELUI: //U-type (Load Upper Immediate)
            // begin

            // end

            // UTYPEAUIPC: //U-type (Add Upper Immediate to Program Counter)
            // begin

            // end

            // JTYPE: //J-type (Jump And Link)
            // begin

            // end

            default:
            begin
                rf_en = 1'b0;
                sel_b = 1'b0;
            end
        endcase
    end

endmodule