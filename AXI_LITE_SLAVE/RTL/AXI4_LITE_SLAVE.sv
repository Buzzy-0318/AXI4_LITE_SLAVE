`timescale 1ns/1ps
module axi4_lite_slave #( 
     parameter ADDR_WIDTH = 32,
     parameter DATA_WIDTH = 32 )(

  input logic ACLK,
  input logic ARESETn,

//write addr

input logic [DATA_WIDTH-1:0] AWADDR,
input logic AWVALID,
output logic AWREADY,

//WRITE DATA......//////

input logic [DATA_WIDTH -1:0] WDATA,
input logic [DATA_WIDTH/8 - 1:0] WSTRB,
input logic WVALID,
output logic WREADY,

//////WRITE RESPONSE 

input logic BREADY,
output logic BVALID ,
output logic [1:0] BRESP,


/////READ ADDRESS 

input logic [DATA_WIDTH -1 :0] ARADDR,
input logic ARVALID,
output logic ARREADY,

/////// READ DATA 



output logic [DATA_WIDTH -1 :0] RDATA,
input  logic RREADY,
output logic [1:0] RRESP,
output logic RVALID

);


// addresss reg for storing addr

logic [DATA_WIDTH-1 :0] araddr_reg;
logic [DATA_WIDTH-1 :0] awaddr_reg;


/// STORING ADDREG WITH CLK \



always_ff @(posedge ACLK or negedge ARESETn)
begin
 if(!ARESETn)
     begin
         awaddr_reg <= 0;
      end
else
   begin
        if(AWREADY && AWVALID)
           begin
             awaddr_reg <= AWADDR;
            end

      end
end

// WRITE AND STRB REG FOR STORING THE DATA FOR LATER USE 


logic [DATA_WIDTH-1:0] wdata_reg;
logic [DATA_WIDTH/8  - 1 :0] wstrb_reg;


always_ff @(posedge ACLK or negedge ARESETn)

begin
          if(!ARESETn)
               begin
                 wdata_reg <= 0;
                 wstrb_reg <= 0;
                end
           else
               begin
                    if( WREADY && WVALID)
                      begin
                       wdata_reg <= WDATA;
                       wstrb_reg <= WSTRB;
                      end
               end

end
//========================================
// Internal Registers
//========================================
logic [DATA_WIDTH-1:0] reg0;
logic [DATA_WIDTH-1:0] reg1;
logic [DATA_WIDTH-1:0] reg2;
logic [DATA_WIDTH-1:0] reg3;

//==================================================
// WRITE FSM
//==================================================

typedef enum logic [1:0] {
    WR_IDLE,
    WR_WAIT_ADDR,
    WR_WAIT_DATA,
    WR_RESP
} wr_state_t;

wr_state_t wr_state;


//==================================================
// WRITE READY SIGNALS
//==================================================

assign AWREADY = (wr_state == WR_IDLE) ||
                 (wr_state == WR_WAIT_DATA);

assign WREADY  = (wr_state == WR_IDLE) ||
                 (wr_state == WR_WAIT_ADDR);


//==================================================
// WRITE FSM
//==================================================

always_ff @(posedge ACLK or negedge ARESETn)
begin

    if (!ARESETn)
    begin
        wr_state   <= WR_IDLE;

        awaddr_reg <= '0;
        wdata_reg  <= '0;
        wstrb_reg  <= '0;

        BVALID     <= 1'b0;
        BRESP      <= 2'b00;

        reg0       <= '0;
        reg1       <= '0;
        reg2       <= '0;
        reg3       <= '0;
    end

    else
    begin

        case (wr_state)

            //======================================
            // IDLE
            //======================================

            WR_IDLE:
            begin

                BVALID <= 1'b0;

                // Both arrive together
                if (AWVALID && AWREADY &&
                    WVALID  && WREADY)
                begin
                    awaddr_reg <= AWADDR;
                    wdata_reg  <= WDATA;
                    wstrb_reg  <= WSTRB;

                    wr_state <= WR_RESP;
                end

                // Only address arrives
                else if (AWVALID && AWREADY)
                begin
                    awaddr_reg <= AWADDR;

                    wr_state <= WR_WAIT_DATA;
                end

                // Only data arrives
                else if (WVALID && WREADY)
                begin
                    wdata_reg <= WDATA;
                    wstrb_reg <= WSTRB;

                    wr_state <= WR_WAIT_ADDR;
                end

            end


            //======================================
            // WAITING FOR DATA
            // Address already received
            //======================================

            WR_WAIT_DATA:
            begin

                if (WVALID && WREADY)
                begin
                    wdata_reg <= WDATA;
                    wstrb_reg <= WSTRB;

                    wr_state <= WR_RESP;
                end

            end


            //======================================
            // WAITING FOR ADDRESS
            // Data already received
            //======================================

            WR_WAIT_ADDR:
            begin

                if (AWVALID && AWREADY)
                begin
                    awaddr_reg <= AWADDR;

                    wr_state <= WR_RESP;
                end

            end


            //======================================
            // WRITE RESPONSE
            //======================================

            WR_RESP:
            begin

                // Perform register write
                case (awaddr_reg)

                    //--------------------------------
                    // REG0
                    //--------------------------------

                    32'h00000000:
                    begin

                        if (wstrb_reg[0])
                            reg0[7:0] <= wdata_reg[7:0];

                        if (wstrb_reg[1])
                            reg0[15:8] <= wdata_reg[15:8];

                        if (wstrb_reg[2])
                            reg0[23:16] <= wdata_reg[23:16];

                        if (wstrb_reg[3])
                            reg0[31:24] <= wdata_reg[31:24];

                        BRESP <= 2'b00;       // OKAY
                    end


                    //--------------------------------
                    // REG1
                    //--------------------------------

                    32'h00000004:
                    begin

                        if (wstrb_reg[0])
                            reg1[7:0] <= wdata_reg[7:0];

                        if (wstrb_reg[1])
                            reg1[15:8] <= wdata_reg[15:8];

                        if (wstrb_reg[2])
                            reg1[23:16] <= wdata_reg[23:16];

                        if (wstrb_reg[3])
                            reg1[31:24] <= wdata_reg[31:24];

                        BRESP <= 2'b00;
                    end


                    //--------------------------------
                    // REG2
                    //--------------------------------

                    32'h00000008:
                    begin

                        if (wstrb_reg[0])
                            reg2[7:0] <= wdata_reg[7:0];

                        if (wstrb_reg[1])
                            reg2[15:8] <= wdata_reg[15:8];

                        if (wstrb_reg[2])
                            reg2[23:16] <= wdata_reg[23:16];

                        if (wstrb_reg[3])
                            reg2[31:24] <= wdata_reg[31:24];

                        BRESP <= 2'b00;
                    end


                    //--------------------------------
                    // REG3
                    //--------------------------------

                    32'h0000000C:
                    begin

                        if (wstrb_reg[0])
                            reg3[7:0] <= wdata_reg[7:0];

                        if (wstrb_reg[1])
                            reg3[15:8] <= wdata_reg[15:8];

                        if (wstrb_reg[2])
                            reg3[23:16] <= wdata_reg[23:16];

                        if (wstrb_reg[3])
                            reg3[31:24] <= wdata_reg[31:24];

                        BRESP <= 2'b00;
                    end


                    //--------------------------------
                    // INVALID ADDRESS
                    //--------------------------------

                    default:
                    begin
                        BRESP <= 2'b10;       // SLVERR
                    end

                endcase

                BVALID <= 1'b1;

                // Master accepted response
                if (BREADY)
                begin
                    BVALID   <= 1'b0;
                    wr_state <= WR_IDLE;
                end

            end

        endcase

    end

end

typedef enum logic [1:0] {
    RD_IDLE,
    RD_RESP
} rd_state_t;

rd_state_t rd_state;

//========================================
// READ FSM
//========================================

always_ff @(posedge ACLK or negedge ARESETn)
begin

    if (!ARESETn)
    begin
        rd_state   <= RD_IDLE;

        araddr_reg <= '0;

        RDATA      <= '0;
        RRESP      <= 2'b00;
        RVALID     <= 1'b0;
    end

    else
    begin

        case (rd_state)

            //==================================
            // IDLE
            //==================================

            RD_IDLE:
            begin

                RVALID <= 1'b0;

                if (ARVALID && ARREADY)
                begin

                    araddr_reg <= ARADDR;

                    case (ARADDR)

                        32'h00000000:
                        begin
                            RDATA <= reg0;
                            RRESP <= 2'b00;       // OKAY
                        end

                        32'h00000004:
                        begin
                            RDATA <= reg1;
                            RRESP <= 2'b00;
                        end

                        32'h00000008:
                        begin
                            RDATA <= reg2;
                            RRESP <= 2'b00;
                        end

                        32'h0000000C:
                        begin
                            RDATA <= reg3;
                            RRESP <= 2'b00;
                        end

                        // Invalid address
                        default:
                        begin
                            RDATA <= '0;
                            RRESP <= 2'b10;       // SLVERR
                        end

                    endcase

                    RVALID   <= 1'b1;
                    rd_state <= RD_RESP;

                end

            end


            //==================================
            // RESPONSE
            //==================================

            RD_RESP:
            begin

                // Keep RDATA/RRESP/RVALID stable
                // until master accepts the response

                if (RVALID && RREADY)
                begin

                    RVALID   <= 1'b0;
                    rd_state <= RD_IDLE;

                end

            end

        endcase

    end

end

endmodule
