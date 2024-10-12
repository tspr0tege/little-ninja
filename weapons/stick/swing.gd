extends Node2D

@onready var player = find_parent("Player")
var struckEnemies: Array = []
var currentDirection: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentDirection = player.get_node("AnimatedSprite2D").animation.split("-")[-1]
	$AnimationPlayer.play("swing")

func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()

func _on_collision_detected(body: Node2D) -> void:
	if body.is_in_group("weiners") and not struckEnemies.has(body):
		#print("Striking " + str(body.name))
		struckEnemies.push_back(body)
		if body.has_node("HP_node"):
			body.get_node("HP_node").take_damage_from($DMG_node)
