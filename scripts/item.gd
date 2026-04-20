extends Area2D
class_name Item

@export var data: ItemTemplate
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

signal revealed

func _ready():
	visible = false
	
	print("Item instanced at: ", global_position)
	print("Item data: ", data)
	GameState.register_item(self)
	if data:
		sprite_2d.texture = data.texture


func setup(incoming_data: ItemTemplate) -> void:
	data = incoming_data.duplicate()
	print("setup called, bury_value: ", data.bury_value)
	
func _exit_tree():
	GameState.unregister_item(self)

func dig(amount: float) -> void: 
	if data.bury_value >= 1:
		data.bury_value -= amount
		if data.bury_value == 0: 
			visible = true
			audio_stream_player_2.play(0.0)
			revealed.emit()
			return
		
func _on_revealed() -> void:
	if data.type == GameState.Type.SCORING:
		GameState.add_score(data.score_value)

func apply_self(target: Player) -> void:
	match data.detection_type:
		GameState.DetectionType.HEALTH:
			target.heal(data.restore_points)
		GameState.DetectionType.SCORING:
			GameState.add_score(data.point_value)
			target.emit_score_sound()
		GameState.DetectionType.POWER:
			target.apply_powerup(data.powerup_type)
	queue_free()
	
