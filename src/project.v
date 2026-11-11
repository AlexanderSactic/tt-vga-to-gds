/*
 * Generado con img2rom.html, modo experimental
 * Imagen estatica 640x480, 2 bits por pixel.
 * No cabe en una tile: solo para simular en VGA Playground.
 */

`default_nettype none

// verilator lint_off WIDTH

parameter DISPLAY_WIDTH = 640;
parameter DISPLAY_HEIGHT = 480;

module tt_um_alexsactic_vgaimage (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  localparam LOGO_WIDTH  = 640;
  localparam LOGO_HEIGHT = 480;
  localparam LOGO_LEFT   = (DISPLAY_WIDTH - LOGO_WIDTH) / 2;
  localparam LOGO_TOP    = (DISPLAY_HEIGHT - LOGO_HEIGHT) / 2;

  // VGA signals
  wire hsync;
  wire vsync;
  reg [1:0] R;
  reg [1:0] G;
  reg [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  // TinyVGA PMOD
  assign uo_out  = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  assign uio_out = 0;
  assign uio_oe  = 0;

  wire _unused_ok = &{ena, ui_in, uio_in};

  hvsync_generator vga_sync_gen (
      .clk(clk),
      .reset(~rst_n),
      .hsync(hsync),
      .vsync(vsync),
      .display_on(video_active),
      .hpos(pix_x),
      .vpos(pix_y)
  );

  wire [9:0] logo_left = LOGO_LEFT;
  wire [9:0] logo_top  = LOGO_TOP;
  wire [9:0] x = pix_x - logo_left;
  wire [9:0] y = pix_y - logo_top;
  wire in_display = (pix_x < DISPLAY_WIDTH) && (pix_y < DISPLAY_HEIGHT);
  wire logo_area  = (x < LOGO_WIDTH) && (y < LOGO_HEIGHT);

  wire [1:0] pixel_index;
  wire [5:0] color;

  bitmap_rom rom1 (
      .x(x),
      .y(y),
      .pixel(pixel_index)
  );

  palette palette_inst (
      .color_index(pixel_index),
      .rrggbb(color)
  );

  // RGB output logic
  always @(posedge clk) begin
    if (~rst_n) begin
      R <= 0;
      G <= 0;
      B <= 0;
    end else begin
      R <= 0;
      G <= 0;
      B <= 0;
      if (video_active && in_display && logo_area) begin
        R <= color[5:4];
        G <= color[3:2];
        B <= color[1:0];
      end
    end
  end

endmodule
