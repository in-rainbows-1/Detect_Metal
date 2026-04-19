extends CharacterBody2D
class_name Player

const PelletScene = preload("res://scenes/pellet.tscn")

@export var hit_points: int = 2
@export var speed: float = 60
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_rate: Timer = $AttackRate
@onready var dig_area: Area2D = $DigArea
@onready var pickup_hitbox: Area2D = $PickupHitbox
@onready var hitbox: Area2D = $Hitbox
@onready var power_get: AudioStreamPlayer = $PowerGet
@onready var hp_get: AudioStreamPlayer = $HPGet
@onready var coin_get: AudioStreamPlayer = $CoinGet
@onready var round_timer: Timer = $"../RoundTimer"

var last_facing := Vector2(0, -1)
var attacking: bool = false
var cooldown: float = .2 # timer seconds
var dig_speed: float = 10 # units per second
var pellet_width: bool = false


func _ready():
	add_to_group("player")
	GameState.player = self
	GameState.update_player_health()
	dig_area.area_entered.connect(_on_dig_area_entered)
	pickup_hitbox.area_entered.connect(_on_pickup)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	attack_rate.one_shot = true

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if velocity != Vector2.ZERO:
		last_facing = velocity.normalized()

func _physics_process(delta: float) -> void:
	GameState.update_nearest_item()
	if Input.is_action_pressed("button_a"):
		attacking = true
		print("attacking: ", attacking)
		attack()
	else:
		attacking = false
	get_input()
	move_and_slide()
	global_position = global_position.round()
	_process_digging(delta)

func attack():
	if !attack_rate.is_stopped():
		return
	var p = PelletScene.instantiate()
	get_tree().current_scene.find_child("Projectiles").add_child(p)
	p.global_position = global_position
	p.setup(last_facing, 200, pellet_width)
	attack_rate.start(cooldown)

func _on_dig_area_entered(area: Area2D):
	pass

func _process_digging(delta: float) -> void:
	for area in dig_area.get_overlapping_areas():
		if area is Item and !attacking:
			area.dig(dig_speed * delta)
			print(area.data.bury_value)

func heal(value):
	hp_get.play(0.0)
	if hit_points >= 2:
		hit_points += 1
	else:
		pass

func apply_powerup(powerup_type: GameState.PowerupType):
	power_get.play(0.0)
	match powerup_type:
		GameState.PowerupType.WIDE_PELLET:
			pellet_width = true
		GameState.PowerupType.FIRE_RATE:
			attack_rate.wait_time *= 0.8
		GameState.PowerupType.DIG_AREA:
			dig_area.get_child(0).shape.radius *= 1.5
		GameState.PowerupType.SPEED:
			speed *= 1.33

func emit_score_sound():
	coin_get.play(0.0)

func _on_pickup(area: Area2D) -> void:
	if area is Item && area.visible:
		area.apply_self(self)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		_take_damage(1)
		
func _take_damage(amount: int) -> void:
	hit_points -= 1
	print("player took damage")
	if hit_points <= 0:
		GameState.end_game()
		
