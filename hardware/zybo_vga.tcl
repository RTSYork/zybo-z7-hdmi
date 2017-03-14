## VGA Output for Zybo
## Source this file, then connection automation should do the rest (AXI buses, clocks and resets)
## Requires 'axi_dynclk' and 'rgb2vga' cores from Digilent

startgroup

# Create hierarchy
create_bd_cell -type hier vga

# Create IP cores
create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 vga/axi_dynclk_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 vga/axi_vdma_0
create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 vga/v_tc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 vga/v_axi4s_vid_out_0
create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2vga:1.0 vga/rgb2vga_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vga/xlslice_0

# Set IP core options
set_property -dict [list CONFIG.c_m_axi_mm2s_data_width {64} CONFIG.c_m_axis_mm2s_tdata_width {32} CONFIG.c_num_fstores {2} CONFIG.c_mm2s_genlock_mode {0} CONFIG.c_mm2s_linebuffer_depth {4096} CONFIG.c_mm2s_max_burst_length {32} CONFIG.c_include_s2mm {0} CONFIG.c_s2mm_genlock_mode {0}] [get_bd_cells vga/axi_vdma_0]
set_property -dict [list CONFIG.enable_detection {false}] [get_bd_cells vga/v_tc_0]
set_property -dict [list CONFIG.C_S_AXIS_VIDEO_FORMAT.VALUE_SRC USER CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH.VALUE_SRC USER] [get_bd_cells vga/v_axi4s_vid_out_0]
set_property -dict [list CONFIG.C_ADDR_WIDTH {5} CONFIG.C_VTG_MASTER_SLAVE {1}] [get_bd_cells vga/v_axi4s_vid_out_0]
set_property -dict [list CONFIG.DIN_FROM {23} CONFIG.DOUT_WIDTH {24}] [get_bd_cells vga/xlslice_0]

# Create output pins
create_bd_pin -dir O -from 4 -to 0 vga/vga_red
create_bd_pin -dir O -from 5 -to 0 vga/vga_green
create_bd_pin -dir O -from 4 -to 0 vga/vga_blue
create_bd_pin -dir O vga/vga_hsync
create_bd_pin -dir O vga/vga_vsync

# Connect up internal ports
connect_bd_net [get_bd_pins vga/axi_dynclk_0/s00_axi_aclk] [get_bd_pins vga/axi_dynclk_0/REF_CLK_I]

connect_bd_net [get_bd_pins vga/axi_dynclk_0/PXL_CLK_O] [get_bd_pins vga/rgb2vga_0/PixelClk]
connect_bd_net [get_bd_pins vga/v_axi4s_vid_out_0/aclk] [get_bd_pins vga/axi_dynclk_0/PXL_CLK_O]
connect_bd_net [get_bd_pins vga/axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins vga/axi_dynclk_0/PXL_CLK_O]
connect_bd_net [get_bd_pins vga/v_tc_0/clk] [get_bd_pins vga/axi_dynclk_0/PXL_CLK_O]
connect_bd_intf_net [get_bd_intf_pins vga/v_tc_0/vtiming_out] [get_bd_intf_pins vga/v_axi4s_vid_out_0/vtiming_in]
connect_bd_intf_net [get_bd_intf_pins vga/v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins vga/rgb2vga_0/vid_in]
connect_bd_net [get_bd_pins vga/axi_vdma_0/m_axis_mm2s_tdata] [get_bd_pins vga/xlslice_0/Din]
connect_bd_net [get_bd_pins vga/xlslice_0/Dout] [get_bd_pins vga/v_axi4s_vid_out_0/s_axis_video_tdata]
connect_bd_net [get_bd_pins vga/axi_vdma_0/m_axis_mm2s_tlast] [get_bd_pins vga/v_axi4s_vid_out_0/s_axis_video_tlast]
connect_bd_net [get_bd_pins vga/axi_vdma_0/m_axis_mm2s_tready] [get_bd_pins vga/v_axi4s_vid_out_0/s_axis_video_tready]
connect_bd_net [get_bd_pins vga/axi_vdma_0/m_axis_mm2s_tuser] [get_bd_pins vga/v_axi4s_vid_out_0/s_axis_video_tuser]
connect_bd_net [get_bd_pins vga/axi_vdma_0/m_axis_mm2s_tvalid] [get_bd_pins vga/v_axi4s_vid_out_0/s_axis_video_tvalid]
connect_bd_net [get_bd_pins vga/vga_red] [get_bd_pins vga/rgb2vga_0/vga_pRed]
connect_bd_net [get_bd_pins vga/vga_green] [get_bd_pins vga/rgb2vga_0/vga_pGreen]
connect_bd_net [get_bd_pins vga/vga_blue] [get_bd_pins vga/rgb2vga_0/vga_pBlue]
connect_bd_net [get_bd_pins vga/vga_hsync] [get_bd_pins vga/rgb2vga_0/vga_pHSync]
connect_bd_net [get_bd_pins vga/vga_vsync] [get_bd_pins vga/rgb2vga_0/vga_pVSync]

# Make external ports
create_bd_port -dir O -from 5 -to 0 vga_green
connect_bd_net [get_bd_pins /vga/vga_green] [get_bd_ports vga_green]
create_bd_port -dir O -from 4 -to 0 vga_blue
connect_bd_net [get_bd_pins /vga/vga_blue] [get_bd_ports vga_blue]
create_bd_port -dir O vga_hsync
connect_bd_net [get_bd_pins /vga/vga_hsync] [get_bd_ports vga_hsync]
create_bd_port -dir O -from 4 -to 0 vga_red
connect_bd_net [get_bd_pins /vga/vga_red] [get_bd_ports vga_red]
create_bd_port -dir O vga_vsync
connect_bd_net [get_bd_pins /vga/vga_vsync] [get_bd_ports vga_vsync]

# Tidy up routing
regenerate_bd_layout -routing

endgroup
