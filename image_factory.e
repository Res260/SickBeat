note
	description: "Class to make images. In progress."
	author: "Émilio G!"
	date: "16-04-04"
	revision: "16w11a"
	legal: "See notice at end of class."

class
	IMAGE_FACTORY

inherit
	MATH_UTILITY
	IMAGE_GENERATOR_SHARED

create
	make

feature{NONE}

	make(a_renderer:GAME_RENDERER)
		do
			create pixel_format
			pixel_format.set_rgba8888
			renderer := a_renderer
		end

	renderer:GAME_RENDERER
		-- The application's game renderer

	pixel_format:GAME_PIXEL_FORMAT


feature -- Access

	get_player_texture:GAME_TEXTURE
		local
			l_pixel_reader_writer:GAME_PIXEL_READER_WRITER
			l_texture:GAME_TEXTURE_STREAMING
		once
			create l_pixel_reader_writer.make(pixel_format, 100, 100)
			image_generator.make_pixels_transparent(l_pixel_reader_writer)
			image_generator.make_circle(l_pixel_reader_writer, create{GAME_COLOR}.make (150, 0, 0, 255),
			create{GAME_COLOR}.make (255, 50, 50, 255), create{GAME_COLOR}.make (0, 250, 50, 255), 2)

			create l_texture.make (renderer, pixel_format, 100, 100)
			l_texture.enable_alpha_blending
			l_texture.lock
			l_texture.pixels.item.memory_copy (l_pixel_reader_writer.item, l_pixel_reader_writer.width * l_pixel_reader_writer.height * pixel_format.bytes_per_pixel)
			l_texture.unlock
			Result := l_texture
		end

feature{NONE} --Implementation

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
