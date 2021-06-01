extends Node2D

export var grid: Resource = preload("res://Grid.tres")

onready var Ground_grid = $Ground
onready var Player_path = $PlayerTiles
onready var Roads_and_rivers = $RoadsAndRivers
onready var UI = $UI
onready var Player_camera = $Player/Camera2D

var player_in_initial_position :=true
var last_power := 3
var music_playing := false

func _ready() -> void:
	Audio.stop_music()
	Player_camera.stop()
	grid.reset()
	UI.fade_in()
	count_structures()

func count_structures():
	var count :=0
	for child in get_children():
		var structure := child as Structure
		if not structure:
			continue
		count += 1
	grid.total_buildings = count

func player_moved(grid_position: Vector2, power : int) -> void:
	if grid_position:
		if !Player_path:
			yield(self, "ready")
		Player_path.set_cell(grid_position.x, grid_position.y, 0)
		Player_path.update_bitmask_region()
		if Roads_and_rivers.get_cell(grid_position.x, grid_position.y) == 0:
			Roads_and_rivers.set_cell(grid_position.x, grid_position.y, -1)
		if player_in_initial_position == true:
			player_in_initial_position = false
		else:
			update_player_path()
		grid.player_tail_tiles[grid_position] = power
	else:
		print("no position")
	if power != last_power:
		$UI.update_power(power)
	last_power = power

func check_crash(grid_position: Vector2) -> void:
	if Player_path.get_cell(grid_position.x, grid_position.y) == 0 or Ground_grid.get_cell(grid_position.x, grid_position.y) == -1 or Roads_and_rivers.get_cell(grid_position.x, grid_position.y) == 1:
		$UI.fade_out(grid.calculate_map_position(Vector2(0.5,0.5)))
		$Player.dead = true
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().call_group("players", "crash")

func update_player_path() -> void:
	var path_for_deleting := []
	if grid.player_tail_tiles:
		for key in grid.player_tail_tiles.keys():
			grid.player_tail_tiles[key] -= 1
			if grid.player_tail_tiles[key] == 0:
				Player_path.set_cell(key.x, key.y, -1)
				Player_path.update_bitmask_region()
				path_for_deleting.append(key)
	for paths in path_for_deleting:
# warning-ignore:return_value_discarded
		grid.player_tail_tiles.erase(paths)
#		get_tree().call_group("destructables", "check_status")

func increase_player_strength(val : int = 3) -> void:
	if !music_playing or !Audio.Audio.playing:
		Audio._play_game_music()
		music_playing = true
	if grid.player_tail_tiles:
		for key in grid.player_tail_tiles.keys():
			grid.player_tail_tiles[key] += val
	get_tree().call_group("players", "increase_strength", val)
	grid.buildings_destroyed += 1
	$UI.update_destroyed(grid.buildings_destroyed)
	$UI.update_most()
	if grid.buildings_destroyed == grid.total_buildings:
		$UI.winner()
		

func call_shake() -> void:
	Player_camera.shake()
