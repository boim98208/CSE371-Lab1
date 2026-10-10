// keep track of cars up to 5 of a counter MEOW MEOW
module car_counter (clk, reset, enter, exit, count);
    input logic clk, reset, enter, exit;
    output logic [2:0] count;

    //sequential logic for count
    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3'b000;
        end else if (enter && count < 3'd5) begin
            count <= count + 3'b001;
        end else if (exit && count > 3'd0) begin
            count <= count - 3'b001;
        end
    end
endmodule 


module car_counter_testBench();
	logic clk, reset, enter, exit;
	logic [2:0] count;
	car_counter dut (clk, reset, enter, exit, count);
	
	initial begin
		clk = 0;
		forever #10 clk = ~clk;
	end
	
	
	integer i;
	initial begin
        reset = 1;
        enter = 0;
        exit  = 0;
        

        #25;
        reset = 0;
        
        //   car entering
        #20 enter = 1; #20 enter = 0;
        #20 enter = 1; #20 enter = 0;
        #20 enter = 1; #20 enter = 0;
		  #20 enter = 1; #20 enter = 0;
		  #20 enter = 1; #20 enter = 0;
        
        //  car exiting
        #20 exit = 1; #20 exit = 0;
		  #20 exit = 1; #20 exit = 0;
		  #20 exit = 1; #20 exit = 0;
		  #20 exit = 1; #20 exit = 0;
		  #20 exit = 1; #20 exit = 0;
		  #20 exit = 1; #20 exit = 0;
        
        #100;
        $finish;
		
	end
	
endmodule
	