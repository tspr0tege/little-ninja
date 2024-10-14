extends CharacterBody2D

@onready var player = find_parent("Player")
@export var pickup: PackedScene
var lastStruckEnemy: Node2D
var currentDirection: String

func _ready() -> void:
	currentDirection = player.get_node("AnimatedSprite2D").animation.split("-")[-1]

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_collision_detected(body: Node2D) -> void:
	if body == player:
		return
	
	if body.is_in_group("weiners") and not lastStruckEnemy == body:
		#print("Striking " + str(body.name))
		lastStruckEnemy = body
		if body.has_node("HP_node"):
			body.get_node("HP_node").take_damage_from($DMG_node)

	if pickup != null:
		var new_pickup = pickup.instantiate()
		new_pickup.position = self.global_position
		#print("Placing new_pickup on " + str(get_tree().root.get_child(0)))
		get_tree().root.call_deferred("add_child", new_pickup)
	self.queue_free()
