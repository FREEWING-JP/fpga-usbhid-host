`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:06:00 08/24/2022 
// Design Name: 
// Module Name:    usb_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module usb_top(
	input CLK_50MHZ,
	input BTN_nRESET,
	inout usb_dp,
	inout usb_dm,
	output [7:0] NES_GAME_PAD,
	output NES_GAME_PAD_ENA,
	output [3:0] led
    );

	// Inputs
	wire clk_usb;
	wire clk_usb_fs;
	wire clk_usb_ls;
	wire reset = ~BTN_nRESET;
	wire USB_DDATA = 1'b0;

	// Outputs
	wire [63:0] HID_REPORT;
	wire HID_REPORT_SET;
	wire [7:0] dbg_step_ps3;
	wire [7:0] dbg_step_cmd;
	wire [7:0] LEDS;

// `define USB_FULL_SPEED

  dcm_usb_clock dcm_usb_clock
   (// Clock in ports
    .CLK_IN1(CLK_50MHZ),      // IN 50MHz
    // Clock out ports
    .CLK_OUT_LS(clk_usb_ls),     // OUT Low Speed
    .CLK_OUT_FS(clk_usb_fs));    // OUT Full Speed


`ifdef USB_FULL_SPEED
 assign clk_usb = clk_usb_fs;

`else
 assign clk_usb = clk_usb_ls;

`endif

// Instantiate the module
usbhid_host usbhid_host (
    .clk(clk_usb), 
    .reset(reset), 
    .USB_DATA({ usb_dp, usb_dm }), 
    .USB_DDATA(USB_DDATA), 
    .HID_REPORT(HID_REPORT), 
    .HID_REPORT_SET(HID_REPORT_SET), 
    .dbg_step_ps3(dbg_step_ps3), 
    .dbg_step_cmd(dbg_step_cmd), 
    .LEDS(LEDS)
    );

assign led = NES_GAME_PAD[7:4];

// NES = R,L,D,U,Sta,Sel,B,A
assign NES_GAME_PAD = { &HID_REPORT[7:6], ~|HID_REPORT[7:6], &HID_REPORT[15:14], ~|HID_REPORT[15:14], HID_REPORT[23], HID_REPORT[22], HID_REPORT[17], HID_REPORT[16] };
assign NES_GAME_PAD_ENA = HID_REPORT_SET;

/*
BUFFALO BSGP815GY iBuffalo Classic USB Gamepad for PC
http://www.neko.ne.jp/~freewing/hardware/nes_snes_pad/

LSB HID_REPORT[0]  L 00000000
MSB HID_REPORT[7]  R 11111111
 ~|HID_REPORT[7:6] L
 &HID_REPORT[7:6] R

LSB HID_REPORT[8]  U 00000000
MSB HID_REPORT[15] D 11111111
 ~|HID_REPORT[15:14] U
 &HID_REPORT[15:14] D

LSB HID_REPORT[16] A
    HID_REPORT[17] B
    HID_REPORT[18] X
    HID_REPORT[19] Y
    HID_REPORT[20] Left
    HID_REPORT[21] Right
    HID_REPORT[22] SELECT
MSB HID_REPORT[23] START

LSB HID_REPORT[24] 
    HID_REPORT[28] TURBO
    HID_REPORT[29] CLEAR
MSB HID_REPORT[31]
*/

endmodule
