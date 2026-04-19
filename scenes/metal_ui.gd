extends Control


@export var bar_textures: Array[Texture2D] = []
@export var indicator_textures: Array[Texture2D] = []
@onready var backing: TextureRect = $Backing
@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel



func _process(_delta: float) -> void:
	var d = GameState.distance_to_nearest
	var t = GameState.nearest_type
	if d < 15:
		texture_rect.texture = bar_textures[0]
	elif d < 30:
		texture_rect.texture = bar_textures[1]
	elif d < 60:
		texture_rect.texture = bar_textures[2]
	elif d < 90:
		texture_rect.texture = bar_textures[3]
	elif d < 120:
		texture_rect.texture = bar_textures[4]
	else:
		texture_rect.texture = bar_textures[5]

	match t:
		GameState.DetectionType.SCORING:
			if GameState.nearest_gold:
				texture_rect_2.texture = indicator_textures[1]
			else:
				texture_rect_2.texture = indicator_textures[0]
		GameState.DetectionType.HEALTH:
			texture_rect_2.texture = indicator_textures[2]
		GameState.DetectionType.POWER:
			texture_rect_2.texture = indicator_textures[3]

	score_label.text = str(GameState.score)
	health_label.text = str(GameState.player_health)
