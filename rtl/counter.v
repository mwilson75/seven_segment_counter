`include "../seven_seg_driver/rtl/seven_seg_driver_decimal.v"
module seven_seg_counter
(
    input clk,
    input [3:0] SW,
    output reg[6:0] seven_seg1,
    output reg[6:0] seven_seg0,
    output [0:3] LED
);
reg[24:0] clock_counter;
wire[24:0] max_clock_count;
reg[10:0] seg_counter;
wire[10:0] max_seg_count;
wire [6:0] two_digit;
wire [3:0] tens, ones;
wire [6:0] seg0,seg1;
assign max_clock_count = 25'd2500000;
assign max_seg_count = 11'd1600;

assign reset = | SW;
always @(posedge clk)begin
    if(reset | clock_counter >= max_clock_count-1)
        clock_counter <= 25'd0;
    else 
        clock_counter <= clock_counter + 25'd1;
    
end

assign seven_seg0 = seg0;
assign seven_seg1 = seg1;

always @(posedge clk) begin
    
    if(reset | seg_counter >= max_seg_count-1)
        seg_counter <= 11'd0;
    else if(clock_counter >= max_clock_count-1)
        seg_counter <= seg_counter + 11'd1;
    else
        seg_counter <= seg_counter;
end

assign LED = seg_counter / 100;

assign two_digit = seg_counter % 100;
assign tens = two_digit / 10;
assign ones = two_digit % 10;

seven_seg_driver_decimal ones_inst (.number(ones),.display_out(seg0));
seven_seg_driver_decimal tens_inst (.number(tens),.display_out(seg1));

endmodule
