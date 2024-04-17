extends VehicleBody3D
class_name VehicleRoot

@onready var camera = $Camera3D

func _ready():
	edit()

func drive():
	camera.make_current()
	
	set_physics_process(true)
	set_freeze_enabled(false)

func edit():
	set_physics_process(false)
	set_freeze_enabled(true)

func _physics_process(delta):
	# Gas.
	if Input.is_key_pressed(KEY_W):
		set_engine_force(1000.0)
		set_brake(0.0)
	# Brake and reverse.
	elif Input.is_key_pressed(KEY_S):
		# Reverse.
		if get_linear_velocity().dot(get_transform().basis.z) < 2.0:
			set_engine_force(-200.0)
		# Brake.
		else:
			set_brake(2.0)
	else:
		set_engine_force(0.0)
		set_brake(0.0)
	
	# Steer.
	if Input.is_key_pressed(KEY_A):
		set_steering(lerp(get_steering(), PI/8.0, delta*4.0))
	elif Input.is_key_pressed(KEY_D):
		set_steering(lerp(get_steering(), -PI/8.0, delta*4.0))
	else:
		set_steering(lerp(get_steering(), 0.0, delta))
