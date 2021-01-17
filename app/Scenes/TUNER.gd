extends Tabs

""" Tuner - access microphone and pick up the pitch. 
Graphics - need to show current node and range
Drone - use audio bus to modulate pitch AudioEffectPitchShift
"""
var base_frequency = 440
var octave = 4
var note = "A"

# String range C1 - A7
# Piano range A0-C8
# lowest note for double bass is E1 often tuned to C1 which is even lower
# C1 to A7
# distance b/w C1 and A7 is 6 and 9/12 octaves
# distance b/w C1 and A4 is 3 and 9/12 octaves
# if 1 is C1, then on front side, 0...11/12 are notes of the octave.
# 1/12 is dist b/w half steps

# C1 = 1.0 for set_pitch_scale
# calculate from octave number (1-7) and note (with sharp/flat)
# set_pitch_scale to 
# (octavenumber) + mod the position in the array of the note by 12
# New octave numbers start at "C" - if starting with any other tone, will need to calc an offset

# instead of arr can have a dictionary for faster access...
var note_dict = {"C" : 0, "C#" : 1, "D" : 2, "Eb": 3, "E" : 4, "F" : 5,
 "F#" : 6, "G" : 7, "Ab" : 8, "A" : 9, "Bb": 10, "B" : 11}

#var note_arr = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]

func _ready():
	var idx = AudioServer.get_bus_index("Drone")
	#are busses even relevant when only using pitch scale and volume..?
	var effect = AudioServer.get_bus_effect(idx, 0)
	# difference of 1 pitch = 1 octave. 12 half steps in an octave
	$Drone.set_pitch_scale(1.1)

func _process(delta):
	$Drone.set_pitch_scale(octave + float(note_dict.get(note)) / 12)
	#if !$Drone.playing:
		#$Drone.play()

# change base_frequency button

# play drone button - record a very low pitch audio stream, where set_pitch_scale() to
# 5 is A4 440hz
