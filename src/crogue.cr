require "./entity"
require "./game_entities"
require "./tile"

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
