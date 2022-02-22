extends Node

export(float) var zoom = 1.5;

func _on_room_body_entered(body):
	if( body.name == "player" ):
		var h = $CollisionShape2D.shape.get_extents().y;
		var w = $CollisionShape2D.shape.get_extents().x;
		var p = $".".get_transform().get_origin();
		
		var t = p[1] - h;
		var b = p[1] + h;
		var r = p[0] + w;
		var l = p[0] - w;
		
		Global.set_current_room($".".get_parent().name);
		body.update_camera(t,r,b,l,zoom);
		
		#find all enemies
		var enemies = $".".get_parent().get_node_or_null("enemies");
		if(enemies):
			for enemy in enemies.get_children():
				enemy.spawn();


func _on_room_body_exited(body):
	if( body.name == "player" ):
		#find all enemies
		var enemies = $".".get_parent().get_node_or_null("enemies");
		if(enemies):
			for enemy in enemies.get_children():
				enemy.despawn();
