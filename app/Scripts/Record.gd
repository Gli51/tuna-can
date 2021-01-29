extends Tabs

var elapsed = 0
var str_elapsed = "00 : 00"

var recording_bus
var recording
var recordingname

func _ready():
	$HeaderTimer/Timer.set_text(str_elapsed)

	var rec_idx = AudioServer.get_bus_index("Record")
	recording_bus = AudioServer.get_bus_effect(rec_idx, 0)
	
	$Lower/RecordButton/MicIcon.visible = true
	$Lower/RecordButton/StopIcon.visible = false
	
	$HeaderTimer/PlaybackButton/PlaybackIcon.visible = true
	$HeaderTimer/PlaybackButton/PlaybackPauseIcon.visible = false

func _process(delta):
	if recording_bus.is_recording_active():
		elapsed += delta
		increment_timer()
	else:
		elapsed = 0
		#TODO: this may check unnecessarily. Want to make sure after finishing playing, the playback skin is correct
		if $Playback.playing and !$Playback.stream_paused:
			$HeaderTimer/PlaybackButton/PlaybackIcon.visible = false
			$HeaderTimer/PlaybackButton/PlaybackPauseIcon.visible = true
		else:
			$HeaderTimer/PlaybackButton/PlaybackIcon.visible = true
			$HeaderTimer/PlaybackButton/PlaybackPauseIcon.visible = false
		

func increment_timer():
	"""Called from _process(delta) when recording has started. Increments the minutes and seconds on the timer label."""
	var seconds = int(elapsed) % 60
	var minutes = int(elapsed) / 60
	str_elapsed = "%02d : %02d" % [minutes, seconds]
	$HeaderTimer/Timer.set_text(str_elapsed)

#TODO: Maybe when toggled the timer label can flash opacity to show that it's running!
func _on_RecordButton_toggled(button_pressed):
	"""When recording button is toggled, enables/disables playback button and starts or stops timer."""
	if button_pressed == true:
		str_elapsed = "00 : 00"
		increment_timer()
		$Lower/RecordButton/MicIcon.visible = false
		$Lower/RecordButton/StopIcon.visible = true
		#stop any playback that's happening + clear the temp cache
		#disable playback button(greyed out)
		#begin recording from the mic + storing in temp file
	else:
		$Lower/RecordButton/MicIcon.visible = true
		$Lower/RecordButton/StopIcon.visible = false
		#enable playback button


func _on_RecordButton_pressed():
	if recording_bus.is_recording_active():
		recording = recording_bus.get_recording()
		recording_bus.set_recording_active(false)

		print("recording saved")
		
		#saving the recording, additional permissions for WRITE EXTERNAL STORAGE or request_permission(RECORD_AUDIO)?
		recordingname = "test"
		var dir = Directory.new()
		dir.make_dir(OS.get_system_dir(2) + "/tunacan/")
		var pathname = OS.get_system_dir(2) + "/tunacan/" + recordingname + ".wav" #"res://test.wav" # 
		recording.save_to_wav(pathname)
	else:
		recording_bus.set_recording_active(true)
	_on_RecordButton_toggled(recording_bus.is_recording_active())

#function timeout
#after 60 minutes passes, stop recording
#also stop recording once file surpasses available phone memory
func time_out():
	pass
	#if minutes >= 60:
		#_on_TextureButton_toggled(false)
		
#function for playback button toggle.
	#even when playback button is on, recording should be enabled, but not vice versa.
	#play stored audio
	#progress the audio visualizer graphics		
# button shows triangle whenever recording isn't playing, pause button otherwise.
# if recording is playing, can pause, or wait for recording to end.
# if recording not playing, can start playing or unpause (are they different?)
func _on_PlaybackButton_pressed():
	print("toggled")
	if not recording_bus.is_recording_active() and recording != null:
		print("playback toggle valid")
		if $Playback.playing == false:
			print("play")
			$Playback.stream = recording
			$Playback.play()
		#when you want to pause
		else:
			$Playback.stream_paused = !$Playback.stream_paused
