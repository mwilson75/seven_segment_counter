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
    if(reset | clock_counter >= max_clock_count)
        clock_counter <= 25'd0;
    else 
        clock_counter <= clock_counter + 25'd1;
    
end

always @(posedge clk) begin
    seven_seg0 <= seg0;
    seven_seg1 <= seg1;
end

always @(posedge clk) begin
    
    if(reset | seg_counter >= max_seg_count)
        seg_counter <= 11'd0;
    else if(clock_counter >= max_clock_count)
        seg_counter <= seg_counter + 11'd1;
    else
        seg_counter <= seg_counter;
end

assign LED = seg_counter / 100;

assign two_digit = seg_counter % 100;
assign tens = two_digit / 10;
assign ones = two_digit % 10;

get_seven_seg ones_inst (.digit(ones),.seg_out(seg0));
get_seven_seg tens_inst (.digit(tens),.seg_out(seg1));
/* 
always @(*) begin
    
end
*/

endmodule

module get_seven_seg(
    input [3:0] digit,
    output reg[6:0] seg_out
);
always@(*) begin
    seg_out = 7'd1;
    case(digit)
        4'h1 : seg_out = 7'b1001111;
        4'h2 : seg_out = 7'b0010010;
        4'h3 : seg_out = 7'b0000110;
        4'h4 : seg_out = 7'b1001100;
        4'h5 : seg_out = 7'b0100100;
        4'h6 : seg_out = 7'b0100000;
        4'h7 : seg_out = 7'b0001111;
        4'h8 : seg_out = 7'b0000000;
        4'h9 : seg_out = 7'b0001100;
        4'h0 : seg_out = 7'b0000001;
    endcase
end

endmodule