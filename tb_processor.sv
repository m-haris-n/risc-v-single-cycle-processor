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
            #5 clk = 1;
            #5 clk = 0;
            // $display("pc_in: %b", dut.pc_in);
            $display("pc_d: %b", dut.selected_pc);
            $display("instW: %b", dut.inst_W);
            $display("instM: %b", dut.inst_M);
            $display("instE: %b", dut.inst_E);
            $display("instD: %b", dut.inst_d);
            $display("instF: %b", dut.inst_f);


            $display("oprA:%b", dut.alu_i.opr_a);
		    $display("oprB:%b", dut.alu_i.opr_b);
		    $display("alu_out:%b", dut.alu_out_W);
		    $display("wdata:%b", dut.reg_file_i.wdata);
		    $display("waddr:%b", dut.reg_file_i.waddr);
		    $display("datamem:%b %b %b %b", dut.data_mem_i.data_mem[0], dut.data_mem_i.data_mem[1], dut.data_mem_i.data_mem[2], dut.data_mem_i.data_mem[3]);

		    $display("datamemoutW:%b", dut.data_mem_out_W);
		    $display("wb_selected:%b", dut.sel_wb_W);
		    $display("");
            $display("pc_sel_br:%b", dut.br_taken);
		    $display("pc_sel_j:%b\n", dut.jump_E);
        end
    end

    // reset generator
    initial
    begin
        rst = 1;
        #10;
        rst = 0;
        #200;
		$display("datamem:%b\n", dut.data_mem_i.data_mem[0]);
        $display("Processor is running");
        $display("x1: %b", dut.reg_file_i.reg_mem[1]);
        $display("x2: %b", dut.reg_file_i.reg_mem[2]);
        $display("x3: %b", dut.reg_file_i.reg_mem[3]);
        $display("x4: %b", dut.reg_file_i.reg_mem[4]);
        // $display("loaded in x4: %b", dut.reg_file_i.reg_mem[4]);
        // $display("JAL return address x5: %b", dut.reg_file_i.reg_mem[5]);
        // $display("loaded UI in x6: %b", dut.reg_file_i.reg_mem[6]);
        // $display("loaded UI+PC in x7: %b", dut.reg_file_i.reg_mem[7]);
        $finish;
    end

    // initialize memory
    initial
    begin
        $readmemh("inst.mem", dut.inst_mem_i.mem);
        $readmemb("rf.mem", dut.reg_file_i.reg_mem);
    end

    // dumping the waveform
    initial
    begin
        $dumpfile("processor.vcd");
        $dumpvars(0, dut);
    end

endmodule