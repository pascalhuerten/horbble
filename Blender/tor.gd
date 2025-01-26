extends Node3D

# Exported array of slots
@export var slots: Array[NodePath] = []
var portal_active_sound
var portal
var portal_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal_active_sound = get_node("PortalActiveSound")
	portal = get_node("Portal")

	# on body entered for portal with "Player" emits game_over signal
	portal.connect("body_entered", _on_portal_entered)

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
	if portal and not Globals.is_game_over:
		print("Portal activated")
		portal_active_sound.play()
		# Get Node "PortalMesh"
		var mesh = portal.get_node("PortalMesh")
		mesh.visible = true
		portal_active = true

func _on_portal_entered(player: Node):
	print(player.name, "entered the portal")
	if portal_active and player.name == "PlayerBody":
		# Emit the game_over signal using the global script
		Globals.emit_game_over()