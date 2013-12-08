class Enemy < Joybox::Core::Sprite

  def initialize(opts={})
    super file_name: opts[:file], position: [Screen.width / 2, Screen.height / 2], alive: true
  end

  def spawn_location

  end

  def move_to_location

  end

end