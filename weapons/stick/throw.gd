extends CharacterBody2D

@onready var player = find_parent("Player")
const pickup = "res://weapons/stick/pickup.tscn"
var lastStruckEnemy: Node2D
var currentDirection: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentDirection = player.get_node("AnimatedSprite2D").animation.split("-")[-1]
	$AnimationPlayer.play("spin")

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_collision_detected(body: Node2D) -> void:
	if body.is_in_group("weiners") and not lastStruckEnemy == body:
		#print("Striking " + str(body.name))
		lastStruckEnemy = body
		if body.has_node("HP_node"):
			body.get_node("HP_node").take_damage_from($DMG_node)
	
	if body != player:
		var new_pickup = load(pickup).instantiate()
		new_pickup.position = self.global_position
		#print("Placing new_pickup on " + str(get_tree().root.get_child(0)))
		get_tree().root.get_child(0).call_deferred("add_child", new_pickup)
		self.queue_free()
