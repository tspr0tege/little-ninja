extends Node

signal damage_taken

@export var hitPoints: int = 5
@export var knockbackModifier: float = 1
@onready var ENTITY = get_parent()
var hit_splash

func _ready():
	hit_splash = $GPUParticles2D.duplicate()
	ENTITY.add_child.call_deferred(hit_splash)
	hit_splash.position = Vector2.ZERO

func take_damage_from(dmg_node) -> void:
	#print(str(ENTITY.name) + " taking damage!")
	hitPoints -= dmg_node.dmgOutput
	
	if ENTITY.has_node("HitFlash"):
		ENTITY.get_node("HitFlash").play("hit_flash")
	
	if hitPoints <= 0:
		hit_splash.get_parent().remove_child(hit_splash)
		get_tree().root.add_child(hit_splash)
		var deathSound = $DeathSound.duplicate()
		get_tree().root.add_child(deathSound)
		hit_splash.position = ENTITY.global_position
		hit_splash.process_material.scale = Vector2(2,5)
		hit_splash.restart()
		hit_splash.emitting = true
		deathSound.play()
		ENTITY.queue_free()
	else:
		$HitSound.play()
	
	if dmg_node.knockbackStrength > 0:
		var knockbackDirection = dmg_node.get_parent().global_position.direction_to(ENTITY.global_position)
		ENTITY.knockback = knockbackDirection * (dmg_node.knockbackStrength * knockbackModifier)
	
	hit_splash.restart()
	hit_splash.emitting = true
	damage_taken.emit()
