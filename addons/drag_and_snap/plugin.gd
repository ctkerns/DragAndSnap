@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("Draggable", "RigidBody3D",
		preload("res://addons/drag_and_snap/nodes/draggable.gd"),
		null
	)
	add_custom_type("SnapPoint", "Area3D",
		preload("res://addons/drag_and_snap/nodes/snap_point.gd"),
		null
	)

func _exit_tree() -> void:
	remove_custom_type("Draggable")
	remove_custom_type("SnapPoint")
