`include "TIME_SCALE.svh"
`include "SAL_DDR_PARAMS.svh"

module SAL_BK_CTRL
(
    // clock & reset
    input                       clk,
    input                       rst_n,

    // timing parameters
    TIMING_IF.MON               timing_if,

    // request from the address decoder
    REQ_IF.DST                  req_if,
    // scheduling interface
    SCHED_IF.BK_CTRL            sched_if,

    // per-bank auto-refresh requests
    input   wire                ref_req_i,
    output  logic               ref_gnt_o
);


    /*
    * FILL YOUR CODES HERE
    */
    
    // Define States
    typedef enum logic [2:0] {
        S_IDLE        = 3'b000,
        S_ACTIVATING  = 3'b001,
        S_BANK_ACTIVE = 3'b010,
        S_READING     = 3'b011,
        S_WRITING     = 3'b100,
        S_PRECHARGING = 3'b101
    } state_t;

    // Define Registers
    reg [31:0] cur_ra, cur_ra_n;    // 현재 행 주소 및 다음 행 주소
    
    reg [3:0] cntr_value_n;         // counter value
    reg [`ROW_OPEN_WIDTH-1:0] row_open_cntr_value_n;   // row_open_cnt
    reg [`T_RC_WIDTH-1:0] tRC_cntr_value_n;   // tRC
    reg [`T_RAS_WIDTH-1:0] tRAS_cntr_value_n;   // tRAS
    reg [`T_RTP_WIDTH-1:0] tRTP_cntr_value_n;   // tRTP
    reg [`T_WTP_WIDTH-1:0] tWTP_cntr_value_n;   // tWTP
    
    reg         cntr_cmd_n, 
                row_open_cntr_cmd_n, 
                tRC_cntr_cmd_n, 
                tRAS_cntr_cmd_n, 
                tRTP_cntr_cmd_n, 
                tWTP_cntr_cmd_n;       // counter command  

                   
    wire        is_zero, 
                row_open_is_zero,             
                tRC_cntr_is_zero, 
                tRAS_cntr_is_zero, 
                tRTP_cntr_is_zero, 
                tWTP_cntr_is_zero;       // SAL_TIMING_CNTR zero

    
    
    
    state_t state, state_n;          // 현재 상태 및 다음 상태
    
    SAL_TIMING_CNTR timing_cntr
    (   
        .clk (clk),
        .rst_n (rst_n),
    
        .reset_cmd_i(cntr_cmd_n),
        .reset_value_i(cntr_value_n),
    
        .is_zero_o(is_zero) // when counting : 1, when not counting : 0
     );  
     
     SAL_TIMING_CNTR #(.CNTR_WIDTH(`ROW_OPEN_WIDTH)) row_open_timing_cntr
     (
        .clk (clk),
        .rst_n (rst_n),
    
        .reset_cmd_i(row_open_cntr_cmd_n),
        .reset_value_i(row_open_cntr_value_n),
    
        .is_zero_o(row_open_is_zero) // when counting : 1, when not counting : 0
     );   
     
     SAL_TIMING_CNTR #(.CNTR_WIDTH(`T_RC_WIDTH)) tRC_timing_cntr
     (
        .clk (clk),
        .rst_n (rst_n),
    
        .reset_cmd_i(tRC_cntr_cmd_n),
        .reset_value_i(tRC_cntr_value_n),
    
        .is_zero_o(tRC_is_zero) // when counting : 1, when not counting : 0
     ); 
     
     SAL_TIMING_CNTR #(.CNTR_WIDTH(`T_RAS_WIDTH)) tRAS_timing_cntr
     (
        .clk (clk),
        .rst_n (rst_n),
    
        .reset_cmd_i(tRAS_cntr_cmd_n),
        .reset_value_i(tRAS_cntr_value_n),
    
        .is_zero_o(tRAS_is_zero) // when counting : 1, when not counting : 0
     ); 
     
     SAL_TIMING_CNTR #(.CNTR_WIDTH(`T_RTP_WIDTH)) tRTP_timing_cntr
     (
        .clk (clk),
        .rst_n (rst_n),
    
        .reset_cmd_i(tRTP_cntr_cmd_n),
        .reset_value_i(tRTP_cntr_value_n),
    
        .is_zero_o(tRTP_is_zero) // when counting : 1, when not counting : 0
     ); 
     
     SAL_TIMING_CNTR #(.CNTR_WIDTH(`T_WTP_WIDTH)) tWTP_timing_cntr
     (
        .clk (clk),
        .rst_n (rst_n),
    
        .reset_cmd_i(tWTP_cntr_cmd_n),
        .reset_value_i(tWTP_cntr_value_n),
    
        .is_zero_o(tWTP_is_zero) // when counting : 1, when not counting : 0
     );   
    
    
    // Next State Flip-Flop
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 리셋 시 초기화
            state <= S_IDLE;
            cur_ra <= 32'hx;
        end else begin
            // FSM Update
            state <= state_n;
            cur_ra <= cur_ra_n;
        end
    end

    // Comb Logic
    always_comb begin
    
        // initial data
        cur_ra_n                    = cur_ra;
        state_n                     = state;

        ref_gnt_o                   = 1'b0;
        req_if.ready                = 1'b0;

        sched_if.act_gnt            = 1'b0;
        sched_if.rd_gnt             = 1'b0;
        sched_if.wr_gnt             = 1'b0;
        sched_if.pre_gnt            = 1'b0;
        sched_if.ref_gnt            = 1'b0;
        sched_if.ba                 = 'h0;  // bank 0
        sched_if.ra                 = 'hx;
        sched_if.ca                 = 'hx;
        sched_if.id                 = 'hx;
        sched_if.len                = 'hx;
        
        cntr_cmd_n                  = 1'b0;
        cntr_value_n                = 'hx;
        row_open_cntr_cmd_n         = 1'b0;
        row_open_cntr_value_n       = 'hx;
        tRC_cntr_cmd_n         = 1'b0;
        tRC_cntr_value_n       = 'hx;
        tRAS_cntr_cmd_n         = 1'b0;
        tRAS_cntr_value_n       = 'hx;
        tRTP_cntr_cmd_n         = 1'b0;
        tRTP_cntr_value_n       = 'hx;
        tWTP_cntr_cmd_n         = 1'b0;
        tWTP_cntr_value_n       = 'hx;
        
        case (state)
            S_IDLE: begin
                sched_if.act_gnt = req_if.valid & (tRC_is_zero == 'd1) & (is_zero == 'd1);
                if (sched_if.act_gnt == 1'b1) begin
                    state_n = S_ACTIVATING; // state change
                    
                    cntr_value_n = timing_if.t_rcd_m1-1; // 4 - 1
                    cntr_cmd_n = 1'b1;
                    
                    row_open_cntr_value_n = timing_if.row_open_cnt-1; // 31 - 1
                    row_open_cntr_cmd_n = 1'b1;
                    
                    tRAS_cntr_value_n = timing_if.t_ras_m1-1; // 16 - 1
                    tRAS_cntr_cmd_n = 1'b1;
                    
                    tRC_cntr_value_n = timing_if.t_rc_m1-1; // 22 - 1
                    tRC_cntr_cmd_n = 1'b1;
                    
                    cur_ra_n = req_if.ra; // requested row open
                    sched_if.ra = req_if.ra;
                end
            end

            S_ACTIVATING: begin

                if (is_zero) begin
                    state_n = S_BANK_ACTIVE;
                end
            end

            S_BANK_ACTIVE: begin
                sched_if.wr_gnt = req_if.valid & (req_if.ra == cur_ra) & (req_if.wr == 1'b1);
                sched_if.rd_gnt = req_if.valid & (req_if.ra == cur_ra) & (req_if.wr == 1'b0);
                sched_if.pre_gnt = ((req_if.valid & (req_if.ra != cur_ra)) | (row_open_is_zero == 'd1))&(tRAS_is_zero == 'd1)&(tRTP_is_zero == 'd1)&(tWTP_is_zero == 'd1); //& timing_if.t_ras_m1 & timing_if.t_rtp_m1 & timing_if.t_wtp_m1;
                req_if.ready = 1'b1;
                
                if (sched_if.wr_gnt) begin
                    state_n = S_WRITING;
                    
                    cntr_value_n = `BURST_LENGTH/2 - 1; // 2 - 1
                    cntr_cmd_n = 1'b1;
                    
                    tWTP_cntr_value_n = timing_if.t_wtp_m1-1; // 8 - 1
                    tWTP_cntr_cmd_n = 1'b1;
                    
                    sched_if.ca = req_if.ca;
                    
                end else if (sched_if.rd_gnt) begin
                    state_n = S_READING;
                    
                    cntr_value_n = `BURST_LENGTH/2 - 1; // 2 - 1
                    cntr_cmd_n = 1'b1;
                    
                    tRTP_cntr_value_n = timing_if.t_rtp_m1-1; // 3 - 1
                    tRTP_cntr_cmd_n = 1'b1;
                    
                    sched_if.ca = req_if.ca;
                    
                end else if (sched_if.pre_gnt) begin
                    state_n = S_PRECHARGING;
                    
                    cntr_value_n = timing_if.t_rp_m1 - 2; // 4 - 1
                    cntr_cmd_n = 1'b1;
                    
                end
     
            end

            S_READING: begin

                if (is_zero) begin
                    state_n = S_BANK_ACTIVE;
                end
            end

            S_WRITING: begin

                if (is_zero) begin
                    state_n = S_BANK_ACTIVE;
                end
            end

            S_PRECHARGING: begin

                if (is_zero) begin
                    state_n = S_IDLE;
                end
            end

            default: begin
                state_n = S_IDLE;
            end
        endcase
    end

endmodule // SAL_BK_CTRL
