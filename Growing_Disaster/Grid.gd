class_name Grid
extends Resource


enum Move {RIGHT, DOWN, LEFT, UP}

export var size := Vector2(100, 100)

export var cell_size := Vector2(16,16)

var player_tail_tiles := {}
var buildings_destroyed := 0 setget update_most_destroyed
var most_destroyed := 0
var _half_cell_size = cell_size/2
var total_buildings := 0


func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size

func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()

func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

func get_next_move_position(pos:Vector2, dir: int) -> Vector2:
	var next_pos :Vector2 = calculate_grid_coordinates(pos)
	if dir == Move.RIGHT:
		next_pos.x += 1
	elif dir == Move.LEFT:
		next_pos.x -= 1
	elif dir == Move.UP:
		next_pos.y -= 1
	elif dir == Move.DOWN:
		next_pos.y += 1
	return next_pos

func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out

func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
	
func reset():
	player_tail_tiles = {}
	buildings_destroyed = 0

func update_most_destroyed(val):
	buildings_destroyed = val
	if buildings_destroyed > most_destroyed:
		most_destroyed = buildings_destroyed
