note
	description: "Defines and generates the environment of the player ingame."
	author: "Guillaume Jean"
	date: "29 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	MAP

create
	make

feature {NONE} -- Initialization

	make(a_size: TUPLE[width, height: REAL_64])
			-- Initialize `Current' with `a_size' used to create the map boundaries
		do
			side_boxes := [
					create {BOUNDING_PLANE}.make_plane([1.0, 0.0], 0),
					create {BOUNDING_PLANE}.make_plane([-1.0, 0.0], a_size.width),
					create {BOUNDING_PLANE}.make_plane([0.0, 1.0], 0),
					create {BOUNDING_PLANE}.make_plane([0.0, -1.0], a_size.height)
				]
			spawn_enemy_cooldown := 0
			create spawn_enemies_actions
		end

feature {NONE} -- Implementation

	side_boxes: TUPLE[left, right, top, down: BOUNDING_PLANE]
			-- Bounding boxes preventing the entitites from moving outside of `Current'

	spawn_enemy_cooldown_max: REAL_64 = 5.0
			-- Maximum time until spawning an enemy in seconds

	spawn_enemy_cooldown: REAL_64
			-- Time until spawning an enemy in seconds

	should_spawn_enemy: BOOLEAN
			-- Whether or not `Current' should spawn an enemy on next update

feature -- Access

	spawn_enemies_actions: ACTION_SEQUENCE[TUPLE[ENEMY]]
			-- Actions to execute when creating an enemy

	is_entity_in_boundaries(a_entity: ENTITY): BOOLEAN
			-- Checks if `a_entity' is inside the side_boxes
		do
			Result := not (
					a_entity.collides_with_plane(side_boxes.left) or
					a_entity.collides_with_plane(side_boxes.right) or
					a_entity.collides_with_plane(side_boxes.top) or
					a_entity.collides_with_plane(side_boxes.down)
				)
		end

	update(a_timediff: REAL_64)
			-- Updates `Current's state
			-- Spawns new {ENEMY}s from time to time
		do
			if spawn_enemy_cooldown > 0.0 then
				spawn_enemy_cooldown := (0.0).max(spawn_enemy_cooldown - a_timediff)
				if spawn_enemy_cooldown ~ 0.0 then
					should_spawn_enemy := True
				end
			end
			if should_spawn_enemy then
				spawn_enemies_actions.call(create {ENEMY}.make([0.0, 0.0]))
			end
		end

invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
