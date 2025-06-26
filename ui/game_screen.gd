extends CanvasLayer

@onready var collection_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Control/CollectionLabel

func _ready():
	CollectiblesManager.on_collectible_award_received.connect(on_collectible_award_received)
	
func on_collectible_award_received(total_award : int):
		collection_label.text = str(total_award)
