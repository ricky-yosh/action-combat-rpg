extends Control

@onready var strengh_value: Label = %StrenghValue
@onready var agility_value: Label = %AgilityValue
@onready var speed_value: Label = %SpeedValue
@onready var endurance_value: Label = %EnduranceValue
@onready var level_label: Label = %LevelLabel

@onready var player: Player = get_parent().player

func _ready() -> void:
	update_stats()

func update_stats() -> void:
	strengh_value.text = str(player.stats.strength.ability_score)
	agility_value.text = str(player.stats.agility.ability_score)
	speed_value.text = str(player.stats.speed.ability_score)
	endurance_value.text = str(player.stats.endurance.ability_score)
