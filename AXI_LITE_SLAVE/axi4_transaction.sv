class axi4_lite_transaction ;


// Transaction Type
    //==================================================

    typedef enum {
        WRITE,
        READ
    } trans_type_t;

    trans_type_t trans_type;




 rand bit[31:0] addr;
 rand bit[31:0] data;
 rand bit [3:0] strb;
rand bit[1:0] resp;

rand bit[ 31:0] rdata;

  // Constructor
    //==================================================

    function new();

        trans_type = WRITE;

        addr = 32'h0;
        data = 32'h0;
        strb = 4'hF;

        resp  = 2'b00;
        rdata = 32'h0;

    endfunction

 //==================================================
    // Display Transaction
    //==================================================

    function void display(string name = "TRANSACTION");

        $display("--------------------------------------------");
        $display("[%s]", name);

        if (trans_type == WRITE)
            $display("TYPE  = WRITE");
        else
            $display("TYPE  = READ");

        $display("ADDR  = 0x%08h", addr);
        $display("DATA  = 0x%08h", data);
        $display("STRB  = %04b", strb);
        $display("RDATA = 0x%08h", rdata);
        $display("RESP  = %02b", resp);

        $display("--------------------------------------------");

    endfunction

endclass
