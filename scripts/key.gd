extends Area2D

func _on_key_body_entered(body):
	if( body.name == "player" ):
		Global.yellow_key = true;
		queue_free();
