require "colorize"
require "./entity"

class Player < Entity
  def to_s : String
    '@'.colorize.mode(:bold).to_s
  end

  def name
    "you"
  end

  def collide_with(entity : Entity) # when the player runs into another entity
    game.message = "You wonder why you keep walking into things..."
  end
end

class Rock < Entity
  def to_s : String
    'O'.colorize.fore(:black).to_s
  end

  def name
    "rock"
  end
end

class Tree < Entity
  def to_s : String
    'T'.colorize.fore(:green).to_s
  end

  def name
    "tree"
  end
end
