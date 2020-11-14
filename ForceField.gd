extends Area2D

var Active = false
var Direction

var Hamsters = []

func _ready():
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents.y = 16.0

func SetStartPos(pos):
	$StartPos.set_position(pos)
	
func SetEndPos(pos):
	$EndPos.set_position(pos)

func _process(delta):
	if Active:
		for hamster in Hamsters:
			hamster.MovementModulation += Direction.normalized()
	else:
		var startPos = $StartPos.get_position()
		var endPos = $EndPos.get_position()
		Direction = endPos - startPos
		set_position(startPos + (Direction * 0.5))
		set_rotation(Direction.angle())
		$Sprite.region_rect.size.x = Direction.length()
		$CollisionShape2D.shape.extents.x = Direction.length() * 0.5

func Remove():
	call_deferred("queue_free")

func _on_ForceField_body_entered(body):
	Hamsters.append(body)

func _on_ForceField_body_exited(body):
	Hamsters.erase(body)
