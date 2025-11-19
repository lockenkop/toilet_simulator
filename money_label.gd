extends Label

var money: int = 0

func add(value: int):
	money += value
	text = "Money: %s" %money
	
func subtract(value: int):
	money -= value
	text = "Money: %s" %money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
