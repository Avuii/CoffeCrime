extends Node2D

@onready var buttons := [
	$Control/b0, $Control/b1, $Control/b2, $Control/b3, $Control/b4, $Control/b5, $Control/b6, $Control/b7
]
@onready var gotowe := $Control/Gotowe
@onready var extocafe := $Control/ExToCafe

var selected_buttons: Array = []

func _ready():
	for i in buttons.size():
		buttons[i].pressed.connect(func(idx=i): on_coffee_button_pressed(idx))
	gotowe.pressed.connect(on_ready_pressed)
	#extocafe.pressed.connect(_on_ex_to_cafe_pressed)

func on_coffee_button_pressed(index: int):
	selected_buttons.append(index)
	print("Kliknięcia: ", selected_buttons)

func on_ready_pressed():
	if Global.customer_queue.is_empty():
		print("Brak klientów.")
		return

	var customer = Global.customer_queue[0]
	var expected_order = Global.npc_orders.get(customer.npc_name, "")
	var expected_buttons = Global.coffee_buttons.get(expected_order, [])

	var is_order_correct = selected_buttons == expected_buttons
	print("Poprawna kawa." if is_order_correct else "Niepoprawna kawa.")
	Global.order_successful = is_order_correct
	customer.can_talk = is_order_correct  # <- tutaj

	Global.customer_queue.remove_at(0)
	customer.order_successful = is_order_correct
	await customer.move_to_seat()


	Global.shift_queue()
	


	selected_buttons.clear()

func _on_ex_to_cafe_pressed() -> void:
	get_node("/root/GameRoot").show_location("cafe")
