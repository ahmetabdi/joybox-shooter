class GameLayer < Joybox::Core::Layer
  scene
  GLOBAL_ATTACK_SPEED = 5
  def on_enter

    start
    init_lives
    init_enemys

    schedule_update do |dt|
      shoot_rockets
      check_within_width_bounds(@ship)
      @timer = @timer + 1
      check_for_collisions if @ship[:alive]
    end

    handle_touches
  end

  def check_for_collisions
    # Iterate through every asteroid in the screen
    @bullets.each do |bullet|
      # Check if it's bounding box intersects with the rocket
      if CGRectIntersectsRect(bullet.bounding_box, @enemy.bounding_box) and @enemy[:alive]
        @enemy[:alive] = false
        self.removeChild(@enemy)
      end
    end
  end

  def start
    background = Sprite.new file_name: 'bg.png', position: Screen.center
    self << background
    @ship = Sprite.new file_name: 'ship.png', position: [Screen.half_width, 50], alive: true, speed: 1
    self << @ship
    @bullets ||= Array.new
    @timer = 0
  end

  def init_lives
    5.times do |x|
      live = Sprite.new file_name: 'heart.png', position: [30 * x - 10, Screen.height - 35] if x > 0
      self << live
    end
  end

  def init_enemys
    @enemy = Enemy.new(file: 'enemy1.png')
    self << @enemy
  end

  def check_within_width_bounds(object)
    if object.position.x > Screen.width
      object.position = [Screen.width, 50]
    elsif object.position.x < 0
      object.position = [0, 50]
    end
  end

  def shoot_rockets
    if @timer % GLOBAL_ATTACK_SPEED == 0 # needed some form of timer
      @l_bullet = Bullet.new(position: [@ship.position.x - 25, @ship.position.y + 15])
      @r_bullet = Bullet.new(position: [@ship.position.x + 25, @ship.position.y + 15])
      self << @l_bullet
      self << @r_bullet
      @bullets << @l_bullet
      @bullets << @r_bullet
      check_reached_top_of_screen
    end
  end

  def check_reached_top_of_screen
    @bullets.each do |bullet|
      if bullet[:alive]
       bullet.move(bullet.position.x, bullet.position.y + Screen.height)
       bullet[:alive] == false
      end
      if bullet.position.y > Screen.height
        self.removeChild(bullet)
      end
    end
  end

  def handle_touches
    on_touches_began do |touches, event|
      touch = touches.any_object
      if @ship[:alive] == true
        @ship.run_action Move.to position: [touch.location.x, 50], duration: 0.5
      else
        break
      end
    end
  end

end