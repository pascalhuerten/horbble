extends Node3D

# Exported array of slots
@export var slots: Array[NodePath] = []
var portal_active_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal_active_sound = get_node("PortalActiveSound")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Method to check if all slots have been slotted
func check_slots() -> void:
	for slot_path in slots:
		var slot = get_node(slot_path)
		if slot and slot.is_bubble_slotted == false:
			return # If any slot is not slotted, exit the function
	
	# If all slots are slotted, activate and make the portal visible
	var portal = get_node("Portal")
	if portal and not Globals.is_game_over:
		print("Portal activated")
		portal_active_sound.play()
		portal.visible = true
		# Get CollisionShape3D from the portal and enable it
		var collision_shape = portal.get_node("CollisionShape3D")
		if collision_shape:
			collision_shape.disabled = false
			
	# Emit the game_over signal using the global script
	Globals.emit_game_over()
