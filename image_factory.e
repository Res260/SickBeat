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

	get_player_texture_red:GAME_TEXTURE
			--Creates once and returns the player texture (red).
		local
			l_pixels:GAME_PIXEL_READER_WRITER
			l_texture:GAME_TEXTURE_STREAMING
		once
			l_pixels := make_transparent_texture(70,70)
			image_generator.make_circle(l_pixels, create{GAME_COLOR}.make (255, 0, 0, 255),
			create{GAME_COLOR}.make (130, 0, 0, 255), create{GAME_COLOR}.make (130, 0, 0, 255), 2)

			Result := make_texture_from_pixels(l_pixels)
		end

feature{NONE} --Implementation

	make_texture_from_pixels(a_pixels:GAME_PIXEL_READER_WRITER):GAME_TEXTURE
			--Makes a texture from a GAME_PIXEL_READER_WRITER and returns the new GAME_TEXTURE
		local
			l_texture:GAME_TEXTURE_STREAMING
		do
			create l_texture.make (renderer, pixel_format, a_pixels.width, a_pixels.height)
			l_texture.enable_alpha_blending
			l_texture.lock
			l_texture.pixels.item.memory_copy (a_pixels.item, a_pixels.width * a_pixels.height * pixel_format.bytes_per_pixel)
			l_texture.unlock
			Result := l_texture
		end

	make_transparent_texture(a_width, a_height:INTEGER_32):GAME_PIXEL_READER_WRITER
			--Creates and returns a GAME_PIXEL_READER_WRITER of dimension a_width x a_height
			--and makes it transparent.
		require
			Width_Valid: a_width > 0
			Height_Valid: a_height > 0
		local
			l_pixels:GAME_PIXEL_READER_WRITER
		do
			create l_pixels.make(pixel_format, a_width, a_height)
			image_generator.make_pixels_transparent(l_pixels)
			Result := l_pixels
		ensure
			Width_Valid: Result.width = a_width
			Height_Valid: Result.height = a_height
		end


note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
