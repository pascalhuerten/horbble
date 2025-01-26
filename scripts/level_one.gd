extends Node3D

# Exported property to set the size in the editor
@export var radius: int = 10
# Maximum distance a bubble can travel before being deleted
@export var max_distance: float = 300.0

# Exported array of slots
@export var slots: Array[NodePath] = []
var portal_active_sound
var portal_active = false

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
		if slot and slot.is_slotted == false:
			return # If any slot is not slotted, exit the function
	
	print("Level one finished activated")
	portal_active_sound.play()
	portal_active = true
	Globals.emit_level_one_finished()
