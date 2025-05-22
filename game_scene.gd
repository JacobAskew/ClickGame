extends Control

var count := 0
const SAVE_PATH := "user://save_data.json"

func _ready():
	$CenterContainer/VBoxContainer/IncreaseButton.pressed.connect(_on_IncreaseButton_pressed)
	$CenterContainer/VBoxContainer/SaveButton.pressed.connect(_on_SaveButton_pressed)
	load_game()

func _on_IncreaseButton_pressed():
	count += 1
	$CenterContainer/VBoxContainer/NumberLabel.text = str(count)

func _on_SaveButton_pressed():
	save_game()

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"clicks": count
	}
	file.store_string(JSON.stringify(data))
	file.close()
	print("Game saved!")

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data:
			count = data["clicks"]
			$CenterContainer/VBoxContainer/NumberLabel.text = str(count)
			print("Game loaded with ", count, " clicks.")
		file.close()

# 🔁 AUTO-SAVE on exit / pause
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("App is closing — auto-saving.")
		save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		print("App paused — auto-saving.")
		save_game()
