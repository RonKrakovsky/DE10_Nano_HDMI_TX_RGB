// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

module vga_generator(                                    
  input						clk,                
  input						reset_n,                                                
  input			[11:0]	h_total,           
  input			[11:0]	h_sync,           
  input			[11:0]	h_start,             
  input			[11:0]	h_end,                                                    
  input			[11:0]	v_total,           
  input			[11:0]	v_sync,            
  input			[11:0]	v_start,           
  input			[11:0]	v_end, 
  input			[11:0]	v_active_14, 
  input			[11:0]	v_active_24, 
  input			[11:0]	v_active_34, 
  output	reg				vga_hs,             
  output	reg				vga_vs,           
  output	reg				vga_de,
  output	reg	[7:0]		vga_r,
  output	reg	[7:0]		vga_g,
  output	reg	[7:0]		vga_b                                                 
);

//=======================================================
//  Signal declarations
//=======================================================
reg	[11:0]	h_count;
reg	[7:0]		pixel_x;
reg	[11:0]	v_count;
reg				h_act; 
reg				h_act_d;
reg				v_act; 
reg				v_act_d; 
reg				pre_vga_de;
wire				h_max, hs_end, hr_start, hr_end;
wire				v_max, vs_end, vr_start, vr_end;
wire				v_act_14, v_act_24, v_act_34;
reg				boarder;
reg	[3:0]		color_mode;
reg 			reset_pixels_h;
reg 			reset_pixels_v;




VGA_IMAGE_RGB VGA_IMAGE_RGB_inst
(
	.csi_sink_clk(clk) ,	// input  csi_sink_clk_sig
	.rsi_sink_reset(reset_n) ,	// input  rsi_sink_reset_sig
	.reset_pixels_v(reset_pixels_v) ,	// input  reset_pixels_v_sig
	.reset_pixels_h(reset_pixels_h) ,	// input  reset_pixels_h_sig
	.v_act(v_act) ,	// input  v_act_sig
	.h_act(h_act) ,	// input  h_act_sig
	.aso_source_vga_r(vga_r) ,	// output [7:0] aso_source_vga_r_sig
	.aso_source_vga_g(vga_g) ,	// output [7:0] aso_source_vga_g_sig
	.aso_source_vga_b(vga_b) 	// output [7:0] aso_source_vga_b_sig
);
//=======================================================
//  Structural coding
//=======================================================
assign h_max = h_count == h_total;
assign hs_end = h_count >= h_sync;
assign hr_start = h_count == h_start; 
assign hr_end = h_count == h_end;
assign v_max = v_count == v_total;
assign vs_end = v_count >= v_sync;
assign vr_start = v_count == v_start; 
assign vr_end = v_count == v_end;
assign v_act_14 = v_count == v_active_14; 
assign v_act_24 = v_count == v_active_24; 
assign v_act_34 = v_count == v_active_34;

//horizontal control signals
always @ (posedge clk or negedge reset_n)
	if (!reset_n)
	begin
		h_act_d	<=	1'b0;
		h_count	<=	12'b0;
		pixel_x	<=	8'b0;
		vga_hs	<=	1'b1;
		h_act		<=	1'b0;
	end
	else
	begin
		h_act_d	<=	h_act;

		if (h_max)
		begin
			h_count	<=	12'b0;
			reset_pixels_h <= 1'b1;
		end
		else
		begin
			h_count	<=	h_count + 12'b1;
			reset_pixels_h <= 1'b0;
		end

		//if (h_act_d)
		//	pixel_x	<=	pixel_x + 8'b1;
		//else
		//	pixel_x	<=	8'b0;
		

		if (hs_end && !h_max)
			vga_hs	<=	1'b1;
		else
			vga_hs	<=	1'b0;

		if (hr_start)
			h_act		<=	1'b1;
		else if (hr_end)
			h_act		<=	1'b0;
	end

//vertical control signals
always@(posedge clk or negedge reset_n)
	if(!reset_n)
	begin
		v_act_d		<=	1'b0;
		v_count		<=	12'b0;
		vga_vs		<=	1'b1;
		v_act			<=	1'b0;
		color_mode	<=	4'b0;
	end
	else 
	begin		
		if (h_max)
		begin		  
			v_act_d	  <=	v_act;
		  
			if (v_max)
			begin
				v_count	<=	12'b0;
				reset_pixels_v <= 1'b1;
			end
			else
			begin
				v_count	<=	v_count + 12'b1;
				reset_pixels_v <= 1'b0;
			end

			if (vs_end && !v_max)
				vga_vs	<=	1'b1;
			else
				vga_vs	<=	1'b0;

			if (vr_start)
				v_act <=	1'b1;
			else if (vr_end)
				v_act <=	1'b0;

			//if (vr_start)
			//	color_mode[0] <=	1'b1;
			//else if (v_act_14)
			//	color_mode[0] <=	1'b0;
//
			//if (v_act_14)
			//	color_mode[1] <=	1'b1;
			//else if (v_act_24)
			//	color_mode[1] <=	1'b0;
		    //
			//if (v_act_24)
			//	color_mode[2] <=	1'b1;
			//else if (v_act_34)
			//	color_mode[2] <=	1'b0;
		    //
			//if (v_act_34)
			//	color_mode[3] <=	1'b1;
			//else if (vr_end)
			//	color_mode[3] <=	1'b0;
		end
	end

//pattern generator and display enable
always @(posedge clk or negedge reset_n)
begin
	if (!reset_n)
	begin
		vga_de		<=	1'b0;
		pre_vga_de	<=	1'b0;
		boarder		<=	1'b0;		
	end
	else
	begin
		vga_de		<=	pre_vga_de;
		pre_vga_de	<=	v_act && h_act;
		
		
		
		//if ((!h_act_d&&h_act) || hr_end || (!v_act_d&&v_act) || vr_end)
		//	boarder	<=	1'b1;
		//else
		//	boarder	<=	1'b0;   		
		
		//if (boarder)
		//	{vga_r, vga_g, vga_b} <= {8'hFF,8'hFF,8'hFF};
		//else
			//case (color_mode)
			//	4'b0001	:	{vga_r, vga_g, vga_b}	<=	{pixel_x,pixel_x,pixel_x};
			//	4'b0010	:	{vga_r, vga_g, vga_b}	<=	{8'h00,8'h00,8'h00};
			//	4'b0100	:	{vga_r, vga_g, vga_b}	<=	{pixel_x,pixel_x,pixel_x};
			//	4'b1000	:	{vga_r, vga_g, vga_b}	<=	{8'h00,8'h00,8'h00};
			//	default	:	{vga_r, vga_g, vga_b}	<=	{pixel_x,pixel_x,pixel_x};
			//endcase
	end
end	

endmodule