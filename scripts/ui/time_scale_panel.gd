extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Button.pressed.connect(func ():
		_set_time_scale(1)
		)
	%Button2.pressed.connect(func ():
		_set_time_scale(2)
		)
	%Button3.pressed.connect(func ():
		_set_time_scale(3)
		)
	%Button4.pressed.connect(func ():
		_set_time_scale(4)
		)
	%Button5.pressed.connect(func ():
		_set_time_scale(6)
		)
	%Button6.pressed.connect(func ():
		_set_time_scale(12)
		)
	%Button7.pressed.connect(func ():
		_set_time_scale(24)
		)
	
	
	
	
	
func _set_time_scale(time_scale :float):
	Engine.time_scale = time_scale
	
	
	
	
