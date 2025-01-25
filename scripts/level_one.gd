extends Node3D

# Exported property to set the size in the editor
@export var radius: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the collision signals
	var bubble = get_node("Bubble")
	var drop_off = get_node("DropOff")
	print(bubble, drop_off)
	if bubble and drop_off:
		print("Bubble and DropOff nodes found")
		bubble.connect("body_entered", Callable(self, "_on_bubble_body_entered"))
		drop_off.connect("body_entered", Callable(self, "_on_drop_off_body_entered"))

# Signal handler for when the bubble collides with another body
func _on_bubble_body_entered(body: Node) -> void:
	if body.name == "DropOff":
		print("Bubble collided with DropOff")
		_change_lights_color(Color(0, 1, 0)) # Green hue
		_disable_bubble_grab()
		_move_bubble_to_hover_target()

# Signal handler for when the drop off collides with another body
func _on_drop_off_body_entered(body: Node) -> void:
	if body.name == "Bubble":
		print("DropOff collided with Bubble")
		_change_lights_color(Color(0, 1, 0)) # Green hue
		_disable_bubble_grab()
		_move_bubble_to_hover_target()

# Function to change the color of all lights in the scene
func _change_lights_color(color: Color) -> void:
	var lights = get_tree().get_nodes_in_group("Lights")
	for light in lights:
		if light is Light3D:
			light.light_color = color

# Function to disable the bubble's grab ability
func _disable_bubble_grab() -> void:
	var bubble = get_node("Bubble")
	if bubble:
		var collision_shape = bubble.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = true

# Function to move the bubble to the hover target position and disable physics
func _move_bubble_to_hover_target() -> void:
	var bubble = get_node("Bubble")
	var hover_target = get_node("HoverTarget")
	if bubble and hover_target:
		bubble.global_transform.origin = hover_target.global_transform.origin
		bubble.freeze = true
		var laughAudio = hover_target.get_node("Laugh")
		laughAudio.playing = true