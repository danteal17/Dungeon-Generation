extends Node2D

var d = 35




func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		position.y += -1 * d
	if Input.is_action_just_pressed("ui_down"):
		position.y += 1* d
	if Input.is_action_just_pressed("ui_right"):
		position.x += 1* d
	if Input.is_action_just_pressed("ui_left"):
		position.x += -1* d
	
