extends Control

# Declare member variables here. Examples:
var tween
var seconds
var elapsed

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_node("Tween")
	elapsed = 0

func _process(delta):
	elapsed += delta
	if int(elapsed) % 60 > 0:
		flash_test()
		elapsed = 0

func flash_test():
	"""Uses tween to flash the opacity of WhiteRect corresponding to the seconds per beat."""
	tween.interpolate_property($WhiteRect, "modulate:a",
		0.7, 0.0, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

#func flash(seconds):
#	"""Uses tween to flash the opacity of WhiteRect corresponding to the seconds per beat."""
#	Tween.interpolate_property($WhiteRect, "modulate:a",
#		0.0, 0.07, seconds,
#		Tween.TRANS_QUAD, Tween.EASE_OUT)
