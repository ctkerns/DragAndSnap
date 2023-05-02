@tool
extends RigidBody3D
class_name Draggable

# Drag and drop.
var _held = false
var _selector: Camera3D
var _tangent_plane

# Snapping.
@onready var _original_parent = get_parent()
@onready var _original_rotation = get_rotation()
var _snap_point = null

func _input_event(camera, event, _pos, _normal, _shape_idx):	
	# Start a new drag.
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_held = true
		_selector = camera
		
		# Create a plane tangent to the camera ray.
		_tangent_plane = Plane(-camera.get_global_transform().basis.z, get_global_position())

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _held:
		var selector_pos = _selector.get_global_position()
		var ray_normal = get_ray(_selector)
		var intersection = _tangent_plane.intersects_ray(selector_pos, ray_normal)
		if intersection != null:
			check_snap(selector_pos, ray_normal)
			if _snap_point == null:
				# Drag to new position.
				var target_motion = intersection - get_position()
				var collision = move_and_collide(target_motion, false)
			
				# Bootleg move_and_slide.
				if collision != null:
					move_and_collide(target_motion - target_motion.project(-collision.get_normal()))
	else:
		_held = false

func get_ray(selector: Camera3D) -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	return selector.project_ray_normal(mouse_pos)

func check_snap(from: Vector3, to: Vector3):
	# Setup query.
	var params = PhysicsRayQueryParameters3D.create(from, to*1000000.0)
	params.set_collide_with_areas(true)
	params.set_collide_with_bodies(false)
	# TODO: Set mask to snap point's collision mask to avoid interference.
	
	# Query point.
	var space_rid = get_world_3d().space
	var space_state = PhysicsServer3D.space_get_direct_state(space_rid)
	var collider = space_state.intersect_ray(params)
	
	# Found collision with snap point.
	if not collider.is_empty() and collider['collider'] is SnapPoint:
		if _snap_point == null:
			snap(collider['collider'])
	# No snap point collision found.
	else:
		unsnap()

func snap(point: SnapPoint):
	self.reparent(point)
	self.set_transform(Transform3D())
	_snap_point = point

func unsnap():
	self.reparent(_original_parent)
	self.set_rotation(_original_rotation)
	_snap_point = null
