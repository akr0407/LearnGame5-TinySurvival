extends CharacterBody2D


const SPEED = 300.0

var nearby_object: Node2D = null

var max_health = 100
var health = 100

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
	
	if Input.is_action_just_pressed("test_damage"):
		take_damage(10)
	
	if Input.is_action_just_pressed("interact"):
		if nearby_object != null:
			print("Interacting with ", nearby_object)
			if nearby_object.harvest():
				var resource_type = nearby_object.resource_type
				
				get_parent().resources[resource_type] += 1
				
				if resource_type == "wood":
					get_parent().update_wood_label()
					
				print(resource_type, ": ", get_parent().resources[resource_type])
				
				if resource_type == "wood":
					get_parent().respawn_tree(nearby_object.spawn_position)
					
				if resource_type == "stone":
					get_parent().update_stone_label()
		
func _on_interaction_area_body_entered(body: Node2D) -> void:
	nearby_object = body
	print(nearby_object)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if nearby_object == body:
		nearby_object = null
		print(nearby_object)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)

	get_parent().update_health_bar(health)

	print("Health: ", health)

	if health <= 0:
		die()

func die() -> void:
	print("Player died!")
	set_physics_process(false)
