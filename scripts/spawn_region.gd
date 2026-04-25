extends Area2D

const ItemScene = preload("res://scenes/item.tscn")

@export var item_population: int = 10
@export var sampled: ItemPicklist


func _ready() -> void:
	call_deferred("spawn_items")

func spawn_items():
	if !sampled:
		print("item picklist is null")
		return
	var polygon = $CollisionPolygon2D.polygon
	var bounding_rect = Rect2(polygon[0], Vector2.ZERO)
	for point in polygon:
		bounding_rect = bounding_rect.expand(point)

	for n in item_population:
		var random_offset = Vector2(
			randf_range(bounding_rect.position.x, bounding_rect.end.x),
			randf_range(bounding_rect.position.y, bounding_rect.end.y)
		)
		var i = ItemScene.instantiate()
		i.setup(sampled.item_pool.pick_random())
		get_tree().current_scene.add_child.call_deferred(i)
		i.global_position = global_position + random_offset
