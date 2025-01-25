extends Node3D

# LevelOne res://scenes/levelOne.tscn
# Character res://scenes/character.tscn Called "Character" in the current scene

var level_one_scene = preload("res://scenes/levelOne.tscn")
var character
var camera
var current_level
var level_size = 40 # Adjust this value based on your level size
var levels = [] # Array to keep track of spawned levels
var unload_distance = 30 # Distance beyond which levels will be unloaded

func _ready():
	if Globals.vr_controls:
		print("OpenXR initialized successfully")
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	
	character = $Character # Assuming the character node is a direct child
	camera = character.get_node("XRCamera3D") # Assuming the camera is a child of the character
	
	spawn_level()

func spawn_level():
	current_level = level_one_scene.instantiate()
	add_child(current_level)
	current_level.global_transform.origin = character.global_transform.origin
	levels.append(current_level)

func _process(_delta):
	if character and current_level:
		update_current_level()
		var distance = character.global_transform.origin.distance_to(current_level.global_transform.origin)
		if distance > level_size:
			print("Character has moved beyond the current level")
			# Rotate camera towards the center of the level
			character.look_at(current_level.global_transform.origin, Vector3.UP)
			camera.look_at(current_level.global_transform.origin, Vector3.UP)


func update_current_level():
	var closest_level = null
	var closest_distance = INF
	for level in levels:
		var distance = character.global_transform.origin.distance_to(level.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_level = level
	if closest_level:
		if closest_level != current_level:
			print("Update current level: ", closest_level)
			current_level = closest_level