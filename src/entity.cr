class Entity 
  property x_pos : Int32, y_pos : Int32
  setter game : Game | Nil

  def initialize(x_pos : Int32, y_pos : Int32)
    @x_pos = x_pos
    @y_pos = y_pos
  end

  def name : String
    "entity"
  end

  def to_s : String
    "X"
  end

  def collide_with(entity : Entity) # when the player runs into this entity
    game.message = "#{self.name} ran into a #{entity.name}!"
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
    target_tile = game.get_tile(x, y)
    if !target_tile
      game.message = "You can't go there."
      return
    end

    target_entity = game.get_entity(x, y, self)
    if target_entity
      collide_with(target_entity)
      return
    end

    @x_pos = x
    @y_pos = y
  end

  private def game() Game
    # assign to a local variable so the compiler can be sure game won't change while this method's executing
    g = @game
    raise "You must set a game" if g.nil?
    g
  end
end

