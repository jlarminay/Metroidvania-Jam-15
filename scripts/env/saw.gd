extends Area2D

func _process(delta):
	rotation_degrees += 60 * delta;


func _on_saw_body_entered(body):
	if( body.name == "player" ):
		body.die();
