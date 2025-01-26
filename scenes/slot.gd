extends Area3D

# Property to indicate if a bubble is slotted
var is_bubble_slotted: bool = false
var tor
var slot_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.name, "ready")
	self.connect("body_entered", _on_body_entered)
	tor = get_parent()
	slot_sound = get_node("SlotSound")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Signal handler for when a body enters the area
func _on_body_entered(bubble: XRToolsPickable) -> void:
	print("Body entered:", bubble.name)
	# Check if bubble in group "Bubbles"
	if not is_bubble_slotted and bubble.is_in_group("Bubbles"):
		# Move the bubble to the slot's position
		bubble.global_transform.origin = global_transform.origin
		
		# Freeze the bubble
		bubble.freeze = true
		
		# Set the property to indicate that a bubble is slotted
		is_bubble_slotted = true

		# Disable the bubble's grab ability
		bubble.enabled = false

		# Play the slot sound
		slot_sound.play()
		
		# Check if all slots are slotted
		if tor:
			tor.check_slots()
