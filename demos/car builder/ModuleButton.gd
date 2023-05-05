extends Button

@export var module: PackedScene

@onready var sub_viewport = $SubViewportContainer/SubViewport

func _ready():
	if module != null:
		sub_viewport.add_child(module.instantiate())
