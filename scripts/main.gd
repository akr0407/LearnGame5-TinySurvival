extends Node2D

@export var tree_scene: PackedScene

var wood = 0
var tree_spawn_position = Vector2(200, 150)
var tree_respawn_positions = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_wood_label() -> void:
	$UI/WoodLabel.text = "Wood: " + str(wood)


func _on_tree_spawn_timer_timeout() -> void:
	var respawn_position = tree_respawn_positions.pop_front()
	
	var tree = tree_scene.instantiate()
	add_child(tree)
	tree.position = respawn_position

	if tree_respawn_positions.size() > 0:
		$TreeRespawnTimer.start()
	
func respawn_tree(spawn_position: Vector2) -> void:
	tree_respawn_positions.append(spawn_position)
	
	if tree_respawn_positions.size() > 0:
		$TreeRespawnTimer.start()
		print("Respawn position: ", tree_respawn_positions)
