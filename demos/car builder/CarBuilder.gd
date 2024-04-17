extends Node3D

var build_mode = true

@onready var build_environment = $BuildEnvironment
@onready var toggle_mode = $BuildScreen/ToggleMode
@onready var pivot = $BuildPlatform/Pivot
@onready var build_camera = $BuildPlatform/Pivot/BuildCamera
@onready var module_buttons = $BuildScreen/ScrollContainer/HBoxContainer

var active_vehicle

func _ready():
	for button in module_buttons.get_children():
		button.connect("module_selected", Callable(self, "_on_module_selected"))

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

func _on_module_selected(module):
	var module_instance = module.instantiate()
	
	module_instance.set_position(Vector3(0, 1, 0))
	
	build_environment.add_child(module_instance)

func find_active_vehicle():
	# Get first vehicle found.
	var found = false
	for node in build_environment.get_children():
		if node is VehicleRoot:
			active_vehicle = node
			found = true
			break
	
	if not found:
		active_vehicle = null
		return null
	else:
		return active_vehicle

func set_build_mode():
	if find_active_vehicle() != null:
		build_camera.make_current()
		active_vehicle.edit()
	
		active_vehicle.set_transform(Transform3D())
		active_vehicle.set_position(Vector3(0, 1, 0))
	
		toggle_mode.text = "Drive!"

func set_drive_mode():
	if find_active_vehicle() != null:
		active_vehicle.drive()
		toggle_mode.text = "Edit"
