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
  end
end

class Key < Entity
  def to_s : String
    'k'.colorize.fore(:yellow).to_s
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

class Door < Entity
  def to_s : String
    '#'.colorize.fore(:yellow).mode(:bold).to_s
  end
end
