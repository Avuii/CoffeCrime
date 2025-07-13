extends TextureButton 

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/node_2d(cafe).tscn")
