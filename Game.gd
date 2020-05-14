extends Node2D

onready var in_game 		= $InGame
onready var camera 			= $Camera2D

var player 		= null
var level 		= null


func _ready():
	
	
	add_level()
	connect_to_doors()
	connect_to_blob()
	
	put_camera_on_player()
	check_for_door()

func _process(delta):
	
	if player == null:return
	# CHEATS for testing
	if Input.is_action_just_pressed("kill"):
		player.hearts -= 1
	if Input.is_action_just_pressed("skip"):
		pass
		
	# normal heart logic	
	if player.hearts == 3:
		$CanvasLayer/Heart1.animation = "filled"
		$CanvasLayer/Heart2.animation = "filled"
		$CanvasLayer/Heart3.animation = "filled"
	elif player.hearts == 2:
		$CanvasLayer/Heart1.animation = "filled"
		$CanvasLayer/Heart2.animation = "filled"
		$CanvasLayer/Heart3.animation = "empty"
	elif player.hearts == 1:
		$CanvasLayer/Heart1.animation = "filled"
		$CanvasLayer/Heart2.animation = "empty"
		$CanvasLayer/Heart3.animation = "empty"
	else:
		$CanvasLayer/Heart1.animation = "empty"
		$CanvasLayer/Heart2.animation = "empty"
		$CanvasLayer/Heart3.animation = "empty"
		game_over()
	

func check_for_door():
	if Globals.just_came_from_door == true:
		prints("came from door")
		var door = level.find_node(str("Door", Globals.next_level_number))
		prints(str("Door", Globals.next_level_number))
		prints(Globals.next_level_number)
		prints(door.position)
		
		player.position.x = door.position.x
		Globals.just_came_from_door = false
	
	
func connect_to_blob():
	prints("connect method")
	for child in level.find_node("Enemies").get_children():
		if child.name.begins_with("Blob"):
			prints(child)
			child.connect("blob_died", self, "_game_won")
			

func connect_to_doors():
	for child in level.find_node("Objects").get_children():
		if child.name.begins_with("Door"):
			child.connect("enter_door", self, "_on_enter_door")

func put_camera_on_player():
	remove_child(camera)
	player.add_child(camera)

func add_level():
	level = load(str("res://Scenes/Levels/Level", Globals.next_level_number, ".tscn")).instance()
	in_game.add_child(level)
	player = level.find_node("Player")

func game_over():
	$"CanvasLayer/Game Over".visible = true
	$"CanvasLayer/GameOverDialog".popup()
	

func _game_won():
	prints("Game Won")	
	$"CanvasLayer/Game Won".visible = true
	$"CanvasLayer/GameWonDialog".popup()

func _on_enter_door():
	Globals.just_came_from_door = true
	get_tree().reload_current_scene()


func _on_GameOverDialog_confirmed():
	level = null
	player = null
	Globals.next_level_door = null
	Globals.next_level_number = 1
	get_tree().reload_current_scene()
