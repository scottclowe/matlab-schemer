/* Sample Verilog code, which doesn't really do anything
 * but it does show syntax highlighting
 */
module main(inputVar, flip);
  input inputVar;
  input flip;

  reg flop;

  // Comment about dummy code which doesn't work
  always @(posedge flip or posedge inputVar)
    if (reset)
      begin
        flop <= (0 & ~inputVar);
      end
    else
      begin
        $display("Hello world!");
        $finish;
      end
endmodule
