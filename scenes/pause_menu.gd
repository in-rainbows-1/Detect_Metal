extends Control

@onready var mute_toggle: CheckButton = $HBoxContainer/VBoxContainer/MuteToggle
@onready var quit_button: Button = $HBoxContainer/VBoxContainer/QuitButton

func _ready() -> void:
	mute_toggle.toggled.connect(_on_mute_toggled)
	quit_button.pressed.connect(_on_quit_pressed)
	
	
func _on_mute_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)
	
func _on_quit_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
