`timescale 1ns/1ps
module tb_top;

    import axi4_pkg::*;

    //==================================================
    // Interface
    //==================================================

    axi4_lite_if axi_if();


    //==================================================
    // Clock Generation
    //==================================================

    initial begin

        axi_if.ACLK = 1'b0;

        forever #5 axi_if.ACLK = ~axi_if.ACLK;

    end


    //==================================================
    // Reset Generation
    //==================================================

    initial begin

        axi_if.ARESETn = 1'b0;

        #20;

        axi_if.ARESETn = 1'b1;

    end


    //==================================================
    // DUT
    //==================================================

    axi4_lite_slave dut (

        .ACLK    (axi_if.ACLK),
        .ARESETn (axi_if.ARESETn),

        .AWADDR  (axi_if.AWADDR),
        .AWVALID (axi_if.AWVALID),
        .AWREADY (axi_if.AWREADY),

        .WDATA   (axi_if.WDATA),
        .WSTRB   (axi_if.WSTRB),
        .WVALID  (axi_if.WVALID),
        .WREADY  (axi_if.WREADY),

        .BREADY  (axi_if.BREADY),
        .BVALID  (axi_if.BVALID),
        .BRESP   (axi_if.BRESP),

        .ARADDR  (axi_if.ARADDR),
        .ARVALID (axi_if.ARVALID),
        .ARREADY (axi_if.ARREADY),

        .RDATA   (axi_if.RDATA),
        .RREADY  (axi_if.RREADY),
        .RRESP   (axi_if.RRESP),
        .RVALID  (axi_if.RVALID)

    );

    //==================================================
    // Test
    //==================================================

    axi4_lite_test test;

    initial begin

        test = new(axi_if);

        wait(axi_if.ARESETn == 1'b1);

        test.run();

        #100;

        $finish;

    end

endmodule
