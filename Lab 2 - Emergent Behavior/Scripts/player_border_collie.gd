extends CharacterBody2D

@onready var border_collie: AnimatedSprite2D = $border_collie
const speed = 350.0


func _process(_delta: float) -> void:
	#variable to get direction
	var direction = Input.get_axis("ui_left", "ui_right")
	
	#flipping sprite to match movement direction
	if direction > 0:
		border_collie.flip_h = false
	elif direction < 0:
		border_collie.flip_h = true
	
	#if moving display idle position, if moving display run position
	if velocity.x == 0 and velocity.y == 0:
		border_collie.play("idle")
	else:
		border_collie.play("run")

	
	#if direction button is pressed, move in that direction
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	if Input.is_action_pressed("ui_up"):
		velocity.y = -speed 
	if Input.is_action_pressed("ui_down"):
		velocity.y = speed
		
	move_and_slide()
