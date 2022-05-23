`timescale 1 ns / 1 ps
`include "defines.vh"

module out_of_band (
    input   wire            clk,                  // Clock
    input   wire            reset,                // reset
    input   wire            rx_locked,            // GTX PLL is locked
        
    input   wire [31:0]     tx_datain,            // Incoming TX data
    input   wire            tx_chariskin,         // Incoming tx is k char
    output  wire [31:0]     tx_dataout,           // Outgoing TX data 
    output  wire            tx_charisk_out,       // TX byted is K character
                           
    input   wire [3:0]      rx_charisk,                             
    input   wire [31:0]     rx_datain,                
    output  wire [31:0]     rx_dataout, 
    output  wire [3:0]      rx_charisk_out,              

    input   wire  [1:0]     gen,                  // Generation speed 00 for sata1, 01 for sata2, 10 for sata3
    
    output  wire            rxreset,              // GTP PCS reset
    output  wire            txcominit,            // TX OOB COMRESET
    output  wire            txcomwake,            // TX OOB COMWAKE
    input   wire            cominitdet,           // RX OOB COMINIT
    input   wire            comwakedet,           // RX OOB COMWAKE
    input   wire            rxelecidle,           // RX electrical idle
    output  wire            txelecidle,           // TX electircal idel
    input   wire            rxbyteisaligned,      // RX byte alignment completed

    input   wire            gt0_rxresetdone_i,    // rx fsm reaet done
    input   wire            gt0_txresetdone_i,    // tx fsm reset done
    
    output  wire            linkup,               // SATA link is established
    output reg              gtx_rx_reset_out      // rx reset out
);
  
parameter [3:0]  
    HOST_COMRESET               = 4'h1,                                                        
    WAIT_DEV_COMINIT            = 4'h2,
    HOST_COMWAKE                = 4'h3,
    WAIT_DEV_COMWAKE            = 4'h4,
    WAIT_AFTER_COMWAKE_ONE      = 4'h5,
    WAIT_AFTER_COMWAKE_ONE_TWO  = 4'h6,
    HOST_D10_2                  = 4'h7,
    HOST_SEND_ALIGN             = 4'h8,
    CHECK_RX_MAN_RST            = 4'h9,
    CHECK_RX_MAN_RST_REL        = 4'hA,
    LINK_READY                  = 4'hB;

  
    (*mark_debug = "TRUE" *) reg [3:0]   CurrentState, NextState;                               
    reg [7:0]   count160;                                               
    reg [17:0]  count;                                                  
    reg [4:0]   count160_round;                                         
    reg [3:0]   align_char_cnt_reg;                                     
    reg         align_char_cnt_rst, align_char_cnt_inc;                 
    reg         count_en;                                               
    reg         send_d10_2_r, send_align_r;                             
    reg         tx_charisk_out;                                         
    reg         txelecidle_r;                                           
    reg         count160_done, count160_go;                             
    reg [1:0]   align_count;                                            
    (*mark_debug = "TRUE" *) reg         linkup_r;                                               
    reg         rxreset;                                                
    reg [31:0]  rx_datain_r1;
    reg [31:0]  tx_datain_r1, tx_datain_r2, tx_datain_r3, tx_datain_r4; // TX data registers
    reg [31:0]  tx_dataout;
    reg [31:0]  rx_dataout;
    reg [1:0]   rx_charisk_out;
    reg         txcominit_r,txcomwake_r;
    reg [7:0]   count_sync;       
    reg         sync_stable;
    reg [31:0]  rx_datain_r1_int;
    reg         cont_flag;
    reg         rx_charisk_r1_int;
    reg         rx_charisk_r1;
    reg [11:0]  rxreset_cnt;
    reg [11:0]  gtxreset_cnt; 
    reg         gtxreset_cnt_400;
  
    wire        align_det, sync_det;
    wire        comreset_done, dev_cominit_done, HOST_COMWAKE_done, dev_comwake_done;
    wire        sof_det, eof_det;
    wire        align_cnt_en;
    

    wire  [3:0] CurrentState_out;     // Current state for Chipscope
    wire        align_det_out;        // ALIGN primitive detected
    wire        sync_det_out;         // SYNC primitive detected
    wire        rx_sof_det_out;       // Start Of Frame primitive detected
    wire        rx_eof_det_out;       // End Of Frame primitive detected
        

always@(posedge clk or posedge reset) begin : Linkup_synchronisation
    if (reset) begin
        linkup <= 0;
    end
    else begin 
        linkup <= linkup_r;
    end
  end

always @ (CurrentState or count or cominitdet or comwakedet or rxelecidle or rx_locked or align_det or sync_det or gen 
          or gt0_txresetdone_i or gt0_rxresetdone_i or gtxreset_cnt_400) begin : SM_mux
    count_en          = 1'b0;
    NextState         = HOST_COMRESET;
    linkup_r          = 1'b0;
    txcominit_r       = 1'b0;
    txcomwake_r       = 1'b0;
    txelecidle_r      = 1'b1;
    send_d10_2_r      = 1'b0;
    send_align_r      = 1'b0;
    rxreset           = 1'b0; 
    gtx_rx_reset_out  = 1'b0;  
    
    case (CurrentState)
    
    HOST_COMRESET : begin
        if (rx_locked && gt0_txresetdone_i && gt0_rxresetdone_i) begin 
            if ((gen == 2'b10 && count == 18'h00144) || (gen == 2'b01 && count == 18'h000A2) || (gen == 2'b00 && count == 18'h00051)) begin
                txcominit_r = 1'b0; 
                NextState   = WAIT_DEV_COMINIT;
            end
            else begin
                txcominit_r = 1'b1; 
                count_en    = 1'b1;
                NextState   = HOST_COMRESET;            
            end
        end
        else begin
            txcominit_r = 1'b0; 
            NextState   = HOST_COMRESET;
        end                         
    end     
    
    WAIT_DEV_COMINIT : 
        begin
            if (cominitdet) begin
                NextState = HOST_COMWAKE;
            end
            else
            begin
                if(count == 18'h203AD) begin
                    count_en  = 1'b0;
                    NextState = HOST_COMRESET;
                end 
                else
                begin
                    count_en  = 1'b1;
                    NextState = WAIT_DEV_COMINIT;
                end
            end
        end
      
    HOST_COMWAKE : //2
      begin
        if ((gen == 2'b10 && count == 18'h00136) || (gen == 2'b01 && count == 18'h0009B) || (gen == 2'b00 && count == 18'h0004E))
        begin
          txcomwake_r = 1'b0; 
          NextState   = WAIT_DEV_COMWAKE;
        end
        else
        begin
          txcomwake_r = 1'b1; 
          count_en    = 1'b1;
          NextState   = HOST_COMWAKE;           
        end
      end
      
    WAIT_DEV_COMWAKE : //3 
      begin
        if (comwakedet) //device comwake detected       
        begin
          NextState = WAIT_AFTER_COMWAKE_ONE;
        end
        else
        begin
          if(count == 18'h203AD) //restart comreset after no cominit for 880us
          begin
            count_en  = 1'b0;
            NextState = HOST_COMRESET;
          end
          else
          begin
            count_en  = 1'b1;
            NextState = WAIT_DEV_COMWAKE;
          end
        end
      end
      
    WAIT_AFTER_COMWAKE_ONE : // 4
      begin
        if (count == 6'h3F)
        begin
          NextState = WAIT_AFTER_COMWAKE_ONE_TWO;
        end
        else
        begin
          count_en = 1'b1;
          
          NextState = WAIT_AFTER_COMWAKE_ONE;
        end
      end   
      
    WAIT_AFTER_COMWAKE_ONE_TWO : //5
      begin
        if (~rxelecidle)
        begin
          rxreset   = 1'b1;
          NextState = HOST_D10_2; //gtx_resetdone_check_0  
        end
        else
          NextState = WAIT_AFTER_COMWAKE_ONE_TWO;  
      end

    HOST_D10_2 : //6
    begin
      send_d10_2_r = 1'b1;
      txelecidle_r = 1'b0;
      if (align_det)
      begin
        send_d10_2_r = 1'b0;
        NextState    = HOST_SEND_ALIGN;
      end
      else
      begin
        if(count == 18'h203AD) // restart comreset after 880us
        begin
          count_en  = 1'b0;
          NextState = HOST_COMRESET;            
        end
        else
        begin
          count_en  = 1'b1;
          NextState = HOST_D10_2;
        end
      end       
    end
    
    HOST_SEND_ALIGN : begin
        send_align_r = 1'b1;
        txelecidle_r = 1'b0;
        if (sync_det) begin
            send_align_r = 1'b0;
            gtx_rx_reset_out = 1'b1;
            NextState    = LINK_READY; //CHECK_RX_MAN_RST; 
        end
        else
            NextState = HOST_SEND_ALIGN;
    end
   
    LINK_READY : // 8
    begin
      txelecidle_r = 1'b0;
      gtx_rx_reset_out = 1'b0;
      if (sync_stable) //rxelecidle
      begin
        NextState = LINK_READY;
        linkup_r  = 1'b1;
      end
      else
      begin
        NextState        = LINK_READY; //LINK_READY2;
        linkup_r         = 1'b0;
      end
    end
   
    default : NextState = HOST_COMRESET;  
    
  endcase
end 

always@(posedge clk or posedge reset) begin : GTX_RESET_CNT
    if (reset) begin
        gtxreset_cnt      = 12'b0;
        gtxreset_cnt_400  = 1'b0;
    end  
    else if(gtxreset_cnt > 12'h 400) begin
        gtxreset_cnt_400  = 1'b1;
    end  
    else if(gtx_rx_reset_out) begin
        gtxreset_cnt      = gtxreset_cnt + 1'b1;
        gtxreset_cnt_400  = 1'b0;
    end
    else begin
        gtxreset_cnt      = gtxreset_cnt;
        gtxreset_cnt_400  = gtxreset_cnt_400;
  end
end

always@(posedge clk or posedge reset) begin : SEQ
    if (reset)
        CurrentState = HOST_COMRESET;
    else
        CurrentState = NextState;
end

always@(posedge clk or posedge reset) begin : count_sync_primitve
    if (reset) begin
        count_sync  <= 8'b0;
        sync_stable <= 1'b0;
    end 
    else if(count_sync > 8'h32) begin  //8'd50
        sync_stable <= 1'b1;
    end
    else if ((rx_datain_r1_int == `SYNC) && rx_charisk_r1_int) begin //|| rx_datain_r1_int == `ALIGN || rx_datain_r1_int == `X_RDY
        count_sync  <= count_sync + 1'b1;
        sync_stable <= sync_stable;
    end 
    else begin
        count_sync  <= 8'b0;
        sync_stable <= 1'b0;
    end
end

always @(posedge clk, posedge reset) begin                                                                                   
    if (reset) begin       
        rx_datain_r1_int     <= 32'b0;
        cont_flag            <= 1'b0; 
        rx_charisk_r1_int    <= 1'b0;      
    end
    else begin 
        if ((rx_datain_r1 == `CONT) && rx_charisk_r1) begin
            rx_datain_r1_int  <= rx_datain_r1_int;
            cont_flag         <= 1'b1;
            rx_charisk_r1_int <= rx_charisk_r1_int;
        end
      else begin
        if (cont_flag == 1'b1) begin
          if (rx_charisk_r1 && (
               (rx_datain_r1 == `HOLD)    || (rx_datain_r1 == `HOLDA) || (rx_datain_r1 == `PMREQ_P) ||
               (rx_datain_r1 == `PMREQ_S) || (rx_datain_r1 == `R_ERR) || (rx_datain_r1 == `R_IP)    ||
               (rx_datain_r1 == `R_OK)    || (rx_datain_r1 == `R_RDY) || (rx_datain_r1 == `SYNC)    ||
               (rx_datain_r1 == `WTRM)    || (rx_datain_r1 == `X_RDY) || (rx_datain_r1 == `SOF))      ) begin
            rx_datain_r1_int  <= rx_datain_r1;
            cont_flag         <= 1'b0;
            rx_charisk_r1_int <= rx_charisk_r1;
          end
          else begin              
            rx_datain_r1_int  <= rx_datain_r1_int;
            cont_flag         <= 1'b1;
            rx_charisk_r1_int <= rx_charisk_r1_int;
          end  
        end
        else begin
          rx_datain_r1_int  <= rx_datain_r1;
          cont_flag         <= 1'b0;
          rx_charisk_r1_int <= rx_charisk_r1;
        end
      end
    end
  end


always@(posedge clk or posedge reset) begin : data_mux
  if (reset) begin
    tx_dataout     <= 32'b0;
    rx_dataout     <= 32'b0;
    rx_charisk_out <= 4'b0;
    tx_charisk_out <= 1'b0;    
  end
  else begin
    if (linkup) begin
      rx_charisk_out <= rx_charisk_r1_int; //rx_charisk;
      rx_dataout     <= rx_datain_r1_int; //rx_datain;      
      tx_dataout     <= tx_datain;
      tx_charisk_out <= tx_chariskin;
    end
    else if (send_align_r) begin
      // Send Align primitives. Align is 
      // K28.5, D10.2, D10.2, D27.3
      rx_charisk_out <= rx_charisk;
      rx_dataout     <= rx_datain;
      tx_dataout     <= 32'h7B4A4ABC; 
      tx_charisk_out <= 1'b1;
    end
    else if ( send_d10_2_r ) begin
      // D10.2-D10.2 "dial tone"
      rx_charisk_out <= rx_charisk;
      rx_dataout     <= rx_datain;
      tx_dataout     <= 32'h4A4A4A4A; 
      tx_charisk_out <= 1'b0;
    end     
    else begin
      rx_charisk_out <= rx_charisk;
      rx_dataout     <= rx_datain;
      tx_dataout     <= 32'h7B4A4ABC; 
      tx_charisk_out <= 1'b1;
    end 
  end
end

always@(posedge clk or posedge reset) begin : comreset_OOB_count
    if (reset) begin
        count160 = 8'b0;
        count160_round = 5'b0;
    end 
    else if (count160_go) begin  
        if (count160 == 8'h10 ) begin
            count160 = 8'b0;
            count160_round = count160_round + 1;
        end 
        else
            count160 = count160 + 1;
        end
    else begin
        count160 = 8'b0;
        count160_round = 5'b0;
    end     
end

always@(posedge clk or posedge reset) begin : freecount
    if (reset) begin
        count = 18'b0;
    end 
    else if (count_en) begin  
        count = count + 1;
    end 
    else begin
        count = 18'b0;
  end
end

always@(posedge clk or posedge reset) begin : rxdata_shift
    if (reset) begin
        rx_datain_r1  <= 32'b0;
        rx_charisk_r1 <= 1'b0;  
    end 
    else begin 
        rx_datain_r1  <= rx_datain;
        rx_charisk_r1 <= rx_charisk;
    end
end

always@(posedge clk or posedge reset) begin : txdata_shift
    if (reset) begin
        tx_datain_r1 <= 8'b0;
        tx_datain_r2 <= 8'b0;
        tx_datain_r3 <= 8'b0;
        tx_datain_r4 <= 8'b0;           
    end 
    else begin  
        tx_datain_r1 <= tx_dataout;
        tx_datain_r2 <= tx_datain_r1;
        tx_datain_r3 <= tx_datain_r2;
        tx_datain_r4 <= tx_datain_r3;
    end
end

always@(posedge clk or posedge reset) begin : send_align_cnt
    if (reset)
        align_count = 2'b0;
    else if (align_cnt_en)
        align_count = align_count + 1;
    else
        align_count = 2'b0;
end

assign comreset_done = (CurrentState == HOST_COMRESET && count160_round == 5'h15) ? 1'b1 : 1'b0;
assign HOST_COMWAKE_done = (CurrentState == HOST_COMWAKE && count160_round == 5'h0b) ? 1'b1 : 1'b0;

//Primitive detection
assign  align_det             = (rx_datain_r1 == 32'h7B4A4ABC) && (rxbyteisaligned == 1'b1); 
assign  sync_det              = (rx_datain_r1 == 32'hB5B5957C);
assign  cont_det              = (rx_datain_r1 == 32'h9999AA7C);
assign  sof_det               = (rx_datain_r1 == 32'h3737B57C);
assign  eof_det               = (rx_datain_r1 == 32'hD5D5B57C);
assign  x_rdy_det             = (rx_datain_r1 == 32'h5757B57C);
assign  r_err_det             = (rx_datain_r1 == 32'h5656B57C);
assign  r_ok_det              = (rx_datain_r1 == 32'h3535B57C);


assign  txcominit             = txcominit_r;
assign  txcomwake             = txcomwake_r;
assign  txelecidle            = txelecidle_r;
assign  align_cnt_en          = ~send_d10_2_r;
assign  linkup                = linkup_r; 
assign  CurrentState_out      = CurrentState;
assign  align_det_out         = align_det;
assign  sync_det_out          = sync_det;
assign  rx_sof_det_out        = sof_det;
assign  rx_eof_det_out        = eof_det;

endmodule
