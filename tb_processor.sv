module tb_processor();

    // add x3, x4, x2
    // 00000000001000100000000110110011

    logic clk;
    logic rst;

    processor dut
    (
        .clk ( clk ),
        .rst ( rst )
    );

    // clock generator
    initial
    begin
        clk = 0;
        forever
        begin
            #5 clk = ~clk;
        end
    end

    // reset generator
    initial
    begin
        rst = 1;
        #10;
        rst = 0;
        $display("inst0: %b", dut.inst_mem_i.mem[0]);
        $display("inst1: %b", dut.inst_mem_i.mem[1]);
        $display("inst2: %b", dut.inst_mem_i.mem[2]);
        $display("pc: %b", dut.pc_out);
        #5
        $display("pc+4: %b", dut.pc_out);
        #5
        $display("pc+8: %b", dut.pc_out);
        #5
        $display("pc+8: %b", dut.pc_out);

        #1000;
        $display("Processor is running");
        $display("x1: %b", dut.reg_file_i.reg_mem[1]);
        $display("x2: %b", dut.reg_file_i.reg_mem[2]);
        $display("x1+x2-> x3: %b", dut.reg_file_i.reg_mem[3]);
        $finish;
    end

    // initialize memory
    initial
    begin
        $readmemb("inst.mem", dut.inst_mem_i.mem);
        $readmemb("rf.mem", dut.reg_file_i.reg_mem);
    end

    // dumping the waveform
    initial
    begin
        $dumpfile("processor.vcd");
        $dumpvars(0, dut);
    end

endmodule