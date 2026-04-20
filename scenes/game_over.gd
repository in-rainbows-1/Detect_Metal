extends Control

@onready var final_score: Label = $HBoxContainer/VBoxContainer/FinalScore
@onready var retry_button: Button = $HBoxContainer/VBoxContainer/RetryButton

const main_menu = preload("res://scenes/main_menu.tscn")


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_pressed)
	final_score.text = str(GameState.score)
func _on_retry_button_pressed():
	get_tree().change_scene_to_packed(main_menu)
