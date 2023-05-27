@tool
extends Node
class_name SnapSurface

func _enter_tree():
	update_configuration_warnings()
	assert(get_parent() != get_tree().get_root(), "ERROR: Snap surface is a component and must be a child of another node.")

func _get_configuration_warnings():
	var warnings = PackedStringArray()
	
	# Node not being used as component.
	if self == get_tree().get_edited_scene_root():
		warnings.push_back("Snap surface is a component and must be a child of another node.")
	
	# TODO: Additional error checking when parent is not collidable?
	# There are both areas and bodies that are collidable.
	
	return warnings
