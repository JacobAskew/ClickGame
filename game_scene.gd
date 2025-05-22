extends Control

var count: float = 0.0
var resetbonus: int = 0
const SAVE_PATH := "user://save_data.json"

func _ready():
	$CenterContainer/VBoxContainer/IncreaseButton.pressed.connect(_on_IncreaseButton_pressed)
	$CenterContainer/VBoxContainer/SaveButton.pressed.connect(_on_SaveButton_pressed)
	$CenterContainer/VBoxContainer/ResetButton.pressed.connect(_on_ResetButton_pressed)
	$ResetConfirmationDialog.confirmed.connect(_on_ConfirmReset)
	load_game()

func _on_IncreaseButton_pressed():
	count += 1 + float(resetbonus * 0.1)
	$CenterContainer/VBoxContainer/NumberLabel.text = str(round(count * 100) / 100.0)

func _on_SaveButton_pressed():
	save_game()

func _on_ResetButton_pressed():
	$ResetConfirmationDialog.popup_centered()

func _on_ConfirmReset():
	if count >= 100:
		resetbonus += int(log(count / 10 + 1))  # Logarithmic return
	count = 0.0
	$CenterContainer/VBoxContainer/NumberLabel.text = str(round(count * 100) / 100.0)
	update_reset_label()
	print("Reset performed. New resetbonus: ", resetbonus)
	save_game()

func update_reset_label():
	$ResetLabel.text = "Current reset bonus: " + str(resetbonus)

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"clicks": count,
		"resetbonus": resetbonus
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
			count = float(data.get("clicks", 0))
			resetbonus = int(data.get("resetbonus", 0))
			$CenterContainer/VBoxContainer/NumberLabel.text = str(round(count * 100) / 100.0)
			update_reset_label()
			print("Game loaded with ", count, " clicks and ", resetbonus, " resetbonus.")
		file.close()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("App is closing — auto-saving.")
		save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		print("App paused — auto-saving.")
		save_game()
