extends KinematicBody2D

var lifetime = 10;
var fall_speed = 30;
var fall_max = 1000;
var velocity;

var flash_time = 3;
var flash_cur = 0;
var flash_max = 0.33;
var flash_strong = false;

var rng = RandomNumberGenerator.new();

func _ready():
	#generate random dir
	rng.randomize();
	var rand_x = rng.randf_range(-300, 300);
	var rand_y = rng.randf_range(-400, -1000);
	velocity = Vector2(rand_x, rand_y);

func _physics_process(delta):
	if(Global.paused): return

	lifetime -= delta;
	if(lifetime<=0):
		queue_free();
	
	add_gravity(delta);
	flash(delta);

func add_gravity(delta):
	if(is_on_floor()):
		velocity.x = 0;
	
	velocity.y += fall_speed;
	if( velocity.y > fall_max ):
		velocity.y = fall_max;
	
	velocity = move_and_slide(velocity, Vector2.UP);

func flash(delta):
	if(lifetime <= flash_time):
		flash_cur += delta;
		if(flash_cur >= flash_max):
			flash_cur = 0;
			if(flash_strong):
				modulate.a = 0.6;
			else:
				modulate.a = 0.1;
			flash_strong = !flash_strong;

func _on_Area2D_body_entered(body):
	if(is_on_floor() && body.name=='player'):
		Global.coins += 1;
		queue_free();
