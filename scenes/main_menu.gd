extends Control


@onready var start_game_button: Button = $HBoxContainer/VBoxContainer/VBoxContainer/StartGameButton
@onready var endless_mode: Button = $HBoxContainer/VBoxContainer/VBoxContainer/EndlessMode
@onready var endless_mode_2: Button = $HBoxContainer/VBoxContainer/VBoxContainer/EndlessMode2

const zone_1 = preload("res://scenes/zone_1.tscn")
const zone_2 = preload("res://scenes/zone_2.tscn")
const zone_3 = preload("res://scenes/zone_3.tscn")

func _ready():
	start_game_button.pressed.connect(func(): load_zone(1))
	endless_mode.pressed.connect(func(): load_zone(2))
	endless_mode_2.pressed.connect(func(): load_zone(3))
	

func load_zone(number: int) -> void:
	if number == 1:
		get_tree().change_scene_to_packed(zone_1)
	if number == 2:
		get_tree().change_scene_to_packed(zone_2)
	if number == 3:
		get_tree().change_scene_to_packed(zone_3)
