extends Area2D
class_name Pellet

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var direction := Vector2.ZERO
var speed := 300.0
var wide: bool = false

func _ready() -> void:
	add_to_group("pellet")
	if wide:
		(collision_shape_2d.shape as CircleShape2D).radius = 6.0
		sprite_2d.region_enabled = true
		sprite_2d.region_rect = Rect2(0, 8, 8, 8)

func setup(dir: Vector2, spd: float, w:bool) -> void:
	direction = dir
	speed = spd
	wide = w
	
func _process(delta: float) -> void:
	position += direction * speed * delta
