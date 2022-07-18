extends TileMap


export(Array, PackedScene) var tile_match:Array = [];
var used_cells:Array = [];
var used_tiles:Array = [];
var tiles_to_remove:PoolVector2Array = [];

var instance


func _ready() -> void:
	used_cells = get_used_cells();
	
	for cell in used_cells:
		used_tiles.append(get_cellv(cell));

	for tile in used_tiles:
		if tile < tile_match.size():
			if tile_match[tile] != null:
				print(tile)
				print(tile_match[tile])
				instance = tile_match[tile].instance();
				instance.position = map_to_world(used_cells[tile]) - tile_set.tile_get_texture(tile).get_size() - Vector2(64, 64);
				instance.rotation = cell_custom_transform.get_rotation()
				add_child(instance);
				set_cellv(used_cells[tile], -1);
