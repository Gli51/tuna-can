extends Tabs

var subdivisions = 0
var subdivCap = 10 #This is the maximum number of subdivisions per beat

var playing = false
var time
var beat_timer
signal flash

var taps = []
var tap_index = 0

func _ready():
	#Initializes beat timer and time variable as an additional parameter for signaling flash
	beat_timer = Timer.new()
	add_child(beat_timer)
	beat_timer.autostart = false
	time = time_from_tempo($DialNode.tempo, subdivisions)
	beat_timer.wait_time = time
	beat_timer.connect("timeout", self, "_timeout")
	
	#subtimer - 60/tempo/subdivisions

func _process(delta):
	if playing:
		time = time_from_tempo($DialNode.tempo, subdivisions)
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
		# sets up timer according to new position (seems setting in process takes too long)
		#plays immediately then starts timer for consecutive beats+flashes
		time = time_from_tempo($DialNode.tempo, subdivisions)
		beat_timer.wait_time = time
		$Beats.play()
		emit_signal("flash", time)
		beat_timer.start()
	else:
		beat_timer.stop()
		$Beats.stop()
		
#may need to adjust the speed at which the beat plays also?

func _timeout():
	"""Whenever timer times out, plays beat and emits signal for screen flash."""
	$Beats.play()
	emit_signal("flash", time)
	
func time_from_tempo(tempo, subs):
	""" Changes BPM to seconds per beat """
	return 60.0 / tempo / (subs + 1)
	
func tempo_from_time(time):
	#seconds/beat -> beats/minute
	return (1/time) * 60
	
func avg(arr):
	var sum = 0
	for x in arr:
		sum += x
	return sum / arr.size()
	
func _on_TapButton_button_down():
	#record time, calculate difference in time in seconds. check if it is within range.
	# set BPM text and beat_timer after 3? taps. If time elapsed > 3 seconds, reset the array to empty?
	# changing Dial: change tempo, hand. Changing tempo will affect metronome beats and flashes.
	# Dial currently calculates tempo based on gui_input, should add a function to take changes
	# based on tempo (takes tempo and changes angle and other stuff)
	
	var os_time = OS.get_ticks_msec()
	taps.append(os_time)
	print(taps)
	if taps.size() > 2:
		#calculate average - minimum
		var time = avg(taps) - taps.min()
		
		var max_time = time_from_tempo($DialNode.MIN_TEMPO, 0)
		var min_time = time_from_tempo($DialNode.MAX_TEMPO, 0)
		if time > max_time:
			time = max_time
		elif time < min_time:
			time = min_time
		beat_timer.wait_time = time
		var tempo = tempo_from_time(time)
		$DialNode.tempo = tempo
