extends CharacterBody2D

#variables for flocking
@export var speed = 100.
@export var personal_space = 100
@export var steering_strength = 5.
var nearby_sheep = []

#variables for fleeing from the border collie
var player: CharacterBody2D
@onready var sheep_sprite: Sprite2D = $Sheep_Sprite
@onready var timer: Timer = $Timer
var border_collie_near = false
var running = false


#functions
func _ready() -> void:
	#set random velocity of sheep at start
	velocity.x = randf_range(-1.0, 1.0)
	velocity.y = randf_range(-1.0, 1.0)
	velocity *= speed
	print(player.name)

func _physics_process(_delta: float) -> void:
	if running:
		velocity = (position - player.position).normalized() * speed
	else:
		#variables
		var seperation_force = Vector2.ZERO
		var cohesion_force = Vector2.ZERO
		var alignment_force = Vector2.ZERO
		
		var nbs = nearby_sheep.size()
		
		if nbs > 0:
			for sheep in nearby_sheep:
				var distance_to_sheep = position.distance_to(sheep.position)
				
				if distance_to_sheep < personal_space:
					seperation_force += position - sheep.position
				else:
					cohesion_force += sheep.position - position
				
				alignment_force += sheep.velocity
			seperation_force = seperation_force.normalized()
			alignment_force = alignment_force.normalized()
			cohesion_force = cohesion_force.normalized()
			
			var total_force = seperation_force + (cohesion_force* 0.5)+ (alignment_force*0.3)
			velocity += total_force * steering_strength

			if velocity.length()>speed:
				velocity = velocity.normalized()*speed
				
	#if sheep is going left face left, if going right face right
	if velocity.x > 0:
		sheep_sprite.flip_h = false
	elif velocity.x < 0:
		sheep_sprite.flip_h = true
	
	move_and_slide()


func _on_sight_body_entered(body: Node2D) -> void:
	if body == player:
		border_collie_near = true
		running = true
		timer.start()
		
	elif body != self and body is CharacterBody2D:
		nearby_sheep.push_back(body)
		


func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		border_collie_near = false
	
	else:
		var byesheep = nearby_sheep.find(body)
		if nearby_sheep.size():
			nearby_sheep.remove_at(byesheep)
		


func _on_timer_timeout() -> void:
	running = border_collie_near
	if border_collie_near:
		timer.start()
