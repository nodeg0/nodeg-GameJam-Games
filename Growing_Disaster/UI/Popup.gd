extends Popup


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_MVolumeHSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_MusicHSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func _on_SoundHSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)


func _on_FSCheckBox_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed

func _on_Button_pressed() -> void:
	hide()


func _on_Mute_Music_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(1, button_pressed)


func _on_Mute_Sound_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(2, button_pressed)
