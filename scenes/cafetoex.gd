extends TextureButton

func _ready():
	pressed.connect(_on_CafeToEx_pressed)

func _on_CafeToEx_pressed():
	get_tree().change_scene_to_file("res://scenes/node_2d(ex).tscn")
