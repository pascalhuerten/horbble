extends Node

var xr_interface: XRInterface = null
var vr_controls: bool = false
var is_game_over: bool = false

# Define the game_over signal
signal game_over

func _ready():
    xr_interface = XRServer.find_interface("OpenXR")
    if xr_interface and xr_interface.is_initialized():
        vr_controls = true
        print("OpenXR initialized successfully")

        # Turn off v-sync!
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

        # Change our main viewport to output to the HMD
        get_viewport().use_xr = true
    else:
        print("OpenXR not initialized, please check if your headset is connected")
        vr_controls = false

# Method to emit the game_over signal
func emit_game_over() -> void:
    if not is_game_over:
        is_game_over = true
        emit_signal("game_over")