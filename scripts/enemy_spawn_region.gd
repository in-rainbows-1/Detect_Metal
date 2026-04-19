extends Area2D

@onready var enemy_spawn_timer: Timer = $"../EnemySpawnTimer"
const GnatScene = preload("res://scenes/gnat.tscn")
var spawn_regions: Array


func _ready() -> void:
	enemy_spawn_timer.timeout.connect(spawn_enemies)
	for child in get_children():
		if child is CollisionPolygon2D:
			spawn_regions.append(child)

func spawn_enemies():
	var region: CollisionPolygon2D = spawn_regions.pick_random()
	var gnat_instance = GnatScene.instantiate()
	get_tree().current_scene.add_child(gnat_instance)
	gnat_instance.global_position = get_random_point_in_polygon(region)

func get_random_point_in_polygon(region: CollisionPolygon2D) -> Vector2:
	var polygon_global: PackedVector2Array = []
	for point in region.polygon:
		polygon_global.append(region.to_global(point))
		
	var bounding_rect = Rect2(polygon_global[0], Vector2.ZERO)
	for point in polygon_global:
		bounding_rect = bounding_rect.expand(point)
	return Vector2(
		randf_range(bounding_rect.position.x, bounding_rect.end.x),
		randf_range(bounding_rect.position.y, bounding_rect.end.y)	
	)
	
	
