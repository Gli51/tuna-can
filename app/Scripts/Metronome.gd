extends Tabs

var subdivisions = 0
var subdivCap = 10 #This is the maximum number of subdivisions per beat

var playing = false
var beat_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	beat_timer = Timer.new()
	add_child(beat_timer)
	beat_timer.autostart = false
	beat_timer.wait_time = time_from_tempo($DialNode/DialDisplay.tempo, subdivisions)
	beat_timer.connect("timeout", self, "_timeout")
	
	#subtimer - 60/tempo/subdivisions

func _process(delta):
	if playing:
		# problem: waits until finished playing current sound to play next sound?
		# nope, its because time < 0
		var time = time_from_tempo($DialNode/DialDisplay.tempo, subdivisions)
		print(str(time))
		beat_timer.wait_time = time


func _on_MinusButton_pressed():
	if subdivisions > 0:
		subdivisions -= 1
		$IncrementRow/Ticks/TickContainer/Subdiv.set_text(str(subdivisions))


func _on_Plus_pressed():
	if subdivisions < subdivCap:
		subdivisions += 1
		$IncrementRow/Ticks/TickContainer/Subdiv.set_text(str(subdivisions))

# when toggled on, plays metronome beat every 60/$MetroDial/DialNode/DialDisplay.tempo seconds
# Then add in subdivisions later (maybe a diff sound effect?)

func _on_PlayButton_button_down():
	playing = not playing
	if playing:
		beat_timer.start()
	else:
		beat_timer.stop()
		$Beats.stop()
#may need to adjust the speed at which the beat plays also?
func _timeout():
	$Beats.play()
	
func time_from_tempo(tempo, subs):
	return 60.0 / tempo / (subs + 1)