extends Button

@export var module: PackedScene

@onready var sub_viewport = $SubViewportContainer/SubViewport

signal module_selected(module)

func _ready():
	prep_module()

func prep_module():
	if module != null:
		tooltip_text = module.get_state().get_node_name(0)
		var module_instance = module.instantiate()
		call_deferred("finish_module", module_instance)

func finish_module(module_instance):
	var bounds = calculate_spatial_bounds(module_instance, false)
	
	module_instance.scale /= max(bounds.size.x, bounds.size.y, bounds.size.z)
	
	sub_viewport.add_child(module_instance)
	
	if module_instance is RigidBody3D:
		module_instance.set_freeze_enabled(true)

func _on_button_down():
	emit_signal("module_selected", module)

# Do not call this on ready.
func calculate_spatial_bounds(parent : Node3D, exclude_top_level_transform: bool) -> AABB:
	var bounds : AABB = AABB()
	
	if parent is VisualInstance3D:
		bounds = parent.get_aabb()
	
	for child in parent.get_children():
		if child is Node3D:
			var child_bounds : AABB = calculate_spatial_bounds(child, false)
			
			if bounds.size == Vector3.ZERO:
				bounds = child_bounds
			else:
				bounds.merge(child_bounds)
	
	if bounds.size == Vector3.ZERO && !parent:
		bounds = AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4))
	
	if !exclude_top_level_transform:
		bounds = parent.get_transform()*bounds
	
	return bounds
