extends Node2D

#variables
@export var number_to_spawn = 25
@onready var fence: StaticBody2D = $Fences/Fence
@onready var player: CharacterBody2D = $Player
var sheep_flock = preload("res://Scenes/sheep_character.tscn")		#loading scene into variable

#randomly spawning sheep in the game 
func _ready() -> void:
	#getting window dimension to determine boundaries to spawn sheep within
	var w = get_window().size.x
	#getting fence position because I want all sheep to spawn above the fence
	var fence_pos_y = fence.position.y

	#looping over the number of sheep to spawn
	for x in number_to_spawn:
		var new_sheep = sheep_flock.instantiate()
		#setting sheep position coordinates
		new_sheep.position.x = randf_range(10, w-10)
		new_sheep.position.y = randf_range(10, fence_pos_y-100)
		#adding sheep as a child node
		get_node("Sheep_Flock").add_child(new_sheep)
		
