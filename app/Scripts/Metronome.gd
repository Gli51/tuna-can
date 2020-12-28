extends Tabs

var subdivisions = 0
var subdivCap = 10 #This is the maximum number of subdivisions per beat

var playing = false
var time
var beat_timer
signal flash

var taps = [null, null, null]
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
	return int(60 / time)
	
func avg(arr):
	var sum = 0.0
	for x in arr:
		sum += x
	return sum / arr.size()
	
func num_null(arr):
	var sum = 0
	for x in arr:
		if x == null:
			sum += 1
	return sum
	
func _on_TapButton_button_down():
	#elapsed time in milliseconds since engine started running.
	#Need to test if this causes any issues at long runtimes
	var os_time = OS.get_ticks_msec()
	
	#resets taps array if time since last tap is > 2.5 seconds
	if num_null(taps) == 0 and os_time - taps.max() > 2500:
		taps = [null, null, null]
	
	taps[tap_index] = os_time
	tap_index += 1
	if tap_index > 2:
		tap_index = 0
		
	if num_null(taps) == 0:
		print("enough taps")
		#calculate avg time between taps in seconds
		var time_bw_taps = (avg(taps) - taps.min())/1000.0
		
		# check if tempo is within range - if not, sets to nearest valid tempo
		var max_time = time_from_tempo($DialNode.MIN_TEMPO, 0)
		var min_time = time_from_tempo($DialNode.MAX_TEMPO, 0)
		if time_bw_taps > max_time:
			time_bw_taps = max_time
		elif time_bw_taps < min_time:
			time_bw_taps = min_time
		print(time_bw_taps)
		
		# sets the dial according to tempo
		$DialNode.set_dial_from_tempo(tempo_from_time(time_bw_taps))
	#print(taps)
		
