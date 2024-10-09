extends CharacterBody2D

@export var SPEED = 65.0
var knockback = Vector2.ZERO
@onready var action_timer: Timer = $"Action Timer"
@onready var map: TileMapLayer = $"../Map/Layer1"

var level
var tileSize
var leftEdge
var topEdge

const STICK = preload("res://weapons/stick/stick.tscn")
const attackInstantiationPoint = {
	"up": {
		"position": Vector2(-3, -4),
		"rotation": 180,
	},
	"down": {
		"position": Vector2(-3, 8),
		"rotation": 0,
	},
	"left": {
		"position": Vector2(-7, 4),
		"rotation": 90,
	},
	"right": {
		"position": Vector2(7, 4),
		"rotation": 270,
	},
}

var in_action = false

func _ready() -> void:
	level = map.get_used_rect()
	tileSize = map.rendering_quadrant_size	
	leftEdge = level.position.x * tileSize
	topEdge = level.position.y * tileSize

func _physics_process(_delta):
	
	if in_action:
		return
	
	# MOVEMENT
	var y_axis = Input.get_axis("ui_up", "ui_down")
	var x_axis = Input.get_axis("ui_left", "ui_right")
	var direction = Vector2(x_axis, y_axis)
	
	if direction:
		velocity = direction.normalized() * SPEED
		if absf(y_axis) >= absf(x_axis):
			var y_animation = "walk-down" if y_axis > 0 else "walk-up"
			$AnimatedSprite2D.play(y_animation)
		else:
			var x_animation = "walk-left" if x_axis < 0 else "walk-right"
			$AnimatedSprite2D.play(x_animation)
	else:
		velocity = Vector2.ZERO
		var currentDirection = $AnimatedSprite2D.animation.split("-")[-1]
		$AnimatedSprite2D.play("idle-" + currentDirection)
		
	if knockback.length() > .1:
		velocity += knockback
		knockback = lerp(knockback, Vector2.ZERO, 0.175)
	
	position.x = clamp(position.x, leftEdge, (level.end.x * tileSize) + leftEdge)
	position.y = clamp(position.y, topEdge, (level.end.y * tileSize) + topEdge)
	
	move_and_slide()
	
	# ATTACK
	
	if Input.is_action_just_pressed("ui_select") and not in_action:
		in_action = true
		action_timer.start()
		var currentDirection = $AnimatedSprite2D.animation.split("-")[-1]
		$AnimatedSprite2D.play("attack-" + currentDirection)
		
		var ATTACK = STICK.instantiate()
		if currentDirection == "up":
			ATTACK.z_index = -1
		ATTACK.rotation = deg_to_rad(attackInstantiationPoint[currentDirection].rotation)
		ATTACK.position = attackInstantiationPoint[currentDirection].position
		add_child(ATTACK)

func _on_action_timer_timeout() -> void:
	in_action = false
