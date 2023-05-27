@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("DragSnap", "res://addons/drag_and_snap/nodes/drag_snap.gd")
	
	add_custom_type("Draggable", "Node",
		preload("res://addons/drag_and_snap/nodes/draggable.gd"),
		null
	)
	add_custom_type("SnapPoint", "Area3D",
		preload("res://addons/drag_and_snap/nodes/snap_point.gd"),
		null
	)
	add_custom_type("SnapSurface", "Node",
		preload("res://addons/drag_and_snap/nodes/snap_surface.gd"),
		null
	)

func _exit_tree() -> void:
	remove_autoload_singleton("DragSnap")
	
	remove_custom_type("Draggable")
	remove_custom_type("SnapPoint")
	remove_custom_type("SnapSurface")
