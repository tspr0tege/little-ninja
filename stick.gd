extends Node2D

@onready var player = find_parent("Player")
var currentDirection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentDirection = player.get_node("AnimatedSprite2D").animation.split("-")[-1]
	$AnimationPlayer.play("swing")

func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
