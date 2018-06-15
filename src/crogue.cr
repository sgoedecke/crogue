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

class Entity 
  property x_pos : Int32, y_pos : Int32
  setter game : Game | Nil
  getter name : String

  def initialize(x_pos : Int32, y_pos : Int32)
    @x_pos = x_pos
    @y_pos = y_pos
    @name = "entity"
  end

  def to_s : String
    "X"
  end

  def move_up
    attempt_move(@x_pos, @y_pos - 1)
  end

  def move_down
    attempt_move(@x_pos, @y_pos + 1)
  end

  def move_right
    attempt_move(@x_pos + 1, @y_pos)
  end

  def move_left
    attempt_move(@x_pos - 1, @y_pos)
  end

  private def attempt_move(x : Int32, y : Int32)
    # assign to a local variable so the compiler can be sure game won't change while this method's executing
    game = @game

    raise "You must set a game" if game.nil?
    target_tile = game.get_tile(x, y)
    if !target_tile
      game.message = "You can't go there."
      return
    end

    target_entity = game.get_entity(x, y, self)
    if target_entity
      game.message = "You ran into a #{target_entity.name}!"
      return
    end

    @x_pos = x
    @y_pos = y
  end
end

class Player < Entity
  def to_s : String
    '@'.colorize.mode(:bold).to_s
  end
end

class Rock < Entity
  def to_s : String
    'O'.colorize.fore(:black).to_s
  end
end

class Tree < Entity
  def to_s : String
    'T'.colorize.fore(:green).to_s
  end
end

class Game
  getter :tiles, :width, :height
  setter :message

  def initialize
    @tiles = [] of Tile
    @entities = [] of Entity

    @message = "Welcome to the dungeon!"

    @width = 50
    @height = 10
    @player = Player.new(5, 5)
    @player.game = self
    @entities.push(@player)
    setup
  end

  def get_tile(x : Int32, y : Int32) Tile | Nil
    @tiles.find{ |t| t.x_pos == x && t.y_pos == y }
  end

  def get_entity(x : Int32, y : Int32, asker : Entity) Entity | Nil
    @entities.find{ |t| t.x_pos == x && t.y_pos == y && t != asker }
  end

  def setup
    @width.times do |w|
      @height.times do |h|
        @tiles.push(Tile.default(w, h)) 
      end
    end

    @entities.push(Rock.new(1,1))
    @entities.push(Tree.new(8,8))
  end

  def run 
    STDIN.raw do |io|
      io.read_timeout = nil 
      draw 

      while true
        char = io.read_char

        case char
        when 'q'
          break
        when 'w'
          @player.move_up
        when 's'
          @player.move_down
        when 'd'
          @player.move_right
        when 'a'
          @player.move_left
        end

        draw 
      end
    end
  end

  private def draw 
    screen = Array(Array(String)).new(@height) { Array(String).new(@width, "0") }
    @tiles.each do |t|
      screen[t.y_pos][t.x_pos] = t.to_s
    end

    @entities.each do |e|
      screen[e.y_pos][e.x_pos] = e.to_s
    end

    output = screen.map { |row| row.join("") }.join("\r\n")
    header = "Press WASD to move and q to exit\n\r"

    clear_screen
    puts header
    puts output 
    puts "\n\r" + @message + "\n\r"
  end

  private def clear_screen # placeholder
    puts "\n" * 10 + "\r"
  end
end

game = Game.new
game.run
puts "\r\nThanks for playing!"
