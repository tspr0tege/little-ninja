extends CharacterBody2D

const SPEED = 25
var knockback = Vector2.ZERO
var player_in_range = false

func _ready():
	var entitiesAtSpawn = $DetectPlayer.get_overlapping_bodies()
	for entity in entitiesAtSpawn:
		if entity.is_in_group("Player"):
			player_in_range = true
			break

func _physics_process(_delta: float) -> void:
	
	if knockback.length() > .1:
		#print(str(knockback))
		velocity = knockback
		knockback = lerp(knockback, Vector2.ZERO, 0.175)
	elif player_in_range:
		var player = get_tree().get_nodes_in_group("Player")[0]
		var direction = self.global_position.direction_to(player.global_position)
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false


func _on_dmg_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_node("HP_node").take_damage_from($DMG_node)
