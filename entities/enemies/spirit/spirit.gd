extends CharacterBody2D

var knockback = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	
	if knockback.length() > .1:
		#print(str(knockback))
		velocity = knockback
		knockback = lerp(knockback, Vector2.ZERO, 0.175)
	
	move_and_slide()
