/*
//===========================================================================
// Copyright : PulseRain Technology, LLC. 2021
//===========================================================================
// Remarks :
//   Top Level wrapper for NexysA7 board
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
        input   wire                                            BTN0,
        input   wire                                            BTN1,
        input   wire                                            BTN2,
        input   wire                                            BTN3,
        
    
    //=====================================================================
    // DIP Switch
    //=====================================================================
        input  wire                                             SW0,
        input  wire                                             SW1,
        input  wire                                             SW2,
        input  wire                                             SW3,
    
    //=====================================================================
    // LED
    //=====================================================================
        output wire                                             LD0_RED,
        output wire                                             LD0_GREEN,
        output wire                                             LD0_BLUE,
        
        output wire                                             LD1_RED,
        output wire                                             LD1_GREEN,
        output wire                                             LD1_BLUE,
        
        output wire                                             LD2_RED,
        output wire                                             LD2_GREEN,
        output wire                                             LD2_BLUE,
        
        output wire                                             LD3_RED,
        output wire                                             LD3_GREEN,
        output wire                                             LD3_BLUE,
        
        output wire                                             LD4,
        output wire                                             LD5,
        output wire                                             LD6,
        output wire                                             LD7,
        
        
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
    // CPU
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
       PulseRain_GRV3000D_Platform_Nexys PulseRain_GRV3000D_Platform_Nexys_i (
            .uart_RXD           (UART_RXD),
            .uart_TXD           (UART_TXD),
            .gpio_gpio_in       ({8'd0, BTN3, BTN2, BTN1, BTN0, SW3, SW2, SW1, SW0}),
            .gpio_gpio_out      (gpio_out),
            
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
        
        assign LD0_RED          = processor_paused;
        assign LD0_GREEN        = ~processor_paused;
        assign LD0_BLUE         = 1'b0;
            
        assign LD1_RED          = 1'b0; // gpio_out[3];
        assign LD1_GREEN        = 1'b0; // gpio_out[4];
        assign LD1_BLUE         = 1'b0; // gpio_out[5];
        
        assign LD2_RED          = 1'b0; // gpio_out[6];
        assign LD2_GREEN        = 1'b0; // gpio_out[7];
        assign LD2_BLUE         = 1'b0; // gpio_out[8];
        
        assign LD3_RED          = gpio_out[15];
        assign LD3_GREEN        = 1'b0; //gpio_out[10];
        assign LD3_BLUE         = ~gpio_out[15]; //gpio_out[11];
        
        assign LD4              = gpio_out[12];
        assign LD5              = gpio_out[13];
        assign LD6              = gpio_out[14];
        assign LD7              = gpio_out[15];
                
endmodule

`default_nettype wire

