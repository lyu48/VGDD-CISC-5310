extends CharacterBody2D

#creating speed and jump vel, ariables
const speed = 400.0
const jump_velocity = -790.0


#function to handle physics processs
func _physics_process(delta: float) -> void:
	#adding gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	#make the player jump if up button is pressed and they are on the floor
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity

	#determining movement direction based on user input
	#we have to create this variable here so that it is checking for new input and updating the variable as time passes, otherwise left and right wouldn't move
	var direction := Input.get_axis("ui_left", "ui_right")
	#if a key is being pressed (i.e. direction has a value) then velocity is the direction times speed
	if direction:
		velocity.x = direction * speed
	else:
		#slow down player if nothing is pressed to 0 movement
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
