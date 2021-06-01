extends CanvasLayer

export var grid: Resource = preload("res://Grid.tres")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var Power = $HBoxContainer/PowerLabel
onready var Destroyed = $VBoxContainer/Destroyed
onready var Most_destroyed = $VBoxContainer/Destroyed2
onready var Transition = $AnimationPlayer
onready var Player_fade_target = $ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_most()

func update_power(val : int) -> void:
	Power.text = "Power: " + str(val)

func update_destroyed(val : int) -> void:
	Destroyed.text = "Buildings Destroyed: " + str(val)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func update_most():
	Most_destroyed.text = "Most Destroyed: " + str(grid.most_destroyed)

func fade_in():
	Transition.play("fade_in")

func fade_out(location : Vector2) -> void:
#	Player_fade_target.get_material().set_shader_param("target", location)
	Transition.play("fade_out")

func winner() -> void:
	$YouWin.visible = true

func _on_TextureButton_pressed() -> void:
	$Popup.popup_centered()


func _on_HomeButton_pressed() -> void:
	Audio.stop_music()
	get_tree().change_scene("res://Start.tscn")

