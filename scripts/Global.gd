extends Node

var customer_queue: Array = []
var current_order_combo: Array = []
var player_combo: Array = []
var order_successful: bool = false
var current_customer = null

var dialogue_balloon_manager: Node = null
var queue_size := 0
var npc_dialogue_counters: Dictionary = {}  # np. { "James": 2 }

#ending
var current_day: int = 1
# Trzyma aktualny zasób dialogu
var current_dialogue_file: Resource = null

# Czy gracz wybrał "Yes" w pierce2.dialogue
var chose_yes: bool = false

# Czy gracz wskazał Pierce jako porywacza
var chose_pierce_in_whois: bool = false

func _ready():
	dialogue_balloon_manager = get_node("/root/DialogueManager")

var coffee_buttons = {
	"Cappuccino": [6,0],
	"Flat white": [6,7],
	"Latte": [0,2],
	"Espresso doppio": [6],
	"Single espresso":[2],
}

var npc_orders = {
	"Marcus": "Cappuccino",
	"Suzie": "Latte",
	"James":"Espresso doppio",
	"Freya": "Latte",
	"Caroline": "Single espresso",
	"Henry": "Espresso doppio",
	"Clara":"Cappucino",
	"Pierce":"Flat white",
	"Ezequiel":"Espresso doppio",
	"Dante":"Cappucino",
	
}

var dialogues = {
	"Marcus": [
		preload("res://dialogi/marcus1.dialogue"),
		preload("res://dialogi/marcus2.dialogue"),
		preload("res://dialogi/marcus3.dialogue")
	],
	"Suzie": [
		preload("res://dialogi/suzie1.dialogue")
	],
	"James": [
		preload("res://dialogi/james1.dialogue"),
		preload("res://dialogi/james2.dialogue"),
		preload("res://dialogi/james3.dialogue"),
		preload("res://dialogi/james4.dialogue")

	],
	"Freya": [
		preload("res://dialogi/freya1.dialogue")
	],

	"Caroline": [
		preload("res://dialogi/caroline1.dialogue"),
		preload("res://dialogi/caroline2.dialogue")
	],
	"Henry": [
		preload("res://dialogi/henry1.dialogue")
	],
	"Clara": [
		preload("res://dialogi/clara1.dialogue"),
		preload("res://dialogi/clara2.dialogue")
	],
	"Pierce": [
		preload("res://dialogi/pierce1.dialogue"),
		preload("res://dialogi/pierce2.dialogue")
	],
	"Ezequiel": [
		preload("res://dialogi/ezequiel1.dialogue")
	],
	"Dante": [
		preload("res://dialogi/dante1.dialogue"),
		preload("res://dialogi/dante2.dialogue")
	]
	
}

var npc_seat_markers := {
	"Marcus": "S1",
	"Suzie": "S2",
	"James": "S3",
	"Freya":"S4",
	"Caroline":"S5",
	"Henry":"S6",
	"Clara":"S4",
	"Pierce":"S6",
	"Ezequiel":"S1",
	"Dante":"S2"
	
}


func shift_queue():
	for i in range(customer_queue.size()):
		var npc = customer_queue[i]
		npc.queue_index = i
		var cafe = get_tree().root.get_node("GameRoot/Cafe")
		var target_pos = cafe.get_queue_position(i)
		npc.move_to_marker(target_pos)
