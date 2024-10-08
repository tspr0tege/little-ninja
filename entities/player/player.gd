extends CharacterBody2D

@export var SPEED = 65.0
@onready var screen_size = get_viewport_rect().size
@onready var action_timer: Timer = $"Action Timer"
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
		
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
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
