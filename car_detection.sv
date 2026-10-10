module car_detection (clk, reset, outer, inner, enter, exit);
    input logic clk, reset, outer, inner;
    output logic enter, exit;
// 00, 10, 11, 01, 00 for entry
// 00, 01, 11, 10, 00 for exit

    typedef enum logic [2:0] {
        NOTHING,
        E10,
        E11,
        E01,
        X01,
        X11,
        X10,
        WAIT00
    } statetype;

    statetype ns;

    always_ff @(posedge clk) begin
        if (reset) begin
            ns <= NOTHING;
            enter <= 1'b0;
            exit  <= 1'b0;
        end else begin
            enter <= 1'b0;
            exit  <= 1'b0;

            case (ns)
                NOTHING: begin
                    if ({outer, inner} == 2'b10)
                        ns <= E10;
                    else if ({outer, inner} == 2'b01)
                        ns <= X01;
                    else if ({outer, inner} == 2'b11)
                        ns <= WAIT00;
                end

                // car entering the lot
                E10: begin
                    if ({outer, inner} == 2'b11)
                        ns <= E11;
                    else if ({outer, inner} == 2'b00 || {outer, inner} == 2'b01)
                        ns <= NOTHING;
                end

                E11: begin
                    if ({outer, inner} == 2'b01)
                        ns <= E01;
                    else if ({outer, inner} == 2'b10)
                        ns <= E10;
                    else if ({outer, inner} == 2'b00)
                        ns <= NOTHING;
                end

                E01: begin
                    if ({outer, inner} == 2'b11)
                        ns <= E11; // goes back if rocking
                    else if ({outer, inner} == 2'b00) begin
                        ns <= NOTHING;
                        enter <= 1'b1; // output actually goes out
                    end else if ({outer, inner} == 2'b10)
                        ns <= NOTHING;
                end

                // car exiting the lot
                X01: begin
                    if ({outer, inner} == 2'b11)
                        ns <= X11;
                    else if ({outer, inner} == 2'b00 || {outer, inner} == 2'b10)
                        ns <= NOTHING;
                end

                X11: begin
                    if ({outer, inner} == 2'b10)
                        ns <= X10;
                    else if ({outer, inner} == 2'b01)
                        ns <= X01;
                    else if ({outer, inner} == 2'b00)
                        ns <= NOTHING;
                end

                X10: begin
                    if ({outer, inner} == 2'b11)
                        ns <= X11; // goes back if rocking
                    else if ({outer, inner} == 2'b00) begin
                        ns <= NOTHING;
                        exit <= 1'b1; 
                    end else if ({outer, inner} == 2'b01)
                        ns <= NOTHING;
                end

                WAIT00: begin
                    if ({outer, inner} == 2'b00)
                        ns <= NOTHING;
                end

                default: ns <= NOTHING;
            endcase
        end
    end

endmodule 


module car_detection_testBench();
	logic clk, reset, outer, inner;
	logic enter, exit;
	
	car_detection dut (clk, reset, outer, inner, enter, exit);
	
	initial begin
		clk = 0;
		forever #10 clk = ~clk;
	end
	
	initial begin
		reset = 1;
		outer = 0;
		inner = 0;
		
		#25;
		reset = 0;
		
		// entry
		#20 outer = 1; inner = 0;
		#20 outer = 1; inner = 1;
		#20 outer = 0; inner = 1;
		#20 outer = 0; inner = 0;
		#40;
		
		// exit
		#20 outer = 0; inner = 1;
		#20 outer = 1; inner = 1;
		#20 outer = 1; inner = 0;
		#20 outer = 0; inner = 0;
		#40;
		
		// funky entry sequence
		#20 outer = 1; inner = 0;
		#20 outer = 1; inner = 1;
		#20 outer = 0; inner = 1;
		#20 outer = 1; inner = 1;
		#20 outer = 0; inner = 1;
		#20 outer = 0; inner = 0;
		#40;
		
		// funky exit sequence
		#20 outer = 0; inner = 1;
		#20 outer = 1; inner = 1;
		#20 outer = 1; inner = 0;
		#20 outer = 1; inner = 1;
		#20 outer = 1; inner = 0;
		#20 outer = 0; inner = 0;
		#40;
		
		// bad sequences
		#20 outer = 1; inner = 1;
		#20 outer = 0; inner = 1;
		#20 outer = 1; inner = 0;
		#20 outer = 0; inner = 0;
		#40;
		

		#20 outer = 1; inner = 0;
		#20 outer = 0; inner = 1;
		#20 outer = 0; inner = 0;
		#40;
		
		#100;
		$finish;
	end
endmodule
