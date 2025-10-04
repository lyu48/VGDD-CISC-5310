extends Area2D

#create variable for Game Manger Node to connect to score variable/score counter function
@onready var game_manager: Node = %Game_Manager

#if body enters the area2D while the timer is still running, disappear the bone, and add one to score
func _on_body_entered(_body: Node2D) -> void:
	#checking if timer is still running
	if game_manager.timer.time_left > 0:
		#triggered on body entering the area of the bone - collision layer is 1, but mask is two so it 
		#only detects collisions from bodies on layer 2
		queue_free() 		#makes coin disappear once touched
		%Game_Manager.score_counter()	#calling score counter func to increase score
	
	#if timer has stopped, you can no longer collect the bones
	else:
		pass
	
