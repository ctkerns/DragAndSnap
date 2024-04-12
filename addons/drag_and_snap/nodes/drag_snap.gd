extends Node

# Save the state of a drag event.
var _held = false
var _selector: Camera3D
var _dragged_object
var _tangent_plane

# Start a new drag.
func start_drag(selector, dragged_object):
	_held = true
	_selector = selector
	_dragged_object = dragged_object

	update_tangent_plane(_dragged_object.get_global_position())

# Move the dragged object.
func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _held:
		# Find location the mouse is pointing at.
		var selector_pos = _selector.get_global_position()
		var ray_normal = get_ray(_selector)
		update_tangent_plane()
		var intersection = _tangent_plane.intersects_ray(selector_pos, ray_normal)

		# Snap or drag the object.
		if intersection != null:
			check_snap(selector_pos, ray_normal)
			if not _dragged_object.find_child("Draggable").is_snapped():
				if _dragged_object is PhysicsBody3D:
					move_with_physics(intersection - _dragged_object.get_position())
				else:
					_dragged_object.set_position(intersection)

	else:
		_held = false

# Move a draggable object using physics.
func move_with_physics(target_motion):
	# Drag to new position.
	var collision = _dragged_object.move_and_collide(target_motion, false)

	# Bootleg move_and_slide.
	if collision != null:
		_dragged_object.move_and_collide(target_motion - target_motion.project(-collision.get_normal()))

# Create a plane the drag is locked to or update the orientation of the existing plane.
func update_tangent_plane(starting_position = null):
	# Normal direction the selecing camera is facing.
	var direction = -_selector.get_global_transform().basis.z

	# Update the orientation keeping a consistent distance from the camera.
	if starting_position == null:
		var distance = _tangent_plane.distance_to(_selector.get_global_position())
		starting_position = _selector.get_global_position() + direction*distance
	
	_tangent_plane = Plane(direction, starting_position)

func get_ray(selector: Camera3D) -> Vector3:
	var mouse_pos = selector.get_viewport().get_mouse_position()
	return selector.project_ray_normal(mouse_pos)

# Check if snap is possible, then snap/unsnap.
func check_snap(from: Vector3, to: Vector3):
	# Setup query.
	var params = PhysicsRayQueryParameters3D.create(from, to*1000000.0)
	params.set_collide_with_areas(true)
	params.set_exclude([_dragged_object.get_rid()])
	# TODO: Set mask to snap point's collision mask to avoid interference?
	
	# Query point.
	var space_rid = _selector.get_world_3d().space
	var space_state = PhysicsServer3D.space_get_direct_state(space_rid)
	var collider = space_state.intersect_ray(params)
	
	# Found collision with snap point.
	if not collider.is_empty() and collider['collider'] is SnapPoint:
		if not _dragged_object.find_child("Draggable").is_snapped():
			snap_to_point(collider['collider'])
	# Found collision with snap surface.
	elif not collider.is_empty() and collider['collider'].find_child("SnapSurface") is SnapSurface:
		snap_to_surface(collider['collider'].find_child("SnapSurface"), collider['position'], collider['normal'])
	# No snap point collision found.
	elif _dragged_object.find_child("Draggable").is_snapped():
		unsnap()

func snap_to_point(point: SnapPoint):
	# Double check the snap point is not a descendent of the dragged object.
	if _dragged_object.is_ancestor_of(point):
		return

	_dragged_object.reparent(point.get_parent())
	_dragged_object.set_transform(point.get_transform())

	_dragged_object.find_child("Draggable").set_snapped(point)

func snap_to_surface(surface: SnapSurface, position, normal):
	# Double check the snap surface is not a descendent of the dragged object.
	if _dragged_object.is_ancestor_of(surface):
		return
	
	var new_parent = surface.get_parent()
	if _dragged_object.get_parent() != new_parent:
		_dragged_object.reparent(new_parent)
	
	# Reposition dragged object so it's up vector is parallel to the collision normal.
	var angle = normal.angle_to(Vector3.UP)
	var pivot = normal.cross(Vector3.UP).normalized()
	_dragged_object.global_transform = Transform3D(Basis(pivot, -angle), position)
	
	_dragged_object.find_child("Draggable").set_snapped(surface)

func unsnap():
	_dragged_object.reparent(_dragged_object.find_child("Draggable").get_original_parent())
	_dragged_object.set_rotation(_dragged_object.find_child("Draggable").get_original_rotation())

	_dragged_object.find_child("Draggable").set_snapped(null)
