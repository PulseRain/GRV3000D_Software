##################################################################################################
## Copyright : PulseRain Technology, LLC. 2021
##################################################################################################
## Remarks:
##   Constraint for NexysA7 board
##################################################################################################



##################################################################################################
# Timing Constraint
##################################################################################################


create_clock -period 10.000 [get_ports OSC_IN]



##################################################################################################
# IO Constraint
##################################################################################################


set_property -dict {PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports OSC_IN]
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports CK_RST]


set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports BTN0]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports BTN1]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports BTN2]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports BTN3]

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports SW0]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports SW1]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports SW2]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports SW3]

set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports LD0_RED]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports LD0_GREEN]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports LD0_BLUE]

set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports LD1_RED]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports LD1_GREEN]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports LD1_BLUE]

set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports LD2_RED]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports LD2_GREEN]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports LD2_BLUE]

set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports LD3_RED]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports LD3_GREEN]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports LD3_BLUE]

set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports LD4]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports LD5]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports LD6]
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports LD7]

set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports UART_TXD]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports UART_RXD]


set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_CTS_N]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_TXD]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_RXD]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports PMOD_UART_RTS_N]



set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_CLK]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_DT]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_SW]
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports PMOD_ENCODER_SEL]


set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_MCLK]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_LRCK]
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_SCLK]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports PMOD_AD_SD]
      
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_MCLK]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_LRCK]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_SCLK]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports PMOD_DA_SD]
      

set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports TDO]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports nTRST]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports TCK]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports TDI]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports TMS]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports nRESET]


#set_property PULLUP TRUE [get_ports TDI]
#set_property PULLUP TRUE [get_ports TMS]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets TCK_IBUF]





set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
