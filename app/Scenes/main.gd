extends Control

# Declare member variables here. Examples:
var flash_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_flash()
	$Tabs/METRONOME.connect("flash", self, "flash_on_beat")

func spawn_flash():
	var screen_flash = load("res://Scenes/ScreenFlash.tscn")
	flash_instance = screen_flash.instance()
	add_child(flash_instance)
	#flash_instance.visible = false
	
func flash_on_beat(time):
	flash_instance.flash(time)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
