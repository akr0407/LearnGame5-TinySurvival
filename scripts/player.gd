extends CharacterBody2D


const SPEED = 300.0

var nearby_object: Node2D = null

var max_health = 100
var health = 100
var max_hunger = 100
var hunger = 100
var can_attack = true
var near_campfire = false

func _physics_process(_delta: float) -> void:
	if get_parent().game_completed:
		velocity = Vector2.ZERO
		return
	
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
		
	if Input.is_action_just_pressed("eat"):
		eat()
	
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			attack()
	
	if Input.is_action_just_pressed("interact"):
		if nearby_object != null:
			if nearby_object.harvest():
				var resource_type = nearby_object.resource_type
				
				get_parent().resources[resource_type] += 1
				
				if resource_type == "wood":
					get_parent().update_wood_label()
					
				
				if resource_type == "wood":
					get_parent().respawn_tree(nearby_object.spawn_position)
					
				if resource_type == "stone":
					get_parent().update_stone_label()
				
				if resource_type == "food":
					get_parent().update_food_label()
					get_parent().respawn_food(nearby_object.spawn_position)
		
func _on_interaction_area_body_entered(body: Node2D) -> void:
	nearby_object = body


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if nearby_object == body:
		nearby_object = null

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)

	get_parent().update_health_bar(health)


	if health <= 0:
		die()

func die() -> void:
	set_physics_process(false)
	get_parent().show_game_over()


func _on_hunger_timer_timeout() -> void:
	if get_parent().game_completed:
		return
	
	if near_campfire:
		hunger -= 2
	elif get_parent().is_night:
		hunger -= 10
	else:
		hunger -= 5

	hunger = max(hunger, 0)
	get_parent().update_hunger_bar(hunger)

	if hunger <= 0:
		take_damage(5)


func eat() -> void:
	if get_parent().resources["food"] <= 0:
		return

	get_parent().resources["food"] -= 1

	hunger += 20
	hunger = min(hunger, max_hunger)

	get_parent().update_hunger_bar(hunger)



func _on_interaction_area_area_entered(area: Area2D) -> void:
	nearby_object = area


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Enemy in attack range")
	
func attack() -> void:
	can_attack = false

	var enemies = $AttackArea.get_overlapping_bodies()

	for enemy in enemies:
		if enemy.is_in_group("enemy"):
			enemy.take_damage(10)

	$AttackTimer.start()


func _on_attack_timer_timeout() -> void:
	can_attack = true
