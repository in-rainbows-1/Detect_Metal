extends Area2D

@export var item_data: ItemTemplate
const ItemScene = preload("res://scenes/item.tscn")

@export var item_population: int = 10
var item_pool: Array[ItemTemplate] = []


func _ready() -> void:
	_load_item_pool()
	call_deferred("spawn_items")
	
func _load_item_pool():
	var dir = DirAccess.open("res://assets/item_resources")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var resource = load("res://assets/item_resources/" + file_name)
				if resource is ItemTemplate:
					item_pool.append(resource)
			file_name = dir.get_next()
		dir.list_dir_end()

func spawn_items():
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
		i.setup(item_pool.pick_random())
		get_tree().current_scene.add_child.call_deferred(i)
		i.global_position = global_position + random_offset
	
