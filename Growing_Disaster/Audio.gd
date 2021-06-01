extends Node2D


onready var Audio = $AudioStreamPlayer

var loop : bool = false
var started : = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _play_game_music() -> void:
	var music = load("res://musicteststart.ogg")
	started = true
	Audio.set_stream(music)
	Audio.play()
	
func stop_music() -> void:
	started = false
	Audio.stop()

	
	

func _on_AudioStreamPlayer_finished() -> void:
	print("audiostream finished")
	if !loop and started:
		var _loop = load("res://musictest2.ogg")
		print("not loop")
		Audio.set_stream(_loop)
		Audio.play()
		loop = true
