/*
 * Generado con img2rom.html
 */

`default_nettype none

module palette (
    input  wire [1:0] color_index,
    output wire [5:0] rrggbb
);

  reg [5:0] palette[3:0];

  initial begin
    palette[0] = 6'b000000;  // #000000
    palette[1] = 6'b000000;  // #000000
    palette[2] = 6'b110001;  // #ff0055
    palette[3] = 6'b000111;  // #0055ff
  end

  assign rrggbb = palette[color_index];

endmodule
