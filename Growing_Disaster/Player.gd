extends Node2D

signal move_complete(new_grid_location, power)
signal checking_for_crash(new_grid_location)

export var grid: Resource = preload("res://Grid.tres")
export var move_speed := 0.3

onready var Move_timer = $Timer

var declared_move :  =6
var last_move : =6
var is_moving := false setget set_moving
var first_move_taken := false
var cell := Vector2.ZERO setget set_cell
var start_cell := Vector2.ZERO
var power := 3
var dead = false

enum Move {RIGHT, DOWN, LEFT, UP}

func _ready() -> void:
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
# warning-ignore:return_value_discarded
	self.connect("move_complete", get_parent(), "player_moved") 
# warning-ignore:return_value_discarded
	self.connect("checking_for_crash", get_parent(), "check_crash")
	emit_signal("move_complete", grid.calculate_grid_coordinates(position), 3)

func _process(_delta: float) -> void:
	get_input()

func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)

func set_moving(value: bool) -> void:
	if value == true:
		Move_timer.start(move_speed)
		print("timer started")
	else:
		Move_timer.stop()
		print("timer stopped")
	is_moving = value

func get_input() -> void:
	if Input.is_action_pressed("down") and last_move != Move.UP:
		declared_move = Move.DOWN
	elif Input.is_action_pressed("left") and last_move != Move.RIGHT:
		declared_move = Move.LEFT
	elif Input.is_action_pressed("right") and last_move != Move.LEFT:
		declared_move = Move.RIGHT
	elif Input.is_action_pressed("up") and last_move != Move.DOWN:
		declared_move = Move.UP
	if !first_move_taken and declared_move != 6:
		print("declaring")
		move_player(declared_move)
		last_move = declared_move
		first_move_taken = true


func move_player(move : int) -> void:
	if dead:
		return
	var newloc : Vector2 = grid.get_next_move_position(position, move)
	$Tween.interpolate_property(self, "position", position, grid.calculate_map_position(newloc), move_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if is_moving:
		print("checking for crash")
		emit_signal("checking_for_crash", newloc)
	else:
		self.is_moving = true
	self.cell = grid.calculate_map_position(position)
#	emit_signal("move_complete", cell)
	yield($Tween, "tween_completed")

func increase_strength(val : int = 1) -> void:
	power += val
	if power <= 0:
		crash()

func crash() -> void:
	Audio.stop_music()
	get_tree().reload_current_scene()

func _on_Timer_timeout() -> void:
	print("timer")
	last_move = declared_move
	move_player(declared_move)
	emit_signal("move_complete", grid.calculate_grid_coordinates(position), power)
