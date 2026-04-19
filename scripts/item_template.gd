extends Resource
class_name ItemTemplate


@export var texture: AtlasTexture
@export var item_name: String = ""
@export_multiline() var description: String = "n/a"
@export var point_value: int = 0
@export var restore_points: int = 0
@export var bury_value: int = 20
@export var rarity: GameState.Rarity = GameState.Rarity.COMMON
@export var detection_type: GameState.DetectionType = GameState.DetectionType.POWER
@export var powerup_type: GameState.PowerupType = GameState.PowerupType.NONE
@export var gold: bool = false
