extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 4.0
@export var drag_sensitivity: float = 1.0

func _unhandled_input(event: InputEvent) -> void:
	# --- PANNING (Middle Mouse Button) ---
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			# Subtract relative motion to "pull" the world
			position -= event.relative * (1.0 / zoom.x) * drag_sensitivity

	# --- ZOOMING (Mouse Wheel) ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_camera(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_camera(-1)

func _zoom_camera(direction: int) -> void:
	var new_zoom = clamp(zoom.x + (direction * zoom_speed), min_zoom, max_zoom)
	zoom = Vector2(new_zoom, new_zoom)
