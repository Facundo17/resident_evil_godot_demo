extends BoneAttachment3D

@export var footSteps: AudioStreamPlayer

func _on_foot_detection_body_entered(body):
	if body.name == "piso":
		footSteps.play()
