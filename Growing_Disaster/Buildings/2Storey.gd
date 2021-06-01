extends "res://Buildings/Structure.gd"

var point_a:= Vector2.ZERO
var point_b:= Vector2.ZERO
var point_c:= Vector2.ZERO
var point_d:= Vector2.ZERO

onready var B_location:= $Position2D

func _on_ready() -> void:
	._on_ready()
	point_a = grid.calculate_grid_coordinates(position)
	point_b = grid.calculate_grid_coordinates($Position2D.global_position)
	point_c = grid.calculate_grid_coordinates($Position2D2.global_position)
	point_d = grid.calculate_grid_coordinates($Position2D3.global_position)


func check_status() -> void:
	if grid.player_tail_tiles.has(point_a) and grid.player_tail_tiles.has(point_b) and grid.player_tail_tiles.has(point_c) and grid.player_tail_tiles.has(point_d) and not destroyed:
		destroyed = true
		$DamageAnimationPlayer.stop()
		emit_signal("increase_strength", 12)
		emit_signal("shake")
		$AnimationPlayer.play("destroy2Storey")
		yield($AnimationPlayer, "animation_finished")
		queue_free()
	elif grid.player_tail_tiles.has(point_a) or grid.player_tail_tiles.has(point_b) or grid.player_tail_tiles.has(point_c) or grid.player_tail_tiles.has(point_d):
		$DamageAnimationPlayer.play("damage")
	else:
		$Sprite.modulate.a = 1.0
#		$DamageAnimationPlayer.stop()
		$AudioStreamPlayer2D.stop()
		$Sprite/Particles2D.emitting = false



