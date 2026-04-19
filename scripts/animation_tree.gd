extends AnimationTree

@onready var player: Player = $".."

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var idle = player.velocity == Vector2.ZERO
	var attacking = player.attacking
	var playback: AnimationNodeStateMachinePlayback = get("parameters/playback")

	if !playback:
		print("playback is null")
		return

	if !idle:
		player.last_facing = player.velocity.normalized()
		set("parameters/walk/blend_position", player.last_facing)
		set("parameters/idle/blend_position", player.last_facing)
