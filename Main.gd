extends Node2D

var FORCEFIELDSCENE = preload("res://ForceField.tscn")
var FIELDREMOVERSCENE = preload("res://FieldRemover.tscn")

var placingField = false
var fieldToPlace

var GameOver = false
var RestartReady = false

var StartMilliseconds
var Milliseconds
var Seconds
var Minutes

func _ready():
	StartMilliseconds = OS.get_ticks_msec()

func SetElapsedTime(label):
	var elapsed = OS.get_ticks_msec() - StartMilliseconds
	Milliseconds = elapsed % 1000
	elapsed -= Milliseconds
	elapsed /= 1000
	Seconds = elapsed % 60
	elapsed -= Seconds
	elapsed /= 60
	Minutes = elapsed
	label.text = "Time: " + str(Minutes) + ":" + str(Seconds) + ":" + str(Milliseconds)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("mouse_left"):
		if GameOver:
			if RestartReady:
				SceneChanger.ChangeScene("res://Main.tscn")
		else:
			placingField = true
			fieldToPlace = FORCEFIELDSCENE.instance()
			fieldToPlace.SetStartPos(.get_global_mouse_position())
			$Fields.add_child(fieldToPlace)
	elif event.is_action_released("mouse_left"):
		placingField = false
		fieldToPlace.Active = true
	elif event.is_action_pressed("mouse_right"):
		var remover = FIELDREMOVERSCENE.instance()
		remover.set_position(.get_global_mouse_position())
		$Fields.add_child(remover)

func _process(delta):
	if not GameOver:
		SetElapsedTime($UI/TimeLabel)
		if placingField:
			fieldToPlace.SetEndPos(.get_global_mouse_position())

func _on_Burrow_Flipped():
	if get_tree().get_nodes_in_group("EvilBurrows").size() == 0:
		GameOver = true
		$UI/GameOver.visible = true
		$UI/GameOver/Win.visible = true
		SetElapsedTime($UI/GameOver/Win/TimeLabel)
		$UI/TimeLabel.visible = false
		$RestartTimer.start()
	elif get_tree().get_nodes_in_group("GoodBurrows").size() == 0:
		GameOver = true
		$UI/GameOver.visible = true
		$UI/GameOver/Loose.visible = true
		$RestartTimer.start()

func _on_RestartTimer_timeout():
	RestartReady = true
