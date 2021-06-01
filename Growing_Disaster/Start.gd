extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_SettingsButton_pressed() -> void:
	$CanvasLayer/Popup.popup_centered()


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")


func _on_InstructionsButton_pressed() -> void:
	$CanvasLayer/Tutorial.popup_centered()
