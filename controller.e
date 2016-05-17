note
	description: "Class containing all the player movement."
	author: "Guillaume Jean"
	date: "2 May 2016"
	revision: "16w12a"

class
	CONTROLLER

create
	make

feature {NONE} -- Initialization

	make(a_mouse: MOUSE)
			-- Initializes `Current' with an existing `a_mouse'.
		do
			create keys
			create number_actions
			create mouse_update_actions
			create mouse_button_update_actions
			create mouse_wheel_actions
			mouse := a_mouse
		end

feature -- Access

	keys: TUPLE[up, down, left, right: BOOLEAN]
			-- Boolean representing whether or not movement keys are currently pressed

	mouse: MOUSE
			-- Current {MOUSE} state

	number_actions: ACTION_SEQUENCE[TUPLE[INTEGER]]
			-- Actions ran when the user presses number keys

	mouse_update_actions: ACTION_SEQUENCE[TUPLE[MOUSE]]
			-- Actions ran when the user updates `mouse's state

	mouse_button_update_actions: ACTION_SEQUENCE[TUPLE[MOUSE]]
			-- Actions ran when a button changes in the `mouse's state

	mouse_wheel_actions: ACTION_SEQUENCE[TUPLE[delta_x, delta_y: INTEGER]]
			-- Actions ran when the user scrolls the mouse wheel

	on_mouse_wheel(a_delta_x, a_delta_y: INTEGER)
			-- Handles the client/server side of the mouse wheel
		do
			mouse_wheel_actions.call(a_delta_x, a_delta_y)
		end

	on_mouse_update(a_mouse_state: GAME_MOUSE_STATE)
			-- Handles the client/server side of mouse_motion
		do
			mouse_update_actions.call(mouse)
		end

	on_mouse_button_update(a_mouse_state: GAME_MOUSE_STATE)
			-- Handles the client/server side of mouse clicks
		do
			mouse_button_update_actions.call(mouse)
		end

	on_key_pressed(a_key_state: GAME_KEY_STATE)
			-- Handles the client/server side of key_pressed
		do
			if a_key_state.is_a then
				keys.left := True
			elseif a_key_state.is_d then
				keys.right := True
			elseif a_key_state.is_w then
				keys.up := True
			elseif a_key_state.is_s then
				keys.down := True
			elseif a_key_state.is_1 then
				number_actions.call(0)
			elseif a_key_state.is_2 then
				number_actions.call(1)
			elseif a_key_state.is_3 then
				number_actions.call(2)
			elseif a_key_state.is_4 then
				number_actions.call(3)
			elseif a_key_state.is_5 then
				number_actions.call(4)
			end
		end

	on_key_release(a_key_state: GAME_KEY_STATE)
			-- Handle the key_release event
			-- Resets the movement key
		do
			if a_key_state.is_a then
				keys.left := False
			elseif a_key_state.is_d then
				keys.right := False
			elseif a_key_state.is_w then
				keys.up := False
			elseif a_key_state.is_s then
				keys.down := False
			end
		end

	clear_keyboard
			-- Sets every key to false
		do
			keys.up := False
			keys.down := False
			keys.left := False
			keys.right := False
		ensure
			Keys_Are_No_Longer_Held: not keys.left and not keys.right and not keys.up and not keys.down
		end

end
