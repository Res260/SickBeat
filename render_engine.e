note
	description: "Summary description for {RENDER_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RENDER_ENGINE

feature -- Initialization

	drawables: LIST [DRAWABLE]
			-- `drawables'
		attribute check False then end end --| Remove line when `drawables' is initialized in creation procedure.

feature -- Access

	rendered_menu: MENU
			-- `rendered_menu'
		attribute check False then end end --| Remove line when `rendered_menu' is initialized in creation procedure.

	rendered_map: MAP
			-- `rendered_map'
		attribute check False then end end --| Remove line when `rendered_map' is initialized in creation procedure.

end
