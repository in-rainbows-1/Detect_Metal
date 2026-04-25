extends Area2D

@export var speed: float = 20.0
@export var health: int = 3
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var player: Player = null

func _ready() -> void:
	add_to_group("enemy")
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	if player.global_position >= global_position:
		animated_sprite_2d.flip_h = true
	else: animated_sprite_2d.flip_h = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("pellet"):
		area.queue_free()
		take_damage(1)

func take_damage(amount: int) -> void:
	audio_stream_player.play(0.0)
	health -= amount
	animated_sprite_2d.modulate.a = 0.0
	for i in 8:
		await get_tree().process_frame
	animated_sprite_2d.modulate.a = 1.0
	if health <= 0:
		die()

func die() -> void:
	emit_signal("enemy_died", self)
	queue_free()
