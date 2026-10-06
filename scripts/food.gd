extends Area2D

var collected = false
var resource_type = "food"
var spawn_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func harvest() -> bool:
	if collected:
		return false
	
	collected = true
	queue_free()
	return true
