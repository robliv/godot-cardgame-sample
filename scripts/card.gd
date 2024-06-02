extends Node2D

# Pickable needs to be selected from the inspector

var can_grab = false
var grabbed_offset = Vector2()

func _ready():
	print("card ready")

func _on_area_2d_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_area_2d_mouse_entered():
	scale = Vector2(1.1, 1.1)


func _on_area_2d_mouse_exited():
	scale = Vector2(1, 1)
