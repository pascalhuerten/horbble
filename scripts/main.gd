extends Node3D

# LevelOne res://scenes/levelOne.tscn
# Character res://scenes/character.tscn Called "Character" in the current scene

var level_one_scene = preload("res://scenes/levelOne.tscn")
var character
var camera
var current_level
var levels = [] # Array to keep track of spawned levels
var max_distance = 5 # Distance beyond which levels will be unloaded
@export var world_environment_path: NodePath = "WorldEnvironment"
var environment


func _ready():
	if Globals.vr_controls:
		print("OpenXR initialized successfully")
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	
	character = $Character # Assuming the character node is a direct child
	camera = character.get_node("XRCamera3D") # Assuming the camera is a child of the character
	environment = get_node(world_environment_path).environment
	
	spawn_level()

func spawn_level():
	# Spawn the first level if not already spawned
	# Try to get level from current scene
	current_level = get_node("LevelOne")
	if !current_level:
		current_level = level_one_scene.instantiate()
		add_child(current_level)
	current_level.global_transform.origin = character.global_transform.origin
	levels.append(current_level)

func _process(_delta):
	if character and current_level:
		update_current_level()
		var distance = character.global_transform.origin.distance_to(current_level.global_transform.origin)
		print("Distance to current level: ", distance)
		# Update the level_size based on the dimensions
		var level_size = current_level.radius + max_distance
		print("Level size: ", level_size)
		if distance > level_size:
			print("Character has moved beyond the current level")
			# Rotate camera towards the center of the level
			character.look_at(current_level.global_transform.origin, Vector3.UP)
			camera.look_at(current_level.global_transform.origin, Vector3.UP)
			# Move character towards the center of the level by a small amount
			var direction = -camera.global_transform.basis.z.normalized()
			# Move the character towards the center of the level jsut so they are inside the level
			var move_distance = distance - level_size + 0.1
			character.global_transform.origin += direction * move_distance
		
		# Adjust fog density and ambient light intensity based on distance
		# var threshold_distance = level_size * 0.5
		var factor = clamp(distance / level_size, 0.0, 1.0)
		print("Factor: ", factor)
		var threshhold = 0.3
		if factor < threshhold:
			factor = threshhold

		adjust_environment(factor)

func adjust_environment(factor):
		# var light_energy = clamp(0.1 - (0.1 * 1 - factor), 0.0, 0.1)
		var fog_depth_begin_min = 0
		var fog_depth_begin_max = 12.0
		var fog_depth_begin = fog_depth_begin_min + (fog_depth_begin_max - fog_depth_begin_min) * factor

		var brightness = clamp(1.0 - factor, 0.0, 1.0)

		environment.adjustment_brightness = brightness
		environment.fog_depth_begin = fog_depth_begin


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