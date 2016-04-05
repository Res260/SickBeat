note
	description: "Draws on the screen all the drawables provided."
	author: "Guillaume Jean"
	date: "30 March 2016"
	revision: "16w09a"
	legal: "See notice at end of class."

class
	RENDER_ENGINE

create
	make

feature -- Initialization

	make(a_map: MAP; a_context: CONTEXT)
			-- Initialize `Current' with the map
		do
			context := a_context
			current_map := a_map
		end

feature {NONE} -- Implementation

	context: CONTEXT
			-- Current context of the application

	current_map: MAP
			-- Map used to draw the background

feature -- Access

	camera: detachable CAMERA assign set_camera
			-- Camera used to offset all drawables when drawing them

	set_camera(a_new_camera: detachable CAMERA)
			-- Changes `Current's camera
		do
			if attached a_new_camera as la_new_camera then
				camera := la_new_camera
			end
		ensure
			Attached_Camera_Sets_Camera: attached a_new_camera implies camera = a_new_camera
		end

	render(a_drawables: LIST[DRAWABLE])
			-- Draws `background' with the `a_drawables' on top of it
		require
			Camera_Exists: attached camera
		do
			context.renderer.clear

			check attached camera as la_camera then
					-- Camera should always be attached when rendering stuff
					-- No Camera = No Rendering (Where are you even looking at without a camera?)
				current_map.background.draw(la_camera)

				across a_drawables as la_drawables loop
					la_drawables.item.draw(la_camera)
				end
			end

			context.window.update
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
