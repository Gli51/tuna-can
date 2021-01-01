extends Button

var linger_time = 0.5 #in seconds
#onready var pressed_dark = 
#onready var default_dark = 

"""When pressed, plays a tween that makes an extended shape appear behind the button.
Then makes the shape disappear when button is released."""

func _ready():
	rect_pivot_offset = rect_size / 2
	#connect("pressed", self, "fill", [true])
	#connect("released", self "disappear", 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func disappear():
	#GlobalTween.interpolate_property(

#func _on_self_released():
	#disappear

#func _on_self_pressed():
	#Audio.playsound("tap") plays sound