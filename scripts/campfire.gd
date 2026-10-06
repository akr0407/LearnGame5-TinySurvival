extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_warmth_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.near_campfire = true


func _on_warmth_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.near_campfire = false
