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

	make_entity(a_x, a_y: REAL_64; a_context: CONTEXT)
			-- Initialize `Current' with the REAL x and y converted to integers
		do
			x_real := a_x
			y_real := a_y
			make_drawable(x, y, Void, a_context)
		end

feature -- Access

	x_real: REAL_64 assign set_x_real
			-- Real X coordinate
	y_real: REAL_64 assign set_y_real
			-- Real Y coordinate

	update(a_timediff: REAL_64)
			-- Ran every game tick for every {ENTITY}.
			-- a_timediff is in seconds.
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
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
