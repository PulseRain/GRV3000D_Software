# GRV3000D_Software
Software for PulseRain GRV3000D

## Update the FPGA Flash Image

1. To update the FPGA Flash image, please install the Xilinx Vivado Lab Tools First

The Xilinx Vivado Lab Solution 2021.2 for Windows can be downloaded from

[https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Vivado_Lab_Win_2021.2_1021_0703.tar.gz](https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Vivado_Lab_Win_2021.2_1021_0703.tar.gz)

(You might need to register for a Xilinx account with a corporate email address)

And after download, extracting the Xilinx_Vivado_Lab_Win_2021.2_1021_0703.tar.gz, and run the 

Xilinx_Vivado_Lab_Win_2021.2_1021_0703\bin\xsetup.bat as administrator


2. Launch Xilinx Vivado Lab Edition

On Windows, if it can not be found on the Start Menu, it can be launched from C:\Xilinx\Vivado_Lab\2021.2\bin\vivado_lab.bat

After launching, please open the hardware manager

![Vivado Lab Edition](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/vivado_lab_edition_cover.png)

3. Connect the board to the PC through USB port, and flip the switch on


4. Click Open Target / Auto Connect

![auto connect](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/auto_detect.png)


5. After that, right click the xc7a100t_0 device, and click "Add Configuration Memory Device"

![add mem device](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/add_mem_device.png)


6. In the Dialogue of "Add Configuration Memory Device", please choose s25fl128sxxxxxx0-spi-x1_x2_x4, as shown below

![config mem list](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/config_mem_device_list.png)


7. After selecting the Configuration Memory Device, you can click ok to program the configuration memory device right away, or right click the s25fl128sxxxxxx0-spi-x1_x2_x4 device, and choose "Program Configuration Memory Device ..."
![ok](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/ok.png)
![program](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/program.png)

8. In the dialogue of "Program Configuration Memory Device", select the correspondent .bin file in the Configuration file, as shown below

![program config mem](https://github.com/PulseRain/GRV3000D_Software/raw/main/media/program_config_mem.png)

The program operation may take about a minute


9. After that, please power cycle the board. For the Nexys board, please click "PROG" button after power cycle, to load the FPGA image
