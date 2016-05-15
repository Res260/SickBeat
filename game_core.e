note
	description: "Core attributes of the game."
	author: "Guillaume Jean"
	date: "19 April 2016"
	revision: "16w11a"

deferred class
	GAME_CORE

feature {NONE} -- Implementation

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

--	controller: CONTROLLER
--			-- Current state of the user's controls

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

	physics: PHYSICS_ENGINE
			-- Physics handling object

	update_everything(a_time_difference: REAL_64)
			-- Updates every {ENTITY} in `entities'
			-- Clears every {WAVE} that is no longer visible in the screen
		local
			l_to_remove: LINKED_LIST[ENTITY]
		do
			create l_to_remove.make
			across entities as la_entities loop
				la_entities.item.update(a_time_difference)
				if attached {WAVE} la_entities.item as la_wave then
					if la_wave.dead then
						l_to_remove.extend(la_wave)
					end
				end
			end
			from
				l_to_remove.start
				entities.start
				drawables.start
				physics.physic_objects.start
			until
				l_to_remove.exhausted
			loop
				entities.prune(l_to_remove.item)
				drawables.prune(l_to_remove.item)
				physics.physic_objects.prune(l_to_remove.item)
				l_to_remove.forth
			end
		ensure
			Entities_Out_Of_Bounds_Deleted: across entities as la_entities all
												if attached {WAVE} la_entities.item as la_wave then
													not la_wave.dead
												else
													True
												end
											end
			Drawables_Out_Of_Bounds_Deleted: across drawables as la_drawables all
												if attached {WAVE} la_drawables.item as la_wave then
													not la_wave.dead
												else
													True
												end
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
			-- Adds an entity to the world
		do
--			if attached {TOURELLE} a_entity as la_tourelle then
--				la_tourelle.launch_wave_event(agent add_entity_to_world)
--			end
			entities.extend(a_entity)
			drawables.extend(a_entity)
			physics.physic_objects.extend(a_entity)
		end
end
