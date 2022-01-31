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

