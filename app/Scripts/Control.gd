extends Control

var curr_pos
var tempo = 30
const MAX_TEMPO = 230
const MIN_TEMPO = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$NumberTempo.text = str(tempo)
	set_process(false)

func _process(delta):
	curr_pos = get_local_mouse_position() #Get the mouse position relative to this item's position (center of circle).
	# upper half - neg y, lower half, pos y. left neg x, right pos x
	#    - - | + -
	#   -----|-----
	#    - + | + +
	var x = curr_pos.x
	var y = curr_pos.y
	var angle = fullrad(curr_pos.angle())
	$DialHand.set_rotation(angle)
	
	# note: since coordinates are upside down, increasing tempo is clockwise.
	# May want to rotate x axis later
	
	#$Label.text = str(angle)
	#$Label.text = str(x) + ", " + str(y) + "\n" + str(angle) + "\n" + str(rad2deg(angle))
	#angle = rotate_angle(angle, PI/2)
	
	# whole is 220. 220 * angle/2pi
	tempo = round(MIN_TEMPO + (MAX_TEMPO - MIN_TEMPO) * (angle /(2*PI)))
	$NumberTempo.text = str(tempo)
	center_number()
	update()
	
	# will probs want to save tempo from last open (add later)
	if Input.is_action_just_released("click"):
		set_process(false)

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
