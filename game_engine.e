note
	description: "{GAME_ENGINE} is a basic mechanics {ENGINE}."
	author: "Guillaume Jean"
	date: "Tue, 23 Fev 2016 09:15:00"
	revision: "0.1"

class
	GAME_ENGINE

create
	make

feature {NONE} -- Initialization
	make
		do

		end

feature -- Initialization

	renderer: RENDER_ENGINE
			-- `renderer'
		attribute check False then end end --| Remove line when `renderer' is initialized in creation procedure.

	current_player: PLAYER
			-- `current_player'
		attribute check False then end end --| Remove line when `current_player' is initialized in creation procedure.

	network: NETWORK_ENGINE
			-- `network'
		attribute check False then end end --| Remove line when `network' is initialized in creation procedure.

feature -- Access

	sound: SOUND_ENGINE
			-- `sound'
		attribute check False then end end --| Remove line when `sound' is initialized in creation procedure.

	menu_tree: MENU
			-- `menu_tree'
		attribute check False then end end --| Remove line when `menu_tree' is initialized in creation procedure.

	current_menu: MENU
			-- `current_menu'
		attribute check False then end end --| Remove line when `current_menu' is initialized in creation procedure.

	hud_items: LIST [HUD_ITEM]
			-- `hud_items'
		attribute check False then end end --| Remove line when `hud_items' is initialized in creation procedure.

	current_map: MAP
			-- `current_map'
		attribute check False then end end --| Remove line when `current_map' is initialized in creation procedure.

	physics: PHYSICS_ENGINE
			-- `physics'
		attribute check False then end end --| Remove line when `physics' is initialized in creation procedure.

	entities: LIST [ENTITY]
			-- `entities'
		attribute check False then end end --| Remove line when `entities' is initialized in creation procedure.

end
