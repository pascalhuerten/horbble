extends RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

# Called to integrate forces for the physics body
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
    # Apply an upward force to simulate floating
    var upward_force = Vector3(0, 10, 0) # Adjust the value as needed
    state.apply_central_force(upward_force)