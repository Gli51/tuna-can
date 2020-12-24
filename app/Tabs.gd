extends Tabs

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_tab("Metronome")
	#metronome.set_tab_title()
	add_tab("Tuner")
	add_tab("Recordings")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
