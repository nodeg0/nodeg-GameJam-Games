extends "res://Buildings/Structure.gd"

var point_a:= Vector2.ZERO
var point_b:= Vector2.ZERO

onready var B_location:= $Position2D

func _on_ready() -> void:
	._on_ready()
	point_a = grid.calculate_grid_coordinates(position)
	point_b = grid.calculate_grid_coordinates($Position2D.global_position)
	print(point_a, point_b)

func check_status() -> void:
	if grid.player_tail_tiles.has(point_a) and grid.player_tail_tiles.has(point_b) and not destroyed:
		destroyed = true
		$DamageAnimationPlayer.stop()
		emit_signal("increase_strength", 6)
		emit_signal("shake")
		$AnimationPlayer.play("destroy")
		yield($AnimationPlayer, "animation_finished")
		queue_free()
	elif grid.player_tail_tiles.has(point_a) or grid.player_tail_tiles.has(point_b):
		$DamageAnimationPlayer.play("damage")
	else:
		$DamageAnimationPlayer.stop()
		$AudioStreamPlayer2D.stop()
		$Sprite/Particles2D.emitting = false
