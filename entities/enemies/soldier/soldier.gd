extends CharacterBody2D

@onready var PLAYER: Node2D = get_tree().get_nodes_in_group("Player")[0]
const SPEED = 25
var facingDirection: String = "down"
var knockback = Vector2.ZERO
var player_in_range = false
var in_action = false

func _physics_process(_delta: float) -> void:	
	if knockback.length() > .1:
		velocity = knockback
		knockback = lerp(knockback, Vector2.ZERO, 0.175)
	elif in_action:
		velocity = Vector2.ZERO
	elif player_in_range:
		var direction = self.global_position.direction_to(PLAYER.global_position)
		velocity = direction * SPEED
		if absf(direction.y) >= absf(direction.x):
			facingDirection = "down" if direction.y > 0 else "up"
		else:
			facingDirection = "left" if direction.x < 0 else "right"
		
		$AnimatedSprite2D.play("walk-" + facingDirection)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle-" + facingDirection)
	
	move_and_slide()

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body == PLAYER:
		player_in_range = true

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body == PLAYER:
		player_in_range = false

func _on_dmg_area_body_entered(body: Node2D) -> void:
	if body == PLAYER:
		body.get_node("HP_node").take_damage_from($DMG_node)


func _on_attack_range_triggered(body: Node2D) -> void:
	if body == PLAYER:
		in_action = true
		$AnimatedSprite2D.pause()
		$AttackAnimationPlayer.play("attack-right")

func _on_animation_finished(_anim_name: StringName) -> void:
	if $AttackRange.get_overlapping_bodies().has(PLAYER):
		$AttackAnimationPlayer.play("attack-right")
	else:
		in_action = false

func _on_weapon_collision_detected(body: Node2D) -> void:
	if body == PLAYER:
		PLAYER.get_node("HP_node").take_damage_from($AnimatedSprite2D/Weapon/DMG_node)
