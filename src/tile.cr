require "colorize"

class Tile
  getter :x_pos, :y_pos

  def initialize(char : String, x_pos : Int32, y_pos : Int32, color : Symbol, bg_color : Symbol, mode : Symbol)
    @char = char
    @x_pos = x_pos
    @y_pos = y_pos
    @color = color
    @bg_color = bg_color
    @mode = mode
  end

  def to_s : String
    @char.colorize.fore(@color).back(@bg_color).mode(@mode).to_s
  end

  def self.default(w : Int32, h : Int32)
    new(" ", w, h, :white, :white, :dim)
  end
end
