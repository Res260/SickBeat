note
	description: "Class for user to enter text."
	author: "Alexandre Caron, modified by Émilio Gonzalez with permission"
	date: "04 April 2016"
	see: "https://github.com/LaMachineCaron/Echec"

class
	TEXTBOX

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y, a_width, a_height, a_padding:INTEGER; a_context: CONTEXT)
			-- Create a `Current' using his position and dimension.
		do
			context := a_context
			info := [a_x, a_y, a_width, a_height, a_padding]
			is_selected := False
			create text.make ("", create {GAME_COLOR}.make (0, 0, 0, 255), context)
			clear
		end

feature -- Attributes

	context: CONTEXT
			-- The application's context.
	info:TUPLE[x, y, width, height, padding:INTEGER]
			-- Position and dimension info about the textbox.
	is_selected: BOOLEAN assign set_selected
			-- True if the textbox is currently selected.
	text: TEXT
			-- The text contained in the textbox.
	font_size: INTEGER = 20
			-- The textbox's font size

feature -- Methods

	on_key_pressed(a_key_state: GAME_KEY_STATE)
		do
			if a_key_state.is_backspace then
				sub_text
			else
				if a_key_state.unicode_out.count = 1 then
					add_text (a_key_state.unicode_out)
				end
			end
		end

	clear
			--Clear the text from the Textbox.
		do
			text.set_text (" ")
			text.change (0, 0, font_size)
		end

	add_text(a_text:READABLE_STRING_GENERAL)
			-- Add `a_text' to the `text'.
		do
			text.set_text (text.text+ a_text)
			text.change (0, 0, font_size)
		ensure
			addition_succes: old text.text.count < text.text.count or text.text.count = 0
		end

	sub_text
			-- Delete a charactere from `text'.
		do
			if text.text.count > 1 then
				text.set_text (text.text.substring (1, text.text.count - 1))
				text.change (0, 0, font_size)
			else
				clear
			end
		ensure
			deletion_succes: old text.text.count > text.text.count or text.text.count = 1
		end

	set_selected(a_bool:BOOLEAN)
			-- Set the `is_selected' at `a_bool'.
		do
			is_selected := a_bool
		end

	flashing_cursor(a_factory: RESSOURCE_FACTORY)
			-- Make a little flashing line in the cursor.
		local
			l_position: TUPLE[x, y: INTEGER]
		do
			if is_selected then
				create l_position
				if a_factory.menu_font (30).text_dimension (text.text).width + info.padding < info.width then
					l_position.x := info.x + info.padding + a_factory.menu_font (30).text_dimension (text.text).width
				else
					l_position.x := info.x + info.width - info.padding
				end
				l_position.y := info.y
				context.window.renderer.drawing_color := create {GAME_COLOR}.make (0, 0, 0, 255)
				context.window.renderer.draw_filled_rectangle (l_position.x, l_position.y + 2, 2, info.height - 4)
			end
		end

	draw
		do
			context.window.renderer.drawing_color := create {GAME_COLOR}.make (255, 255, 255, 255)
			context.window.renderer.draw_filled_rectangle (info.x, info.y, info.width, info.height)
			if attached text.texture as la_texture then
				context.window.renderer.draw_texture (la_texture, info.x + info.padding, info.y + info.padding)
			end
		end

invariant

	valid_info_position: info.x >= 0 and info.y >= 0
	valid_info_dimension: info.width > 0 and info.height > 0

note
	copyright: "Copyright (c) 2016, Alexandre Caron"
	license:   "MIT License (see http://opensource.org/licenses/MIT)"
end
