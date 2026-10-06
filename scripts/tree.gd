extends StaticBody2D

var harvested = false
var spawn_position = Vector2.ZERO
var resource_type = "wood"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func harvest() -> bool:
	if harvested:
		return false
	
	harvested = true
	queue_free()
	return true
