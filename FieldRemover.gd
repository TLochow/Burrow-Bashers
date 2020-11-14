extends Area2D

func _on_FieldRemover_area_entered(area):
	area.Remove()

func _on_Timer_timeout():
	call_deferred("queue_free")
