class Bullet < Joybox::Core::Sprite

  def initialize(opts={})
    super file_name: 'red_bullet.png', position: opts[:position], alive: true
  end

  def move(x, y)
    self.run_action Move.to position: [x, y], duration: 10
  end

end