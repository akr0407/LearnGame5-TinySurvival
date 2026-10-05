extends Node2D

@export var tree_scene: PackedScene
@export var campfire_scene: PackedScene
@export var food_scene: PackedScene
@export var enemy_scene: PackedScene

var resources = {
	"wood": 0,
	"stone": 0,
	"fiber": 0,
	"food": 0
}

var day = 1
var is_night =false

var tree_respawn_positions = []
var food_respawn_positions = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_day_label()
	update_day_night_visual()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_wood_label() -> void:
	$UI/WoodLabel.text = "Wood: " + str(resources["wood"])

func update_stone_label() -> void:
	$UI/StoneLabel.text = "Stone: " + str(resources["stone"])

func update_food_label() -> void:
	$UI/FoodLabel.text = "Food: " + str(resources["food"])

func update_day_label() -> void:
	if is_night:
		$UI/DayLabel.text = "Day: " + str(day) + " - Night"
	else:
		$UI/DayLabel.text = "Day: " + str(day) + " - Day"

func _on_tree_spawn_timer_timeout() -> void:
	var respawn_position = tree_respawn_positions.pop_front()
	
	var tree = tree_scene.instantiate()
	tree.position = respawn_position
	add_child(tree)

	if tree_respawn_positions.size() > 0:
		$TreeRespawnTimer.start()
	
func respawn_tree(spawn_position: Vector2) -> void:
	tree_respawn_positions.append(spawn_position)
	
	if tree_respawn_positions.size() > 0:
		$TreeRespawnTimer.start()
		print("Respawn position: ", tree_respawn_positions)


func _on_craft_button_pressed() -> void:
	if resources["wood"] >= 3 and resources["stone"] >= 2:
		resources["wood"] -= 3
		resources["stone"] -= 2
		
		update_wood_label()
		update_stone_label()
		
		var campfire = campfire_scene.instantiate()
		add_child(campfire)
		campfire.global_position = $Player.global_position
		
		print("campfire created")
	else:
		print("not enough resources")

func update_health_bar(current_health: int) -> void:
	$UI/HealthBar.value = current_health
	
func update_hunger_bar(current_hunger: int) -> void:
	$UI/HungerBar.value = current_hunger


func _on_food_respawn_timer_timeout() -> void:
	var respawn_position = food_respawn_positions.pop_front()

	var food = food_scene.instantiate()
	food.position = respawn_position
	add_child(food)

	if food_respawn_positions.size() > 0:
		$FoodRespawnTimer.start()

func respawn_food(spawn_position: Vector2) -> void:
	food_respawn_positions.append(spawn_position)

	if food_respawn_positions.size() > 0:
		$FoodRespawnTimer.start()

	print("Food respawn positions: ", food_respawn_positions)


func _on_day_timer_timeout() -> void:
	day += 1
	is_night = !is_night

	update_day_label()
	update_day_night_visual()

	if is_night:
		print("Night")
		spawn_enemy()
	else:
		print("Day")

func update_day_night_visual() -> void:
	if is_night:
		$DayNightModulate.color = Color(0.4, 0.4, 0.6)
	else:
		$DayNightModulate.color = Color(1, 1, 1)

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.position = Vector2(600, 300)
