extends Control

var hearts = 4:
	set = set_hearts,
	get = get_hearts;
var max_hearts = 4:
	set = set_max_hearts,
	get = get_max_hearts;

@onready var heartUIFull = $HeartUIFull;
@onready var heartUIEmpty = $HeartUIEmpty;

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts); #current hearts are always between 0 and max_hearts
	if heartUIFull != null:
		heartUIFull.size.x = hearts * 15; 
	
func get_hearts():
	return hearts;

func set_max_hearts(value):
	max_hearts = max(value, 1); #max_hearts can never be less than 1
	set_hearts(min(hearts, max_hearts)); #health can never be larger than max_health
	if heartUIEmpty != null:
		heartUIEmpty.size.x = max_hearts * 15;

func get_max_hearts():
	return max_hearts;
	
func _ready():
	self.max_hearts = PlayerStats.max_health;
	self.hearts = PlayerStats.health;
	PlayerStats.health_changed.connect(self.set_hearts);
	PlayerStats.max_health_changed.connect(self.set_max_hearts);
