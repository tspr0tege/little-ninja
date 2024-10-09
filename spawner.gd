extends Path2D

@onready var world: Node2D = $"../../.."
@onready var map: TileMapLayer = $"../../../Map/Layer1"
var map_rect: Rect2

@export var ENEMY_LIMIT = 5
@export var enemy_to_spawn: PackedScene

func _ready():
	map_rect = map.get_used_rect()
	map_rect.end *= map.rendering_quadrant_size

func _on_timer_timeout() -> void:
	#print("Timer timeout")
	if enemy_to_spawn == null:
		print("No enemies loaded. Deleting timer")
		$Timer.queue_free()
		return
	
	if get_tree().get_nodes_in_group("weiners").size() < 5:
		var new_enemy = enemy_to_spawn.instantiate()
		
		$SpawnRim.progress_ratio = randf()
		while not map_rect.has_point($SpawnRim.global_position):
			#print("map_rect: " + str(map_rect), "Attempted spawn point: " + str($SpawnRim.global_position))
			$SpawnRim.progress_ratio = randf()
			
		new_enemy.position = $SpawnRim.global_position
		world.add_child(new_enemy)
		#print("New enemy position = " + str(new_enemy.global_position))
		
		
