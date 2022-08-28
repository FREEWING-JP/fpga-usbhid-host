`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   22:39:11 08/23/2022
// Design Name:   usbhid_host
// Module Name:   usbhid_host_tb.v
// Project Name:  fpga-usbhid-host
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: usbhid_host
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module usbhid_host_tb;

	// Inputs
	reg clk;
	reg reset;
	reg USB_DDATA;

	// Outputs
	wire [63:0] HID_REPORT;
	wire [7:0] dbg_step_ps3;
	wire [7:0] dbg_step_cmd;
	wire [7:0] LEDS;

	// Bidirs
	wire [1:0] USB_DATA_INP;
	wire [1:0] USB_DATA_BI;
	reg  [1:0] USB_DATA_OUT;
	wire        USB_OUT_VALID;

	// Instantiate the Unit Under Test (UUT)
	usbhid_host uut (
		.clk(clk),
		.reset(reset),
		.USB_DATA(USB_DATA_BI),
		.USB_DDATA(USB_DDATA),
		.HID_REPORT(HID_REPORT),
		.dbg_step_ps3(dbg_step_ps3),
		.dbg_step_cmd(dbg_step_cmd),
		.LEDS(LEDS)
	);


assign USB_OUT_VALID = (dbg_step_ps3 == 8'd3) || (dbg_step_ps3 == 8'd5);
assign USB_DATA_INP = USB_DATA_BI;
assign USB_DATA_BI = (USB_OUT_VALID == 1'b1)? USB_DATA_OUT : 2'hZZ;

   parameter   P_CLOCK_FREQ = 1000.0 / 7.5; // 7.5MHz
//   parameter   P_CLOCK_FREQ = 1000.0 / 60.0; // 7.5MHz

    always #(P_CLOCK_FREQ/2) begin
        clk <= ~clk;
    end

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		USB_DDATA = 0;
//		USB_OUT_VALID = 0;
		USB_DATA_OUT = 2'b00; // USB_DATA(1)=D+ USB_DATA(0)=D-

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		#200;
		reset = 0;

		#500;
//		USB_OUT_VALID = 1;
		USB_DATA_OUT = 2'b01; // USB_DATA(1)=D+ USB_DATA(0)=D- LOW
//		USB_DATA_OUT = 2'b10; // USB_DATA(1)=D+ USB_DATA(0)=D- FULL
		#9500;
//		USB_OUT_VALID = 0;

		// Add stimulus here

	end

endmodule

