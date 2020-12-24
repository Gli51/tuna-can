extends Tabs

var elapsed = 0
var recording = false
var str_elapsed = "00 : 00"

func _ready():
	$HeaderTimer/Timer.set_text(str_elapsed)
	$Lower/RecordButton/ButtonSprite.animation =  "default"

func _process(delta):
	if recording == true:
		elapsed += delta
		_increment_timer()
	else:
		elapsed = 0
		

func _increment_timer():
	"""Called from _process(delta) when recording has started. Increments the minutes and seconds on the timer label."""
	var seconds = int(elapsed) % 60
	var minutes = int(elapsed) / 60
	str_elapsed = "%02d : %02d" % [minutes, seconds]
	$HeaderTimer/Timer.set_text(str_elapsed)

#TODO: Maybe when toggled the timer label can flash opacity to show that it's running!
func _on_TextureButton_toggled(button_pressed):
	"""When recording button is toggled, enables/disables playback button and starts or stops timer."""
	if button_pressed == true:
		str_elapsed = "00 : 00"
		_increment_timer()
		#toggles recording button appearance
		$Lower/RecordButton/ButtonSprite.animation =  "recording"
		#stop any playback that's happening + clear the temp cache
		#disable playback button(greyed out)
		#begin recording from the mic + storing in temp file
	else:
		$Lower/RecordButton/ButtonSprite.animation =  "default"
		#reset record button color
		#enable playback button


func _on_RecordButton_pressed():
	if recording == false:
		recording = true
	else:
		recording = false
	_on_TextureButton_toggled(recording)
	
#function for playback button toggle.
	#even when playback button is on, recording should be enabled, but not vice versa.
	#play stored audio
	#progress the audio visualizer graphics

#function timeout
#after 60 minutes passes, stop recording
#also stop recording once file surpasses available phone memory
func _timeout():
	pass
	#if minutes >= 60:
		#_on_TextureButton_toggled(false)