note
	description: "Core attributes of the game."
	author: "Guillaume Jean"
	date: "19 April 2016"
	revision: "16w11a"

deferred class
	GAME_CORE

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
		do
			context := a_context
		end

feature {NONE} -- Implementation

	context: CONTEXT
			-- Context of the current application

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

	current_player: PLAYER
			-- {PLAYER} currently being controlled by the user

	player_acceleration: REAL_64 = 200.0
			-- Acceleration of the player

	keys: TUPLE[left, right, up, down: BOOLEAN]
			-- Booleans for each movement keys, if true, the key is currently held

	current_map: MAP
			-- Map currently played

	last_frame: NATURAL_32
			-- Time of last update in milliseconds

	time_since_last_frame: REAL_64
			-- Time since last update in seconds

	entities: LIST[ENTITY]
			-- List of all entities to update every tick

	drawables: LIST[DRAWABLE]
			-- List of all objects to render every frame

feature -- Access

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

	update_player_acceleration
			-- Will be ported to {PLAYER} when it becomes controllable
		local
			l_x_accel: REAL_64
			l_y_accel: REAL_64
		do
			l_x_accel := -current_player.speed.x
			l_y_accel := -current_player.speed.y
			if keys.up then
				l_y_accel := l_y_accel - player_acceleration
			end
			if keys.down then
				l_y_accel := l_y_accel + player_acceleration
			end
			if keys.left then
				l_x_accel := l_x_accel - player_acceleration
			end
			if keys.right then
				l_x_accel := l_x_accel + player_acceleration
			end

			current_player.set_acceleration(l_x_accel, l_y_accel)
		end

	update_camera
			-- Update `context.camera's position
		do
			context.camera.move_at_entity(current_player, context.window)
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
