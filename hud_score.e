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

	make(a_score: INTEGER; a_x, a_y: INTEGER; a_ip: READABLE_STRING_GENERAL; a_context: CONTEXT)
			-- Initializes `Current' with score `a_score', position (`a_x', `a_y'), source `a_ip' and `a_context' to create the texture.
		do
			context := a_context
			value := a_score
			ip := a_ip
			should_draw := a_score >= 0
			create text.make ("Score of " + ip + ": " + a_score.to_hex_string, create {GAME_COLOR}.make (0, 0, 0, 255))
			text.change (a_x, a_y, 15, context)
			make_drawable(a_x, a_y, text.texture)
		end

	ip: READABLE_STRING_GENERAL
			-- Ip of the person for whom `Current' belongs

	text: TEXT
			-- The score's texture holder

	context: CONTEXT
			-- Context used to

	should_draw: BOOLEAN assign set_should_draw
			-- Whether or not `Current' should draw itself

	draw(a_context: CONTEXT)
			--Draws `text' on the screen when called
		do
			if attached text.texture as la_texture and should_draw then
				a_context.renderer.draw_texture(la_texture, x, y)
			end
		end

	update_value(a_new_score: ANY)
			-- Changes `value' using `a_new_score' and updates `text' too
		do
			if attached {INTEGER} a_new_score as la_score then
				value := la_score
				text.set_text ("Score of " + ip + ": " + la_score.to_hex_string)
				text.change (text.x, text.y, 15, context)
			end
		end

	set_should_draw(a_should_draw: BOOLEAN)
			-- Sets `should_draw' to `a_should_draw'
		do
			should_draw := a_should_draw
		ensure
			Sets_Value: should_draw = a_should_draw
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
