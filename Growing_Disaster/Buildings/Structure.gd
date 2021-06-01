class_name Structure
extends Node2D

signal increase_strength()
signal shake()


export var grid: Resource = preload("res://Grid.tres")

var colors = [Color(0.25, 0.5, 0.5, 1.0), Color(0.25, 0.55, 0.5, 1.0), 
	Color(0.5, 0.25, 0.55, 1.0), Color(0.35, 0.55, 0.35)]
var cell := Vector2.ZERO setget set_cell
var destroyed:= false

func _ready() -> void:
	randomize()
	_on_ready()
	$Sprite.z_index = cell.y

func _process(delta: float) -> void:
	check_status()

func _on_ready() -> void:
	randomize()
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
# warning-ignore:return_value_discarded
	self.connect("increase_strength", get_parent(), "increase_player_strength") 
# warning-ignore:return_value_discarded
	self.connect("shake", get_parent(), "call_shake")
	$Sprite.modulate = colors[randi() % colors.size()]

func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)

func check_status() -> void:
	if not destroyed and grid.player_tail_tiles.has(cell):
		destroyed = true
		emit_signal("increase_strength")
		emit_signal("shake")
		$AnimationPlayer.play("destroy")
		yield($AnimationPlayer, "animation_finished")
		queue_free()
