extends Control

var curr_pos
var tempo
const MAX_TEMPO = 230
const MIN_TEMPO = 30

#Grave – slow and solemn (20–40 BPM)
#Lento – slowly (40–45 BPM)
#Largo – broadly (45–50 BPM)
#Adagio – slow and stately (literally, “at ease”) (55–65 BPM)
#Adagietto – rather slow (65–69 BPM)
#Andante – at a walking pace (73–77 BPM)
#Moderato – moderately (86–97 BPM)
#Allegretto – moderately fast (98–109 BPM)
#Allegro – fast, quickly and bright (109–132 BPM)
#Vivace – lively and fast (132–140 BPM)
#Presto – extremely fast (168–177 BPM)
#Prestissimo – even faster than Presto (178 BPM and over)
# key is the minimum threshold to achieve
var tempo_indicator = {40 : "Grave", 45 : "Lento", 50 : "Largo", 65 : "Adagio",
70: "Adagietto", 80: "Andante", 100 : "Moderato", 110 : "Allegretto", 130: "Allegro", 140 : "Vivace",
180 : "Presto", MAX_TEMPO : "Prestissimo"}

func _ready():
	tempo = 30
	$NumberTempo.text = str(tempo)
	set_process(false)
	update_temp_indic()

func _process(delta):
	curr_pos = get_local_mouse_position() #Get the mouse position relative to this item's position (center of circle).
	# upper half - neg y, lower half, pos y. left neg x, right pos x
	#    - - | + -
	#   -----|-----
	#    - + | + +
	#var x = curr_pos.x
	#var y = curr_pos.y
	var angle = fullrad(curr_pos.angle())
	$DialHand.set_rotation(angle)
	
	# note: since coordinates are upside down, increasing tempo is clockwise.
	# May want to rotate x axis later
	
	#$Label.text = str(angle)
	#$Label.text = str(x) + ", " + str(y) + "\n" + str(angle) + "\n" + str(rad2deg(angle))
	#angle = rotate_angle(angle, PI/2)
	
	tempo = round(MIN_TEMPO + (MAX_TEMPO - MIN_TEMPO) * (angle /(2*PI)))
	$NumberTempo.text = str(tempo)
	center_number()
	update_temp_indic()
	#update()
	
	# will probs want to save tempo from last open (add later)
	if Input.is_action_just_released("click"):
		set_process(false)
		
#func set_dial_from_angle(angle):

func set_dial_from_tempo(ntempo):
	#sets tempo, text, and dialhand
	#print("enterd func")
	tempo = ntempo
	#print(tempo, ", ", ntempo)
	$NumberTempo.text = str(tempo)
	var angle = (float(tempo - MIN_TEMPO) / (MAX_TEMPO - MIN_TEMPO)) * 2 * PI
	#print(angle)
	$DialHand.set_rotation(angle)
	

func fullrad(rad):
	if rad < 0:
		rad = 2*PI + rad
	return rad
	
#if delta is positive, rotates to the left from xaxis that many radians
func rotate_angle(rad, delta):
	var nrad = rad-delta
	if nrad < 0:
		nrad = 2*PI - delta - nrad
	return nrad
	
func rotate_tempo(tempo, rad):
	var delta_tempo = (rad/(2*PI)) * (MAX_TEMPO - MIN_TEMPO)
	var ntempo = tempo - delta_tempo
	if ntempo < MIN_TEMPO: # ex. tempo = 70, dtempo = 30, ntempo = 40. tempo = 40, ntempo = 10, but min tempo is 30. 
		ntempo = ntempo #MAX_TEMPO + delta_tempo - MIN_TEMPO + ntempo
	if ntempo > MAX_TEMPO:
		ntempo = MIN_TEMPO + (MAX_TEMPO - ntempo)
	return ntempo
	
#func _draw():
#	var radius = $CollisionShape2D.shape.radius
#	draw_circle(Vector2(0,0), radius, Color.gray)
#	# use angle to draw a line at that angle with length _ at position xcosangle,ycosangle
	
func center_number():
	$NumberTempo.set_pivot_offset($NumberTempo.rect_size / 2)

func _on_DialOuter_gui_input(event):
	if event.is_action_pressed("click"):
		set_process(true)

#binary search to get number, then number to string
var tempo_intervals = [40, 45, 50, 65, 70, 80, 100, 110, 130, 140, 180, MAX_TEMPO]
func update_temp_indic():
	#need to check if tempo is in between two consecutive numbers (comparing must have > or < relation)
	#if tempo > arr[mid/2]
	#else 
	var nearest = tempo_intervals.bsearch(tempo)
	#print("nearest: " + str(nearest))
	$Tempo.text = tempo_indicator.get(tempo_intervals[nearest])
	#assumes keys gets the keys in the same order as in the dictionary
	#for threshold in tempo_indicator.keys():
	#	if threshold < tempo:
	#		$Tempo.text = tempo_indicator.get(threshold)
