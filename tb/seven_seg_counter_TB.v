module seven_seg_counter_TB();
parameter   ZERO = 7'b0000001,  // 1
            ONE = 7'b1001111,   // 79   
            TWO = 7'b0010010,   // 18
            THREE = 7'b0000110, // 6
            FOUR = 7'b1001100,  // 76
            FIVE = 7'b0100100,  // 36
            SIX = 7'b0100000,   // 32
            SEVEN = 7'b0001111, // 15
            EIGHT = 7'b0000000, // 0
            NINE = 7'b0001100;  // 12

parameter [6:0] SEG_ARRAY [0:9] = {ZERO,ONE,TWO,
                                    THREE,FOUR,FIVE,SIX,
                                    SEVEN,EIGHT,NINE};
reg clk = '0, SW = '1;

wire [6:0] ones_display, tens_display;
reg[6:0] two_digit;
wire[3:0] LED;

seven_seg_counter UUT
(
    .clk(clk),
    .SW(SW),
    .seven_seg1(tens_display),
    .seven_seg0(ones_display),
    .LED(LED)
);

always #5 clk = ~clk;
integer cnt  = 0;
initial begin
    $dumpfile("dump.vcd");$dumpvars;
 
    #10;
    SW <= '0;
    repeat(1650) begin
        @(posedge clk);
        cnt = cnt + 1;
        if(cnt > 1599)
            cnt = 0;
        #1;
        assert(LED == cnt/ 100);
        two_digit = cnt % 100;
        assert(tens_display == SEG_ARRAY[two_digit / 10]);
        assert(ones_display == SEG_ARRAY[two_digit % 10]);
    end
    $finish(); 


end
endmodule