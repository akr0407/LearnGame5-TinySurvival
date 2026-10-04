extends StaticBody2D

var harvested = false
var resource_type = "stone"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func harvest() -> bool:
	if harvested:
		return false
		
	harvested = true
	print("Stone harvested")
	queue_free()
	return true
