extends CharacterBody2D


const SPEED = 300.0

var nearby_object: Node2D = null

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	
	direction = direction.normalized()
	
	velocity = direction * SPEED
	
	move_and_slide()

	if Input.is_action_just_pressed("interact"):
		if nearby_object != null:
			print("Interacting with ", nearby_object)
			if nearby_object.harvest():
				get_parent().resources["wood"] += 1
				get_parent().update_wood_label()
				get_parent().respawn_tree(nearby_object.spawn_position)
				print("Wood: ", get_parent().wood)
		
func _on_interaction_area_body_entered(body: Node2D) -> void:
	nearby_object = body
	print(nearby_object)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if nearby_object == body:
		nearby_object = null
		print(nearby_object)
