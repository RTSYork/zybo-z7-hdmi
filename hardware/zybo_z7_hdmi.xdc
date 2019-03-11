# Zybo Z7 HDMI TX pins
set_property -dict { PACKAGE_PIN H17  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_clk_n      }]; #IO_L13N_T2_MRCC_35 Sch=hdmi_tx_clk_n
set_property -dict { PACKAGE_PIN H16  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_clk_p      }]; #IO_L13P_T2_MRCC_35 Sch=hdmi_tx_clk_p
set_property -dict { PACKAGE_PIN D20  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_data_n[0]  }]; #IO_L4N_T0_35 Sch=hdmi_tx_n[0]
set_property -dict { PACKAGE_PIN D19  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_data_p[0]  }]; #IO_L4P_T0_35 Sch=hdmi_tx_p[0]
set_property -dict { PACKAGE_PIN B20  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_data_n[1]  }]; #IO_L1N_T0_AD0N_35 Sch=hdmi_tx_n[1]
set_property -dict { PACKAGE_PIN C20  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_data_p[1]  }]; #IO_L1P_T0_AD0P_35 Sch=hdmi_tx_p[1]
set_property -dict { PACKAGE_PIN A20  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_data_n[2]  }]; #IO_L2N_T0_AD8N_35 Sch=hdmi_tx_n[2]
set_property -dict { PACKAGE_PIN B19  IOSTANDARD TMDS_33  } [get_ports { hdmi_out_data_p[2]  }]; #IO_L2P_T0_AD8P_35 Sch=hdmi_tx_p[2]
