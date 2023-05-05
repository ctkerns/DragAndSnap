extends Node3D

var build_mode = true

@onready var vehicle = $Vehicle
@onready var toggle_mode = $BuildScreen/ToggleMode
@onready var pivot = $BuildPlatform/Pivot
@onready var build_camera = $BuildPlatform/Pivot/BuildCamera

@onready var start_position = vehicle.get_transform()

# Rotate build camera.
func _physics_process(delta):
	if Input.is_key_pressed(KEY_A):
		pivot.rotate_y(-delta*PI/4.0)
	if Input.is_key_pressed(KEY_D):
		pivot.rotate_y(delta*PI/4.0)

func _on_toggle_mode_pressed():
	build_mode = not build_mode
	if build_mode:
		call_deferred("set_build_mode")
	else:
		set_drive_mode()

func set_build_mode():
	build_camera.make_current()
	vehicle.edit()
	
	vehicle.set_transform(start_position)
	
	toggle_mode.text = "Drive!"

func set_drive_mode():
	vehicle.drive()
	toggle_mode.text = "Edit"
