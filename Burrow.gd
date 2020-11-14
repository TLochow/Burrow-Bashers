extends Area2D

signal Flipped

var HAMSTERSCENE = preload("res://Hamster.tscn")

export var Evil = false
export var SpawnRate = 1
export var MaxHamsters = 10
var Hamsters = 0
var Health = 100.0

onready var Position = get_position()
onready var HamsterNode = get_tree().get_nodes_in_group("HamsterNode")[0]

func _ready():
	if Evil:
		SpawnRate *= 2.0
		MaxHamsters *= 2.0
		$Sprite.modulate = Color(0.5, 0.5, 0.9, 1.0)
		set_collision_mask_bit(5, true)
		add_to_group("EvilBurrows")
	else:
		set_collision_mask_bit(4, true)
		add_to_group("GoodBurrows")

func _process(delta):
	Health = min(Health + delta, 100.0)
	$HealthBar.value = Health

func _on_Timer_timeout():
	for i in range(SpawnRate):
		if Hamsters < MaxHamsters:
			Hamsters += 1
			var hamster = HAMSTERSCENE.instance()
			hamster.Evil = Evil
			hamster.set_position(Position)
			hamster.connect("Died", self, "HamsterDied")
			HamsterNode.add_child(hamster)

func HamsterDied():
	Hamsters -= 1

func Damage():
	Health -= 10.0
	if Health <= 0.0:
		Health = 100.0
		if Evil:
			Evil = false
			MaxHamsters *= 0.5
			SpawnRate *= 0.5
			$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
			set_collision_mask_bit(5, false)
			set_collision_mask_bit(4, true)
			add_to_group("GoodBurrows")
			remove_from_group("EvilBurrows")
		else:
			Evil = true
			MaxHamsters *= 2.0
			SpawnRate *= 2.0
			$Sprite.modulate = Color(0.5, 0.5, 0.9, 1.0)
			set_collision_mask_bit(5, true)
			set_collision_mask_bit(4, false)
			add_to_group("EvilBurrows")
			remove_from_group("GoodBurrows")
		emit_signal("Flipped")
