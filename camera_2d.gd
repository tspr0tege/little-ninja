extends Camera2D

@onready var map: TileMapLayer = $"../../Map/Layer1"
#const maxOffset = Vector2(135, 80)

func _ready():
	
	var level = map.get_used_rect()
	var tileSize = map.rendering_quadrant_size
	
	var leftEdge= level.position.x * tileSize
	var topEdge = level.position.y * tileSize
	self.limit_left = leftEdge
	self.limit_top = topEdge
	self.limit_right = (level.end.x * tileSize) + leftEdge
	self.limit_bottom = (level.end.y * tileSize) + topEdge

func _process(_delta):
	pass
