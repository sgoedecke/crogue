require "./entity"
require "./game_entities"
require "./tile"

class Game
  getter :tiles, :width, :height, :player
  setter :message
  property :entities

  def initialize
    @tiles = [] of Tile
    @entities = [] of Entity

    @message = "Welcome to the dungeon!"

    @width = 50
    @height = 10
    @player = Player.new(5, 5)
    add_entity(@player)
    load_map("maps/lv1.map")
  end

  def get_tile(x : Int32, y : Int32) Tile | Nil
    @tiles.find{ |t| t.x_pos == x && t.y_pos == y }
  end

  def get_entity(x : Int32, y : Int32, asker : Entity) Entity | Nil
    @entities.find{ |t| t.x_pos == x && t.y_pos == y && t != asker }
  end

  def load_map(file_path : String)
    max_x = 0
    max_y = 0

    raw_map = File.read_lines(file_path)
    raw_map.each_with_index do |row, y|
      max_y = y if max_y < y
      row.split("").each_with_index do |tile, x|
        max_x = x if max_x < x
        case tile
        when "#"
          add_entity(Door.new(x,y))
        when "O"
          add_entity(Rock.new(x,y))
        when "X"
          add_entity(Enemy.new(x,y))
        when "k"
          add_entity(Key.new(x,y))
        when "@"
          @player.x_pos = x
          @player.y_pos = y
        end

        if tile != " "
          @tiles.push(Tile.default(x, y)) 
        end
      end
    end

    @height = max_y
    @width = max_x
  end

  def end
    @playing = false
  end

  def run 
    STDIN.raw do |io|
      io.read_timeout = nil 
      draw
      @playing = true

      while @playing 
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

        @entities.each do |e|
          e.act
        end

        draw 
      end
    end
  end

  private def add_entity(e : Entity)
    @entities.push(e)
    e.game = self
  end

  private def draw 
    screen = Array(Array(String)).new(@height + 1) { Array(String).new(@width + 1, " ") }
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
