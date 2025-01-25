extends XROrigin3D

var camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = $XRCamera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_up"):
		print("Moving character forward")
		var direction = -camera.global_transform.basis.z.normalized()
		global_transform.origin += direction
		print("Character position: ", global_transform.origin)
