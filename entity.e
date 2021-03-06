note
	description: "An abstract object which is both drawn and collides with stuff"
	author: "Guillaume Jean"
	date: "23 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

deferred class
	ENTITY

inherit
	PHYSIC_OBJECT
	DRAWABLE

feature {NONE} -- Initialization

	make_entity(a_x, a_y: REAL_64)
			-- Initialize `Current' with the REAL x and y converted to integers
		do
			x_real := a_x
			y_real := a_y
			make_drawable(x, y, Void)
			dead := False
			create death_actions
		end

feature -- Access

	death_actions: ACTION_SEQUENCE[TUPLE[ENTITY]]
			-- Actions to do when `Current' dies

	dead: BOOLEAN
			-- Whether or not `Current' is dead and should be removed

	x_real: REAL_64 assign set_x_real
			-- Real X coordinate

	y_real: REAL_64 assign set_y_real
			-- Real Y coordinate

	update(a_timediff: REAL_64)
			-- Updates the state of `Current'; `a_timediff' is in seconds.
			-- Calls `death_actions' if `Current' is `dead'
		do
			if dead then
				death_actions.call(Current)
			end
		end

	deal_damage(a_damage: REAL_64)
			-- Deals `a_damage' to `Current'
		deferred
		end

	kill
			-- Do stuff when `Current' is removed from the world to cleanup
		do
		end

	set_x_real(a_new_x: REAL_64)
			-- Set the `x_real' and `x' to `a_new_x'
		do
			x_real := a_new_x
			x := a_new_x.rounded
		ensure
			X_Real_Set: x_real = a_new_x
		end

	set_y_real(a_new_y: REAL_64)
			-- Set the `y_real' and `y' to `a_new_y'
		do
			y_real := a_new_y
			y := a_new_y.rounded
		ensure
			Y_Real_Set: y_real = a_new_y
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
