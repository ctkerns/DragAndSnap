@tool
extends Node
class_name Draggable

# Snapping.
var _original_parent
var _original_rotation
var _snap_point = null

func _enter_tree():
	update_configuration_warnings()
	
	assert(get_parent() is CollisionObject3D, "Component must be applied to a CollisionObject3D derived node.")
	if not get_parent().is_connected("input_event", Callable(self, "_on_input_event")):
		get_parent().connect("input_event", Callable(self, "_on_input_event"))

func _ready():
	# At run time, a draggable object can not be the scene root.
	assert(get_parent().get_parent() != null, "ERROR: At runtime, a draggable object can not be the scene root.")

	# For snapping.
	_original_parent = get_parent().get_parent()
	_original_rotation = get_parent().get_rotation()

func _get_configuration_warnings():
	var warnings = PackedStringArray()
	
	# Parent is not the correct type.
	if not get_parent() is CollisionObject3D:
		warnings.push_back("Component must be applied to a CollisionObject3D derived node.")
	
	# Name has been changed.
	if get_name() != "Draggable":
		warnings.push_back("Component must be named \"Draggable\"")
	
	return warnings

func _on_input_event(camera, event, _position, _normal, _shape_idx):
	# Start a new drag.
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		DragSnap.start_drag(camera, get_parent())

func is_snapped():
	return _snap_point != null

func set_snap_point(snap_point):
	_snap_point = snap_point

func get_original_parent():
	return _original_parent

func get_original_rotation():
	return _original_rotation
