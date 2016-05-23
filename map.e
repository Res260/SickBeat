note
	description: "Defines and generates the environment of the player ingame."
	author: "Guillaume Jean and Émilio G!"
	date: "2016-05-21"
	revision: "16w16a"
	legal: "See notice at end of class."

class
	MAP

inherit
	MATH_UTILITY
	GAME_LIBRARY_SHARED
	SOUND_FACTORY_SHARED
	SOUND_MANAGER_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_size: TUPLE[width, height: REAL_64]; a_enemy_textures, a_arc_textures: TUPLE[black, red, green, blue, white:GAME_TEXTURE])
			-- Initialize `Current' with `a_size' used to create the map boundaries
			-- Also sets `enemy_textures' with `a_enemy_textures'
		do
			enemy_textures := a_enemy_textures
			arc_textures := a_arc_textures
			size := a_size
			create sounds
			side_boxes := [
					create {BOUNDING_PLANE}.make_plane([1.0, 0.0], 0),
					create {BOUNDING_PLANE}.make_plane([-1.0, 0.0], -a_size.width),
					create {BOUNDING_PLANE}.make_plane([0.0, 1.0], 0),
					create {BOUNDING_PLANE}.make_plane([0.0, -1.0], -a_size.height)
				]
			enemy_colors := [
						create {GAME_COLOR}.make(0, 0, 0, 255),		-- Black
						create {GAME_COLOR}.make(255, 0, 0, 255),	-- Red
						create {GAME_COLOR}.make(0, 255, 0, 255),	-- Green
						create {GAME_COLOR}.make(0, 0, 255, 255),	-- Blue
						create {GAME_COLOR}.make(255, 255, 255, 255)-- White
					  ]
			sounds := [
						sound_factory.sounds_list[1],
						sound_factory.sounds_list[2],
						sound_factory.sounds_list[3],
						sound_factory.sounds_list[4],
						sound_factory.sounds_list[5]
					  ]
			audio_source_enemy_hit := sound_manager.get_audio_source
			spawn_enemy_cooldown := 0.0
			create spawn_enemies_actions
			create random_generator.set_seed(game_library.time_since_create.as_integer_32)
			spawn_enemies_actions.extend(agent (a_enemy: ENEMY)
								do end)
		end

feature {NONE} -- Implementation

	audio_source_enemy_hit: detachable AUDIO_SOURCE
			-- Audio_source for when any {ENEMY} is hit.

	size: TUPLE[width, height: REAL_64]
			-- Size of `Current'

	side_boxes: TUPLE[left, right, top, down: BOUNDING_PLANE]
			-- Bounding boxes preventing the entitites from moving outside of `Current'

	spawn_enemy_cooldown_interval: REAL_64 = 4.5
			-- Time between spawning an {ENEMY} in seconds

	spawn_enemy_cooldown: REAL_64
			-- Time until spawning the next {ENEMY} in seconds

	should_spawn_enemy: BOOLEAN
			-- Whether or not `Current' should spawn an {ENEMY} on next update

	random_generator: RANDOM
			-- Random number generator to generate the positions of the enemies

	enemy_textures: TUPLE[black, red, green, blue, white:GAME_TEXTURE]
			-- Textures of the enemies

	enemy_colors: TUPLE[black, red, green, blue, white:GAME_COLOR]
			-- Possible  colors of the enemies

	arc_textures: TUPLE[black, red, green, blue, white:GAME_TEXTURE]
			-- Textures of the waves

	sounds: TUPLE[black, red, green, blue, white: SOUND]
			-- Possible sounds of the waves

feature -- Access

	spawn_enemies_actions: ACTION_SEQUENCE[TUPLE[ENEMY]]
			-- Actions to execute when creating an enemy

	start_spawning
			-- Starts the {ENEMY} spawning mechanic
		do
			spawn_enemy_cooldown := spawn_enemy_cooldown_interval
		end

	stop_spawning
			-- Stops the {ENEMY} spawning mechanic
		do
			spawn_enemy_cooldown := 0.0
			should_spawn_enemy := False
		end

	is_entity_outside_boundaries(a_entity: ENTITY): BOOLEAN
			-- Checks if `a_entity' is inside the side_boxes
		local
			l_collides_left, l_collides_right, l_collides_top, l_collides_down: BOOLEAN
		do
			l_collides_left := a_entity.collides_with_plane(side_boxes.left)
			l_collides_right := a_entity.collides_with_plane(side_boxes.right)
			l_collides_top := a_entity.collides_with_plane(side_boxes.top)
			l_collides_down := a_entity.collides_with_plane(side_boxes.down)
			Result := l_collides_left or l_collides_right or l_collides_top or l_collides_down
		end

	update(a_timediff: REAL_64)
			-- Updates `Current's state
			-- Spawns new {ENEMY}s every `spawn_enemy_cooldown_interval' seconds
		local
			l_new_enemy_x, l_new_enemy_y: REAL_64
			l_new_enemy_texture_index: INTEGER
		do
			if spawn_enemy_cooldown > 0.0 then
				spawn_enemy_cooldown := (0.0).max(spawn_enemy_cooldown - a_timediff)
				if spawn_enemy_cooldown ~ 0.0 then
					should_spawn_enemy := True
					spawn_enemy_cooldown := spawn_enemy_cooldown_interval
				end
			end
			if should_spawn_enemy then
				random_generator.forth
				l_new_enemy_x := random_generator.double_item * size.width
				random_generator.forth
				l_new_enemy_y := random_generator.double_item * size.height
				random_generator.forth
				l_new_enemy_texture_index := (random_generator.item \\ enemy_textures.count) + 1
				if attached {GAME_TEXTURE} enemy_textures[l_new_enemy_texture_index] as la_texture
				and attached {GAME_COLOR} enemy_colors[l_new_enemy_texture_index] as la_color
				and attached {GAME_TEXTURE} arc_textures[l_new_enemy_texture_index] as la_arc
				and attached {SOUND} sounds[l_new_enemy_texture_index] as la_sound then
					spawn_enemies_actions.call(
							create {ENEMY}.make(
									[l_new_enemy_x, l_new_enemy_y], la_texture,
									la_color, la_arc, la_sound, audio_source_enemy_hit
									)
							)
					should_spawn_enemy := False
				end
			end
		end

invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
