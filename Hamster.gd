extends RigidBody2D

signal Died

var Evil = false
var Dead = false

var BeforePos

var MovementModulation = Vector2(0.0, 0.0)

var noise = OpenSimplexNoise.new()
var noisepos = 0.0

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	$AnimationPlayer.play("Run")
	if Evil:
		set_collision_layer_bit(3, true)
		set_collision_mask_bit(3, true)
		$EnemyDetector.set_collision_layer_bit(4, true)
		$Tween.interpolate_property($Sprite, "modulate", Color(0.0, 0.0, 0.0, 0.0), Color(0.5, 0.5, 0.9, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(2, true)
		$Tween.interpolate_property($Sprite, "modulate", Color(0.0, 0.0, 0.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$EnemyDetector.set_collision_layer_bit(3, true)
		$EnemyDetector.set_collision_layer_bit(5, true)
	$Tween.start()
	BeforePos = get_position()

func _process(delta):
	if not Dead:
		var pos = get_position()
		var angle = pos - BeforePos
		$Sprite.set_rotation(angle.angle())
		BeforePos = pos
		var movementAngle = noise.get_noise_1d(noisepos) * TAU
		var movement = Vector2(cos(movementAngle), sin(movementAngle))
		if not Evil:
			movement += MovementModulation.normalized() * 2.0
		linear_velocity = movement * delta * 600.0
		noisepos += delta * 6.0
		MovementModulation = Vector2(0.0, 0.0)

func Destroy():
	if not Dead:
		Dead = true
		linear_velocity = Vector2(0.0, 0.0)
		emit_signal("Died")
		$AnimationPlayer.play("Dead")
		if Evil:
			set_collision_layer_bit(3, false)
			set_collision_mask_bit(3, false)
			$Tween.interpolate_property($Sprite, "modulate", Color(0.5, 0.5, 0.9, 1.0), Color(0.0, 0.0, 0.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		else:
			set_collision_layer_bit(2, false)
			set_collision_mask_bit(2, false)
			$Tween.interpolate_property($Sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func _on_Tween_tween_all_completed():
	if Dead:
		queue_free()

func _on_EnemyDetector_body_entered(body):
	body.Destroy()
	Destroy()

func _on_EnemyDetector_area_entered(area):
	area.Damage()
	Destroy()
