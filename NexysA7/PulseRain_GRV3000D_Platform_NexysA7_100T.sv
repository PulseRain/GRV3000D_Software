/*
//===========================================================================
// Copyright : PulseRain Technology, LLC. 2021
//===========================================================================
// Legal Notice :
//   PulseRain Technology Proprietary Information
//
//   All contents of this file shall be treated as Proprietary Information
//   and shall not be disclosed to any third party without the explicit
//   permission from PulseRain Technology, LLC.
//===========================================================================
*/

`default_nettype none

module PulseRain_GRV3000D_Platform_NexysA7_100T #(parameter sim = 0) (

    //=====================================================================
    // clock and reset
    //=====================================================================
        input   wire                                            OSC_IN,                          
        input   wire                                            CK_RST,                      
  

    //=====================================================================
    // UART
    //=====================================================================
        output  wire                                            UART_TXD, 
        input   wire                                            UART_RXD,
    
    //=====================================================================
    // Push Button
    //=====================================================================
        input   wire                                            BTNL,
        input   wire                                            BTNR,
        input   wire                                            BTNU,
        input   wire                                            BTND,
        input   wire                                            BTNC,
        
    
    //=====================================================================
    // DIP Switch
    //=====================================================================
        input  wire                                             SW0,
        input  wire                                             SW1,
        input  wire                                             SW2,
        input  wire                                             SW3,
        input  wire                                             SW4,
        input  wire                                             SW5,
        input  wire                                             SW6,
        input  wire                                             SW7,
    
    //=====================================================================
    // Seven Segment
    //=====================================================================
        output wire                                             CA,
        output wire                                             CB,
        output wire                                             CC,
        output wire                                             CD,
        output wire                                             CE,
        output wire                                             CF,
        output wire                                             CG,
        output wire                                             DP,
        
        output wire                                             AN0,
        output wire                                             AN1,
        output wire                                             AN2,
        output wire                                             AN3,
        output wire                                             AN4,
        output wire                                             AN5,
        output wire                                             AN6,
        output wire                                             AN7,
                                                             
    
    //=====================================================================
    // LED
    //=====================================================================
        output wire                                             LD0,
        output wire                                             LD1,
        output wire                                             LD2,
        
        output wire                                             LD3,
        output wire                                             LD4,
        output wire                                             LD5,
        
        output wire                                             LD6,
        output wire                                             LD7,
        output wire                                             LD8,
        
        output wire                                             LD9,
        output wire                                             LD10,
        output wire                                             LD11,
        
        output wire                                             LD12,
        output wire                                             LD13,
        output wire                                             LD14,
        output wire                                             LD15,
        
        
    //=====================================================================
    // PMOD A, UART
    //=====================================================================
        output wire                                             PMOD_UART_TXD,
        input  wire                                             PMOD_UART_RXD,
        input  wire                                             PMOD_UART_CTS_N,
        output wire                                             PMOD_UART_RTS_N,
    
    //=====================================================================
    // PMOD B, CODEC
    //=====================================================================
        output  wire                                            PMOD_AD_MCLK,
        output  wire                                            PMOD_AD_LRCK,
        output  wire                                            PMOD_AD_SCLK,
        input   wire                                            PMOD_AD_SD,
        
        output  wire                                            PMOD_DA_MCLK,
        output  wire                                            PMOD_DA_LRCK,
        output  wire                                            PMOD_DA_SCLK,
        output  wire                                            PMOD_DA_SD,
        
    //=====================================================================
    // PMOD C, Rotary Encoder
    //=====================================================================
        input   wire                                            PMOD_ENCODER_CLK,
        input   wire                                            PMOD_ENCODER_DT,
        input   wire                                            PMOD_ENCODER_SW,
        input   wire                                            PMOD_ENCODER_SEL,
        
    //=======================================================================
    // JTAG
    //=======================================================================
        input   wire                                            nRESET,
        input   wire                                            TCK,
        input   wire                                            nTRST,
        input   wire                                            TMS,
        input   wire                                            TDI,
        output  wire                                            TDO
);

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Signal
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        wire                                                    clk_main;
        wire                                                    reset_n;
        
        wire                                                    chan_enable_out;
        wire [23 : 0]                                           left_chan_data_out;
        wire [23 : 0]                                           right_chan_data_out;
     
        wire [15 : 0]                                           gpio_out;
        wire                                                    processor_paused;
        
        wire                                                    TDO_i;
        wire                                                    TDO_valid;
        
        wire  [4 : 0]                                           five_way_keys;
        wire  [4 : 0]                                           five_way_keys_debounced;
        logic                                                   int0;
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MMCM
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        clk_mmcm clk_mmcm_i (
            .clk_main(clk_main),
            .reset (~CK_RST),
            .locked (reset_n),
            .clk_in (OSC_IN)
        ); 
        
    
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // 5 way navigation switch
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        assign five_way_keys[0] = BTNL;
        assign five_way_keys[1] = BTNR;
        assign five_way_keys[2] = BTNU;
        assign five_way_keys[3] = BTND;
        assign five_way_keys[4] = BTNC;
        
        genvar i;
        
        generate
            
            for (i = 0; i < 5; i = i + 1) begin: gen_keys
            
                
                switch_debouncer  #(.TIMER_VALUE (100000)) switch_debouncer_i (
                    .clk (clk_main),
                    .reset_n (reset_n),
            
                    .data_in (five_way_keys[i]),
                    .data_out (five_way_keys_debounced[i])
                );
                
            end 
            
        endgenerate
        
        always_ff @(posedge clk_main, negedge reset_n) begin
            if (!reset_n) begin
                int0 <= 0;
            end else begin
                int0 <= |five_way_keys_debounced;
            end
        end
        
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // CPU
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
       PulseRain_GRV3000D_Platform_Nexys PulseRain_GRV3000D_Platform_Nexys_i (
            .uart_RXD           (UART_RXD),
            .uart_TXD           (UART_TXD),
            .gpio_gpio_in       ({SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0, 3'd0, five_way_keys_debounced}),
            .gpio_gpio_out      (gpio_out),
            
            .INTx ({1'b0, int0}),
            
            .rot_encoder_encoder_clk (PMOD_ENCODER_CLK),
            .rot_encoder_encoder_dt  (PMOD_ENCODER_DT),
            .rot_encoder_encoder_sw  (PMOD_ENCODER_SW),
            
            .AD_I2S_MCLK (PMOD_AD_MCLK),
            .AD_I2S_LRCK (PMOD_AD_LRCK),
            .AD_I2S_SCLK (PMOD_AD_SCLK),
            .AD_I2S_SD (PMOD_AD_SD),
            
            .DA_I2S_MCLK (PMOD_DA_MCLK),
            .DA_I2S_LRCK (PMOD_DA_LRCK),
            .DA_I2S_SCLK (PMOD_DA_SCLK),
            .DA_I2S_SD   (PMOD_DA_SD),
              
            .jtag_tap_nRESET    (nRESET),
            .jtag_tap_TCK       (TCK),
            .jtag_tap_nTRST     (nTRST),
            .jtag_tap_TMS       (TMS),
            .jtag_tap_TDI       (TDI),
            .jtag_tap_TDO       (TDO_i),
            .jtag_tap_TDO_valid (TDO_valid),
            
            .processor_paused   (processor_paused),
            .clk                (clk_main),
            .resetn             (reset_n));
                    
        assign TDO = TDO_valid ? TDO_i : 1'bZ;
        
        assign LD0              = processor_paused;
        assign LD1              = ~processor_paused;
        assign LD2              = 1'b0;
            
        assign LD3              = BTNL;
        assign LD4              = BTNR;
        assign LD5              = BTNU;
        
        assign LD6              = BTND;
        assign LD7              = BTNC;
        assign LD8              = 1'b0; // gpio_out[8];
        
        assign LD9              = gpio_out[15];
        assign LD10             = 1'b0;
        assign LD11             = 1'b0;
        
        assign LD12             = gpio_out[12];
        assign LD13             = gpio_out[13];
        assign LD14             = gpio_out[14];
        assign LD15             = gpio_out[15];
        
        assign CA               = ~gpio_out[0];
        assign CB               = ~gpio_out[1];
        assign CC               = ~gpio_out[2];
        assign CD               = ~gpio_out[3];
        assign CE               = ~gpio_out[4];
        assign CF               = ~gpio_out[5];
        assign CG               = ~gpio_out[6];
        assign DP               = ~gpio_out[7];
        
        assign AN0              = ~gpio_out[8];
        assign AN1              = ~gpio_out[9];
        assign AN2              = ~gpio_out[10];
        assign AN3              = ~gpio_out[11];
        assign AN4              = 1'b1;
        assign AN5              = 1'b1;
        assign AN6              = 1'b1;
        assign AN7              = 1'b1;
        
        
                
endmodule

`default_nettype wire

