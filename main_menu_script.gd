extends Control

func _ready():
	$CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_StartButton_pressed)

func _on_StartButton_pressed():
	print("Game start ...")
	get_tree().change_scene_to_file("res://game_scene.tscn")
