extends Node3D

func _ready():
	if Globals.vr_controls:
		print("OpenXR initialized successfully")
	else:
		print("OpenXR not initialized, please check if your headset is connected")
