require "./game"

class Crogue 
  def initialize
    @levels = Dir["maps/*"]
  end

  def run
    @levels.sort.each_with_index do |level, i|
      Game.new(level, "Level #{i+1}/#{@levels.size}").run
    end
    puts "\r\nThanks for playing!"
  end
end


Crogue.new.run
