note
	description: "Core attributes of the game."
	author: "Guillaume Jean and Émilio Gonzalez"
	date: "2016-05-16"
	revision: "16w15a"

deferred class
	GAME_CORE

feature {NONE} -- Initialization

	make_core
			-- Initializes `Current's specific features
		do
			create {LINKED_LIST[ENTITY]} dead_entities.make
		end

feature {NONE} -- Implementation

	dead_entities: LIST[ENTITY]
			-- List of entities to kill on next iteration

	frame_display: INTEGER
			-- Number of frames in the past second

	tick_display: INTEGER
			-- Number of ticks in the past second

	frame_counter: INTEGER
			-- Number of frames this second

	tick_counter: INTEGER
			-- Number of ticks this second

	second_counter: REAL_64
			-- Time since last frame

	controller: CONTROLLER
			-- Current state of the user's controls

	score: INTEGER
			-- Score of the local player

	current_map: MAP
			-- Map currently played

	last_frame: NATURAL_32
			-- Time of last update in milliseconds

	time_since_last_frame: REAL_64
			-- Time since last update in seconds

	drawables: LIST[DRAWABLE]
			-- List of all objects to render every frame

feature -- Access

	entities: LIST[ENTITY]
			-- List of all entities to update every tick

	ennemies: LIST[ENEMY]
			-- List of ennemies

	physics: PHYSICS_ENGINE
			-- Physics handling object

	current_player: PLAYER
			-- {PLAYER} currently being controlled by the user

	update_everything(a_time_difference: REAL_64)
			-- Updates every {ENTITY} in `entities'
		do
			current_map.update (a_time_difference)
			across entities as la_entities loop
				la_entities.item.update(a_time_difference)
			end
			across ennemies as la_ennemies loop
				la_ennemies.item.update_state(current_player)
			end
		end

	clear_dead_entities
			-- Deletes every dead {ENTITY}
		do
			from
				dead_entities.start
				entities.start
				drawables.start
				physics.physic_objects.start
			until
				dead_entities.exhausted
			loop
				dead_entities.item.kill
				entities.prune(dead_entities.item)
				drawables.prune(dead_entities.item)
				physics.physic_objects.prune(dead_entities.item)
				dead_entities.forth
			end
			dead_entities.wipe_out
		ensure
			Dead_Entities_Deleted: across old dead_entities as la_dead all
				not entities.has(la_dead.item) and
				not drawables.has(la_dead.item) and
				not physics.physic_objects.has(la_dead.item)
			end
		end

	increment_ticks
			-- Augments the `tick_counter' by one
		do
			tick_counter := tick_counter + 1
		ensure
			Tick_Counter_Incremented: tick_counter = old tick_counter + 1
		end

feature -- Basic Operations

	add_entity_to_world(a_entity: ENTITY)
			-- Adds an `a_entity' to the world
		do
--			if attached {TOURELLE} a_entity as la_tourelle then
--				la_tourelle.launch_wave_event(agent add_entity_to_world)
--			end
			entities.extend(a_entity)
			drawables.extend(a_entity)
			physics.physic_objects.extend(a_entity)
			a_entity.death_actions.extend(agent remove_entity_from_world)
		end

	add_enemy_to_world(a_enemy: ENEMY)
			-- Adds a `a_enemy' to the `ennemies'
		do
			a_enemy.launch_wave_event.extend(agent (a_wave:WAVE)
				do
					add_entity_to_world(a_wave)
				end
			   )
			ennemies.extend (a_enemy)
			entities.extend(a_enemy)
			drawables.extend(a_enemy)
			physics.physic_objects.extend(a_enemy)
			a_enemy.death_actions.extend(agent remove_enemy_from_world)
		end

	remove_entity_from_world(a_entity: ENTITY)
			-- Removed `a_entity' on the next update
		do
			dead_entities.extend(a_entity)
		end

	remove_enemy_from_world(a_enemy: ENEMY)
			-- Removes `a_enemy' on the next update
		do
			dead_entities.extend(a_enemy)
			ennemies.prune(a_enemy)
		end
end
