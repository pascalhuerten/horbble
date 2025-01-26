extends Node3D

# Exported property to set the size in the editor
@export var radius: int = 10

# Bubble Scene is a RigidBody that can be picked up by the user 
var bubble_scene = preload("res://scenes/bubble.tscn")

var bubble_spawn

# List to keep track of spawned bubbles
var bubbles = []

# Maximum distance a bubble can travel before being deleted
@export var max_distance: float = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the collision signals
	bubble_spawn = get_node("BubbleSpawn")
	
	# Create and start the spawn timer
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = 4.0
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", _spawn_bubble)
	# Call it once to start the spawning
	_spawn_bubble()
	add_child(spawn_timer)
	spawn_timer.start()
	
	# Create and start the check timer
	var check_timer = Timer.new()
	check_timer.wait_time = 1.0
	check_timer.one_shot = false
	check_timer.connect("timeout", _check_bubble_positions)
	add_child(check_timer)
	check_timer.start()

# Function to change the color of all lights in the scene
func _change_lights_color(color: Color) -> void:
	var lights = get_tree().get_nodes_in_group("Lights")
	for light in lights:
		if light is Light3D:
			light.light_color = color

# Function to spawn a new bubble at the spawn node
func _spawn_bubble() -> void:
	if bubble_scene and bubble_spawn:
		var new_bubble = bubble_scene.instantiate()
		bubble_spawn.add_child(new_bubble)
		new_bubble.global_transform.origin = bubble_spawn.global_transform.origin
		bubbles.append(new_bubble)

# Function to check the positions of all bubbles and delete those that go far outside
func _check_bubble_positions() -> void:
	var keep_bubbles = []
	for bubble in bubbles:
		if bubble.global_transform.origin.distance_to(bubble_spawn.global_transform.origin) > max_distance:
			bubble.queue_free()
			print("Bubble deleted")
		else:
			keep_bubbles.append(bubble)

	bubbles = keep_bubbles