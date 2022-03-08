## HDMI Output for Zybo Z7
## Add 'ZYNQ7 Processing System' IP core, source this file, then connection automation should do the rest (AXI buses, clocks, resets)
## Requires 'axi_dynclk' and 'rgb2dvi' cores from Digilent (see https://github.com/Digilent/vivado-library)

startgroup

# Set Zynq PL clock to 100MHz and add HP1 slave port
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] [get_bd_cells processing_system7_0]

# Create hierarchy for HDMI
create_bd_cell -type hier hdmi

# Create IP cores
create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 hdmi/axi_dynclk_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 hdmi/axi_vdma_0
create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 hdmi/v_tc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 hdmi/v_axi4s_vid_out_0
create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.4 hdmi/rgb2dvi_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 hdmi/axis_subset_converter_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 hdmi/xlconstant_0

# Set IP core options
set_property -dict [list CONFIG.c_num_fstores {2} CONFIG.c_mm2s_genlock_mode {0} CONFIG.c_s2mm_genlock_mode {0} CONFIG.c_mm2s_linebuffer_depth {2048} CONFIG.c_mm2s_max_burst_length {32} CONFIG.c_include_s2mm {0}] [get_bd_cells hdmi/axi_vdma_0]
set_property -dict [list CONFIG.enable_detection {false}] [get_bd_cells hdmi/v_tc_0]
set_property -dict [list CONFIG.C_HAS_ASYNC_CLK {1} CONFIG.C_ADDR_WIDTH {12} CONFIG.C_VTG_MASTER_SLAVE {1}] [get_bd_cells hdmi/v_axi4s_vid_out_0]
set_property -dict [list CONFIG.kRstActiveHigh {false} CONFIG.kGenerateSerialClk {false}] [get_bd_cells hdmi/rgb2dvi_0]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER CONFIG.M_TDATA_NUM_BYTES.VALUE_SRC USER] [get_bd_cells hdmi/axis_subset_converter_0]
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {4} CONFIG.M_TDATA_NUM_BYTES {3} CONFIG.TDATA_REMAP {tdata[23:16],tdata[7:0],tdata[15:8]}] [get_bd_cells hdmi/axis_subset_converter_0]
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells hdmi/xlconstant_0]

# Create HDMI output interface
create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 hdmi/hdmi_out

# Connect up internal nets
connect_bd_net [get_bd_pins hdmi/axi_dynclk_0/REF_CLK_I] [get_bd_pins hdmi/axi_dynclk_0/s00_axi_aclk]
connect_bd_net [get_bd_pins hdmi/axi_dynclk_0/PXL_CLK_O] [get_bd_pins hdmi/v_tc_0/clk] [get_bd_pins hdmi/v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins hdmi/rgb2dvi_0/PixelClk]
connect_bd_net [get_bd_pins hdmi/axi_dynclk_0/PXL_CLK_5X_O] [get_bd_pins hdmi/rgb2dvi_0/SerialClk]
connect_bd_net [get_bd_pins hdmi/axi_dynclk_0/LOCKED_O] [get_bd_pins hdmi/rgb2dvi_0/aRst_n]
connect_bd_net [get_bd_pins hdmi/axis_subset_converter_0/aclk] [get_bd_pins hdmi/axi_vdma_0/m_axis_mm2s_aclk]
connect_bd_net [get_bd_pins hdmi/xlconstant_0/dout] [get_bd_pins hdmi/axis_subset_converter_0/aresetn]
connect_bd_intf_net [get_bd_intf_pins hdmi/v_tc_0/vtiming_out] [get_bd_intf_pins hdmi/v_axi4s_vid_out_0/vtiming_in]
connect_bd_intf_net [get_bd_intf_pins hdmi/axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins hdmi/axis_subset_converter_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins hdmi/axis_subset_converter_0/M_AXIS] [get_bd_intf_pins hdmi/v_axi4s_vid_out_0/video_in]
connect_bd_intf_net [get_bd_intf_pins hdmi/v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins hdmi/rgb2dvi_0/RGB]
connect_bd_intf_net [get_bd_intf_pins hdmi/hdmi_out] [get_bd_intf_pins hdmi/rgb2dvi_0/TMDS]

# Create and connect external HDMI interface
create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 hdmi_out
connect_bd_intf_net [get_bd_intf_ports hdmi_out] -boundary_type upper [get_bd_intf_pins hdmi/hdmi_out]

# Tidy up routing
regenerate_bd_layout -routing

endgroup
