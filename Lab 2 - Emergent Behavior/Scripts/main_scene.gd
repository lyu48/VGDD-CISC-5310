extends Node2D

#variables to spawn sheep flock
var num_to_spawn = 25
var sheep_flock = preload("res://Scenes/sheep_character.tscn")		#loading scene into variable

#node variables
@onready var fence: StaticBody2D = $Fences/Fence
@onready var end_label: Label = $"Game_Manager/End_Label"
@onready var intro_label: Label = $"Game_Manager/Intro_Label"
@onready var timer_label: Label = $"Game_Manager/Timer_Label"

#variables to count sheep collected and start timer
var sheep_collected = 0
var str_sheep_collected = ""
var start = 0
var timer = 0.0
var str_timer = ""

#randomly spawning sheep in the game 
func _ready() -> void:
	end_label.hide()
	#getting window dimension to determine boundaries to spawn sheep within
	var w = get_window().size.x
	#getting fence position because I want all sheep to spawn above the fence
	var fence_pos_y = fence.position.y

	#looping over the number of sheep to spawn
	for x in num_to_spawn:
		var new_sheep = sheep_flock.instantiate()
		#setting sheep position coordinates
		new_sheep.position.x = randf_range(10, w-10)
		new_sheep.position.y = randf_range(10, fence_pos_y-100)
		#adding sheep as a child node of the sheep flock node
		get_node("Sheep_Flock").add_child(new_sheep)


#if a sheep exits the pen (or like half enters, but doesn't get caught by the 
#one way barrier) remove one from the counter
func _on_pen_counter_body_exited(body: Node2D) -> void:
	if body.name != "Player" and body is CharacterBody2D:
		sheep_collected -= 1
		
		# display a 0 before single digits
		if sheep_collected < 10:
			str_sheep_collected = "0" + str(sheep_collected)
		else:
			str_sheep_collected = str(sheep_collected)
		
		#change the text inside the score label to reflect current score
		$"Game_Manager/Sheep_Collected".text = "Sheep Collected: " + str_sheep_collected


#if sheep enters the pen, add one to the counter
func _on_pen_counter_body_entered(body: Node2D) -> void:
	if body.name != "Player" and body is CharacterBody2D:
		sheep_collected +=1
		
		# display a 0 before single digits
		if sheep_collected < 10:
			str_sheep_collected = "0" + str(sheep_collected)
		else:
			str_sheep_collected = str(sheep_collected)
		
		#change the text inside the score label to reflect current score
		$"Game_Manager/Sheep_Collected".text = "Sheep Collected: " + str_sheep_collected



#function to display end label if all sheep are collected
func end_label_display():
	if sheep_collected == num_to_spawn:
		end_label.text = "Congratulations! You Herded All The Sheep!\nYour Time: " + str_timer
		end_label.show()


#function to start game timer once player moves and disappear intro label
func _timer(delta):
	if start == 0:
		#if player presses up, left, or right, timer starts and intro label disappears, start variable is changed to one
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			intro_label.queue_free()
			start = 	1
			
	#once timer has been started, update timer label with time left as it counts down
	if start == 1:
		timer += delta
		str_timer = str(timer).pad_decimals(1)
		
		#formatting the timer displayed to add zeros if less than a certain time, and add a colon
		if timer < 10:
			str_timer = "00:0" +str(timer).pad_decimals(1)
		elif timer < 60:
			str_timer = "00:"+ str(timer).pad_decimals(1)
		elif timer >= 60:
			var minutes = int(floor(timer / 60))
			if minutes < 10:
				var seconds = timer - (minutes * 60)
				if seconds < 10:
					str_timer = "0" + str(minutes) + ":0" + str(seconds).pad_decimals(1)
				else:
					str_timer = "0"+ str(minutes) + ":" + str(seconds).pad_decimals(1)
			if minutes > 10:
				var seconds = timer - (minutes * 60)
				if seconds < 10:
					str_timer = "0" + str(minutes) + ":0" + str(seconds).pad_decimals(1)
				else:
					str_timer = str(minutes) + ":" + str(seconds).pad_decimals(1)
		
		#update timer label
		timer_label.text = "Time: " + str_timer
		
		#pausing timer if all sheep are collected by turning start to 2 to exit the if statements
		if sheep_collected == num_to_spawn:
			start = 2

func _physics_process(delta: float) -> void:
	_timer(delta)
	end_label_display()
