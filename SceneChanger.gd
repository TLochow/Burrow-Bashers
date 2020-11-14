extends CanvasLayer

var Level = 1

func _ready():
	randomize()
	$AnimationPlayer.play("FadeIn")

func ChangeScene(path):
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(path)
	$AnimationPlayer.play("FadeIn")

func EndGame():
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	get_tree().quit()

func NextLevel():
	Level += 1
	LoadLevel()

func LoadLevel():
	ChangeScene("res://Scenes/Level" + str(Level) + ".tscn")
