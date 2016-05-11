note
	description: "Summary description for {GAME_NETWORK}."
	author: "Émilio Gonzalez"
	date: "2016-04-09"
	revision: "16w14a"

class
	GAME_NETWORK

inherit
	GAME_CORE

create
	make

feature
	make(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
		local
			l_background: BACKGROUND
			l_mouse: MOUSE
		do
			network_engine := a_network_engine
			create physics.make
			create l_mouse.make(0, 0)
			create controller.make(l_mouse)
--			create current_player.make(controller, a_context)
			create {LINKED_LIST[ENTITY]} entities.make
			create {ARRAYED_LIST[DRAWABLE]} drawables.make(0)
			create l_background.make_movable(a_context.ressource_factory.game_background, [3840, 2160], a_context)
			create current_map.make(l_background, a_context)
--			entities.extend(current_player)
--			drawables.extend(current_player)
--			physics.physic_objects.extend(current_player)
			time_since_last_frame := 0
			last_frame := 0
--			controller.mouse_update_actions.extend(agent current_player.on_click)
--			controller.mouse_wheel_actions.extend(agent current_player.on_mouse_wheel)
--			controller.number_actions.extend(agent current_player.set_color_index)
--			current_player.collision_actions.extend(agent (a_physic_object: PHYSIC_OBJECT)
--														do
--															io.put_string("BOOM!")
--														end
--												   )
--			current_player.launch_wave_event.extend(agent (a_wave:WAVE) do add_entity_to_world(a_wave) end )
			create server_thread.make(agent run)
			server_thread.launch

		end

	routine_batarde(a_wave:WAVE)
		do
			add_entity_to_world(a_wave)
		end

	server_thread:FLEXIBLE_THREAD

	network_engine: NETWORK_ENGINE
	run
		do
			from
			until
				false
			loop
--				print("Kappa")
			end
		end

end
