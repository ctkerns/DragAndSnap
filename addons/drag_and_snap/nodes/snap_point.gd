@tool
extends Area3D
class_name SnapPoint

var _snap_shape: Shape3D
var _collision_shape: CollisionShape3D

@export var snap_shape: Shape3D:
	get:
		return _snap_shape
	set(shape):
		_snap_shape = shape
		update_collision_shape()

func _enter_tree():
	update_collision_shape()

func update_collision_shape():
	if _collision_shape == null:
		_collision_shape = CollisionShape3D.new()
		add_child(_collision_shape)
	_collision_shape.set_shape(_snap_shape)
