extends CharacterBody2D

signal defeated

var health = 20
var player_in_range = false

const SPEED = 50.0

func _ready() -> void:
	add_to_group("enemy")
	
func _physics_process(_delta: float) -> void:
	check_day_state()

	var main = get_parent()

	if not main.is_night:
		velocity = Vector2.ZERO
		return

	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var direction = global_position.direction_to(player.global_position)

	velocity = direction * SPEED

	move_and_slide()


func check_day_state() -> void:
	var main = get_parent()

	if not main.is_night:
		queue_free()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		$DamageTimer.start()

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		$DamageTimer.stop()
		
func _on_damage_timer_timeout() -> void:
	if player_in_range:
		var player = get_tree().get_first_node_in_group("player")

		if player != null:
			player.take_damage(10)

func take_damage(amount: int) -> void:
	health -= amount

	print("enemy health: ", health)

	if health <= 0:
		defeated.emit(self)
		queue_free()
