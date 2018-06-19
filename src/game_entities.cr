require "colorize"
require "./entity"

class Player < Entity
  def initialize(*args)
    super(*args)
    @has_key = false
  end

  def to_s : String
    if @has_key
      '@'.colorize.fore(:yellow).mode(:bold).to_s
    else
      '@'.colorize.mode(:bold).to_s
    end
  end

  def name
    "you"
  end

  def collide_with(entity : Entity) # when the player runs into another entity
    game.message = "You wonder why you keep walking into things..."
    if entity.is_a?(Key)
      @has_key = true
      game.message = "You picked up the key!"
      entity.destroy
    end

    if entity.is_a?(Door)
      if @has_key
        game.message = "You unlock the door and leave the dungeon!"
        game.end
      else
        game.message = "The exit is locked."
      end
    end

    if entity.is_a?(Enemy)
      game.message = "Ouch! You were killed by a goblin."
      game.end
    end
  end
end

class Key < Entity
  def to_s : String
    'k'.colorize.fore(:yellow).to_s
  end
end

class Rock < Entity
  def to_s : String
    'O'.colorize.fore(:black).mode(:dim).to_s
  end
end

class Door < Entity
  def to_s : String
    '#'.colorize.fore(:yellow).mode(:bold).to_s
  end
end

class Enemy < Entity
  def to_s : String
    'X'.colorize.fore(:red).mode(:bold).to_s
  end

  def act
    if game.player.y_pos < y_pos
      move_up
    else
      move_down
    end
    if game.player.x_pos < x_pos
      move_left
    else
      move_right
    end
  end

  def collide_with(entity : Entity) # when the current entity runs into another entity
    if entity.is_a? Player
      game.message = "Ouch! You were killed by a goblin."
      game.end
    end
  end
end
