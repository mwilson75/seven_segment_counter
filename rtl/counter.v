module seven_seg_counter #(parameter    MAX_CLOCK_COUNT = 25000000,
                                        COUNTER_LIMIT = 1599)
(
    input clk,
    input [3:0] SW,
    output [6:0] seven_seg1,
    output [6:0] seven_seg0,
    output [0:3] LED
);
reg[24:0] clock_counter;
reg[10:0] seg_counter;
wire [6:0] two_digit;
wire [3:0] tens, ones;
wire [6:0] seg0,seg1;

assign reset = | SW;
always @(posedge clk)begin
    if(reset | clock_counter >= MAX_CLOCK_COUNT-1)
        clock_counter <= 25'd0;
    else 
        clock_counter <= clock_counter + 25'd1;
    
end

assign seven_seg0 = seg0;
assign seven_seg1 = seg1;

always @(posedge clk) begin
    
    if(reset | seg_counter >= COUNTER_LIMIT)
        seg_counter <= 11'd0;
    else if(clock_counter >= MAX_CLOCK_COUNT-1)
        seg_counter <= seg_counter + 11'd1;
    else
        seg_counter <= seg_counter;
end

assign LED = seg_counter / 100;

assign two_digit = seg_counter % 100;
assign tens = two_digit / 10;
assign ones = two_digit % 10;

seven_seg_driver ones_inst (.number(ones),.display_out(seg0));
seven_seg_driver tens_inst (.number(tens),.display_out(seg1));

endmodule
