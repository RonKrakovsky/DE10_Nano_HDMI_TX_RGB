// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Generated by Quartus Prime Version 17.0 (Build Build 595 04/25/2017)
// Created on Thu Feb 24 14:11:21 2022

VGA_IMAGE_RGB VGA_IMAGE_RGB_inst
(
	.csi_sink_clk(csi_sink_clk_sig) ,	// input  csi_sink_clk_sig
	.rsi_sink_reset(rsi_sink_reset_sig) ,	// input  rsi_sink_reset_sig
	.reset_pixels_v(reset_pixels_v_sig) ,	// input  reset_pixels_v_sig
	.reset_pixels_h(reset_pixels_h_sig) ,	// input  reset_pixels_h_sig
	.v_act(v_act_sig) ,	// input  v_act_sig
	.h_act(h_act_sig) ,	// input  h_act_sig
	.aso_source_vga_r(aso_source_vga_r_sig) ,	// output [7:0] aso_source_vga_r_sig
	.aso_source_vga_g(aso_source_vga_g_sig) ,	// output [7:0] aso_source_vga_g_sig
	.aso_source_vga_b(aso_source_vga_b_sig) 	// output [7:0] aso_source_vga_b_sig
);

