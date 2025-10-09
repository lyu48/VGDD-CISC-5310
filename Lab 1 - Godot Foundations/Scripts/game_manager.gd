extends Node

#creating score, string score, and score text variables
var score = 0
var str_score = ""
@onready var score_label: RichTextLabel = $Score_Label

#function to increase score when bone is collected
func score_counter():
	score += 1
	
	# display a 0 before single digits
	if score < 10:
		str_score = "0" + str(score)
	else:
		str_score = str(score)
	
	#change the text inside the score label to reflect current score
	score_label.text = "Score: " + str_score


#############################################################################################
#creating variables to control timer start, and variables for timer, timer label, intro label, and end label
var start  = 0
@onready var timer = get_node("Timer")
@onready var timer_label: RichTextLabel = %Timer_Label
@onready var intro_label: RichTextLabel = $Intro_Label
@onready var end_label: RichTextLabel = $End_Label

#function to start game timer once player moves and disappear intro label
func start_timer():
	if start == 0:
		#changer timer label to reflect unstarted timer/total time
		timer_label.text = "Time: " + str(timer.wait_time).pad_decimals(3)
		
		#if player presses up, left, or right, timer starts and intro label disappears, start variable is changed to one
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			timer.start()
			intro_label.queue_free()
			start = 	1
			
	#once timer has been started, update timer label with time left as it counts down
	if start == 1:
		timer_label.text = "Time: " + str(timer.time_left).pad_decimals(3)

#function to pause timer if all bones are collected
func pause_timer():
	if score == 10:
		timer.set_paused(true)

#when the scene loads in hide the end label (even though there's no text in the node yet)
func _ready() -> void:
	end_label.hide()

#this function updates every frame? I know it updates or calls frequently
func _process(_delta: float) -> void:
	#call start time function and pause timer function
	start_timer()		#continually called to check for when player starts moving, and then to update time remaining on timer label
	pause_timer()		#continually called to check for when score = 10, and the time should be paused
	
	#if timer has started (i.e. start =1) and then paused, display end text
	if start == 1 and timer.is_paused():
		end_label.text = "Congrats!\nYour Score: " +str(score)+ "\nYour Time: " +str(timer.wait_time-timer.time_left).pad_decimals(3)
		end_label.show()

#if player fails to collect all bones before timer runs out, show end label
func _on_timer_timeout() -> void:
	end_label.text = "You Failed\nYour Score: " +str(score)
	end_label.show()
