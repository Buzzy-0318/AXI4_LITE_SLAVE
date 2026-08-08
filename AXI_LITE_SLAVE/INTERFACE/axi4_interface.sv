`timescale 1ns/1ps

interface axi4_lite_if #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
);

    //==================================================
    // CLOCK & RESET
    //==================================================

    logic ACLK;
    logic ARESETn;


    //==================================================
    // WRITE ADDRESS CHANNEL
    // Master ? Slave : AWADDR, AWVALID
    // Slave  ? Master: AWREADY
    //==================================================

    logic [ADDR_WIDTH-1:0] AWADDR;
    logic                  AWVALID;
    logic                  AWREADY;


    //==================================================
    // WRITE DATA CHANNEL
    // Master ? Slave : WDATA, WSTRB, WVALID
    // Slave  ? Master: WREADY
    //==================================================

    logic [DATA_WIDTH-1:0]   WDATA;
    logic [DATA_WIDTH/8-1:0] WSTRB;
    logic                    WVALID;
    logic                    WREADY;


    //==================================================
    // WRITE RESPONSE CHANNEL
    // Slave  ? Master: BRESP, BVALID
    // Master ? Slave : BREADY
    //==================================================

    logic [1:0] BRESP;
    logic       BVALID;
    logic       BREADY;


    //==================================================
    // READ ADDRESS CHANNEL
    // Master ? Slave : ARADDR, ARVALID
    // Slave  ? Master: ARREADY
    //==================================================

    logic [ADDR_WIDTH-1:0] ARADDR;
    logic                  ARVALID;
    logic                  ARREADY;


    //==================================================
    // READ DATA CHANNEL
    // Slave  ? Master: RDATA, RRESP, RVALID
    // Master ? Slave : RREADY
    //==================================================

    logic [DATA_WIDTH-1:0] RDATA;
    logic [1:0]            RRESP;
    logic                  RVALID;
    logic                  RREADY;


    //==================================================
    // DRIVER MODPORT
    // Driver drives signals going INTO the DUT
    // Driver reads signals coming OUT of the DUT
    //==================================================

    modport DRIVER (
        input  ACLK,
        input  ARESETn,

        output AWADDR,
        output AWVALID,
        input  AWREADY,

        output WDATA,
        output WSTRB,
        output WVALID,
        input  WREADY,

        input  BRESP,
        input  BVALID,
        output BREADY,

        output ARADDR,
        output ARVALID,
        input  ARREADY,

        input  RDATA,
        input  RRESP,
        input  RVALID,
        output RREADY
    );


    //==================================================
    // MONITOR MODPORT
    // Monitor only observes the interface
    //==================================================

    modport MONITOR (
        input ACLK,
        input ARESETn,

        input AWADDR,
        input AWVALID,
        input AWREADY,

        input WDATA,
        input WSTRB,
        input WVALID,
        input WREADY,

        input BRESP,
        input BVALID,
        input BREADY,

        input ARADDR,
        input ARVALID,
        input ARREADY,

        input RDATA,
        input RRESP,
        input RVALID,
        input RREADY
    );


endinterface