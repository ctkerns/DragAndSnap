@tool
extends Node
class_name Draggable

# Save state when snapping.
var _original_parent
var _original_rotation
var _snapped_to = null

func _enter_tree():
	# Ensure component is used correctly.
	update_configuration_warnings()

	assert(get_parent() != get_tree().get_root(), "ERROR: Draggable is a component and must be a child of another node.")
	
	assert(get_parent() is CollisionObject3D, "ERROR: Component must be applied to a CollisionObject3D derived node.")
	if not get_parent().is_connected("input_event", Callable(self, "_on_input_event")):
		get_parent().connect("input_event", Callable(self, "_on_input_event"))

func _ready():
	# Ensure component is used correctly.
	assert(get_parent().get_parent() != get_tree().get_root(), "ERROR: At runtime, a draggable object must be a child of another node.")

	# Save original state before any snapping occurs.
	_original_parent = get_parent().get_parent()
	_original_rotation = get_parent().get_rotation()

# Ensure component is used correctly.
func _get_configuration_warnings():
	var warnings = PackedStringArray()
	
	if self == get_tree().get_edited_scene_root():
		warnings.push_back("Draggable is a component and must be a child of another node.")

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

		if get_parent() is RigidBody3D:
			get_parent().set_freeze_enabled(true)

func is_snapped():
	return _snapped_to != null

func set_snapped(snapped_to):
	_snapped_to = snapped_to

func get_original_parent():
	return _original_parent

func get_original_rotation():
	return _original_rotation
