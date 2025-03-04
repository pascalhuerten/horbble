extends Area3D

# Property to indicate if a bubble is slotted
var is_slotted: bool = false
var slot_sound
var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Grave ready")
	self.connect("body_entered", _on_body_entered)
	level = get_parent()
	slot_sound = get_node("SlotSound")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Signal handler for when a body enters the area
func _on_body_entered(flower: XRToolsPickable) -> void:
	print("Body entered:", flower.name)
	# Check if bubble in group "Bubbles"
	if not is_slotted and flower.is_in_group("Flowers"):
		# Move the bubble to the slot's position

		var collisionBody = get_node("CollisionShape3D")
		flower.global_transform.origin = collisionBody.global_transform.origin
		# Rotate flower to lie flat on this surface
		# Move a bit higher
		flower.global_transform.origin.y += 0.2

		# Freeze the bubble
		flower.freeze = true
		
		# Set the property to indicate that a bubble is slotted
		is_slotted = true

		# Disable the bubble's grab ability
		flower.enabled = false

		# Play the slot sound
		slot_sound.play()
		
		# Check if all slots are slotted
		if level:
			print("Checking grave slots")
			level.check_slots()
