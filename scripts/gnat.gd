extends Area2D

@export var speed: float = 10.0
@export var health: int = 5

var player: Player = null

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("pellet"):
		take_damage(1)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	emit_signal("enemy_died", self)
	queue_free()
