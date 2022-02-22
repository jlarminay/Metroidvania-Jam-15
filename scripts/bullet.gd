extends Area2D

var lifetime = 10;
var damage = 10;
var speed = 100;
var dir = 1;

var velocity = Vector2(100,0);

func _ready():
	velocity = velocity * dir;

func _physics_process(delta):
	lifetime -= delta;
	if(lifetime<=0):
		queue_free();
	apply_physics(delta);

func apply_physics(delta):
	velocity = velocity.normalized() * speed;
	position += velocity * delta;

func _on_Area2D_body_entered(body):
	if(body.name=="TileMap"):
		queue_free();
	if(body.has_method("damage")):
		body.damage(global_position, damage);
		queue_free();
