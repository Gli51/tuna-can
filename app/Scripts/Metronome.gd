extends Tabs

var subdivisions = 0
var subdivCap = 10 #This is the maximum number of subdivisions per beat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass


func _on_MinusButton_pressed():
	if subdivisions > 0:
		subdivisions -= 1
		$IncrementRow/Ticks/TickContainer/Subdiv.set_text(str(subdivisions))


func _on_Plus_pressed():
	if subdivisions < subdivCap:
		subdivisions += 1
		$IncrementRow/Ticks/TickContainer/Subdiv.set_text(str(subdivisions))
