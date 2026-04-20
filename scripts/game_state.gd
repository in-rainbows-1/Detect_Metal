extends Node

const game_over = preload("res://scenes/game_over.tscn")



enum Rarity { COMMON, UNCOMMON, RARE }
enum DetectionType { HEALTH, POWER, SCORING }
enum PowerupType { NONE, SPEED, DIG_SPEED, DIG_AREA, FIRE_RATE, WIDE_PELLET }

var player: Player
var player_health: int
var distance_to_nearest: float = INF
var score: int = 0
var active_items: Array[Item] = []
var nearest_gold: bool = false
var nearest_type: DetectionType = DetectionType.SCORING

func register_item(item: Item) -> void:
	active_items.append(item)
	
func unregister_item(item: Item) -> void:
	active_items.erase(item)
	
func add_score(amount: int) -> void:
	score += amount

func update_nearest_item() -> void:
	if active_items.is_empty() || !player:
		distance_to_nearest = INF
		return
	var nearest = INF
	for item in active_items:
		var d = player.global_position.distance_to(item.global_position)
		if d < nearest:
			nearest = d
			nearest_type = item.data.detection_type
			nearest_gold = item.data.gold
	distance_to_nearest = nearest

func update_player_health():
	player_health = player.hit_points
	if player_health == 0:
		end_game()

func end_game():
	get_tree().change_scene_to_packed(game_over)
