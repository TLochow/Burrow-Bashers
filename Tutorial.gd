extends Control

var Start = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("mouse_left"):
		if Start:
			SceneChanger.ChangeScene("res://Main.tscn")
		else:
			$Intro.visible = false
			$Tutorial.visible = true
			Start = true
