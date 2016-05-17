note
	description: "Class to hold texture and information about a user's score"
	author: "Émilio Gonzalez"
	date: "2016-05-17"
	revision: "16w15b"
	legal: "See notice at end of class."

class
	HUD_SCORE

inherit
	HUD_INFORMATION
		redefine
			draw
		end

create
	make

feature

	make(a_score: INTEGER; a_x, a_y: INTEGER; a_ip: READABLE_STRING_GENERAL ; a_context: CONTEXT)
			-- Initializes `Current' with a score (`a_score'), a position (`a_x', `a_y'), a source (`a_ip') and with `a_context'.
		do
			value := a_score
			ip := a_ip
			create text.make ("Score of " + ip + ": " + a_score.to_hex_string, create {GAME_COLOR}.make (0, 0, 0, 255), a_context)
			text.change (a_x, a_y, 15)
			make_drawable(a_x, a_y, text.texture, a_context)
		end

	ip: READABLE_STRING_GENERAL
			-- Ip of the person for whom `Current' belongs

	text: TEXT
			-- The score's texture holder

	draw
			--Draws `text' on the screen when called
		do
			if attached text.texture as la_texture then
				context.renderer.draw_texture(la_texture, x, y)
			end
		end

	update_value(a_new_score: ANY)
			-- Changes `value' using `a_new_score' and updates `text' too
		do
			if attached {INTEGER} a_new_score as la_score then
				value := la_score
				text.set_text ("Score of " + ip + ": " + la_score.to_hex_string)
				text.change (text.x, text.y, 15)
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
