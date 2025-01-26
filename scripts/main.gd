extends Node3D

# LevelOne res://scenes/levelOne.tscn
# Player res://scenes/player.tscn Called "Player" in the current scene

var level_one_scene = preload("res://scenes/levelOne.tscn")
var player
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
	
	player = $Player # Assuming the player node is a direct child
	print("Player node:", player)
	camera = player.get_node("XRCamera3D") # Assuming the camera is a child of the player
	environment = get_node(world_environment_path).environment
	
	current_level = get_node("LevelOne")

	# Connect to the game_over signal from the Global script
	Globals.connect("game_over", _on_game_over)


func spawn_level(level):
	# Spawn the first level if not already spawned
	# Try to get level from current scene
	current_level = level.instantiate()
	add_child(current_level)
	# TODO: Set location of the level
	levels.append(current_level)

func _process(_delta):
	if player and current_level:
		var distance = player.global_transform.origin.distance_to(current_level.global_transform.origin)
		# Update the level_size based on the dimensions
		var level_size = current_level.radius + max_distance
		if distance > level_size:
			# Calculate the direction from the player to the center of the level
			var direction_to_center = (current_level.global_transform.origin - player.global_transform.origin).normalized()
			
			# Calculate the new position on the opposite side of the circle
			var new_position = current_level.global_transform.origin + direction_to_center * level_size
			
			# Move the player to the new position
			player.global_transform.origin = new_position

			# Make the camera look towards the center of the level
			camera.look_at(current_level.global_transform.origin, Vector3.UP)
		
		# Adjust fog density and ambient light intensity based on distance
		var threshold_distance = level_size * 0.5
		# Calculate a factor between 0 and 1 based on the distance from the level excluding a zone near the middle, so factor 0 should start at 0.5 * level_size
		var factor = clamp((distance - threshold_distance) / threshold_distance, 0.0, 1.0)
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
		var distance = player.global_transform.origin.distance_to(level.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_level = level
	if closest_level:
		if closest_level != current_level:
			current_level = closest_level


# Method to handle the game_over signal
func _on_game_over() -> void:
	print("Game Over: All slots are slotted and the portal is activated.")
	# Add your game over logic here, such as displaying a game over screen or restarting the level