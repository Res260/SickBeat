note
	description: "Class to make images. In progress."
	author: "Émilio G!"
	date: "2016-05-03"
	revision: "16w12b"
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
		-- Initializes `Current's internal attributes
		do
			create pixel_format
			create player_textures
			create arc_textures
			pixel_format.set_rgba8888
			renderer := a_renderer
		end

	renderer:GAME_RENDERER
		-- The application's game renderer

	pixel_format:GAME_PIXEL_FORMAT
		-- The pixel format used for the textures

	player_texture_dimension:INTEGER_32 = 100
		-- The player's texture's width and height.

	player_textures:TUPLE[black, red, green, blue, white:GAME_TEXTURE]
		-- The player's textures

	arc_textures:TUPLE[black, red, green, blue, white: GAME_TEXTURE]
		-- The arcs textures

feature -- Access

	player_arc_angle: REAL_64
			-- The player's normal arcs' length (in rad).
		once
			Result := Pi_2
		end

	make_all_textures
			-- Stores the player textures in the tuple and the arcs.
		once("PROCESS")
			player_textures.black := make_player_texture(
				create{GAME_COLOR}.make (0, 0, 0, 255),
				create{GAME_COLOR}.make (100, 100, 100, 255)
				)
			player_textures.red := make_player_texture(
				create{GAME_COLOR}.make (255, 0, 0, 255),
				create{GAME_COLOR}.make (255, 150, 150, 255)
				)
			player_textures.green := make_player_texture(
				create{GAME_COLOR}.make (0, 255, 0, 255),
				create{GAME_COLOR}.make (150, 255, 150, 255)
				)
			player_textures.blue := make_player_texture(
				create{GAME_COLOR}.make (0, 0, 255, 255),
				create{GAME_COLOR}.make (150, 150, 255, 255)
				)
			player_textures.white := make_player_texture(
				create{GAME_COLOR}.make (190, 190, 190, 255),
				create{GAME_COLOR}.make (255, 255, 255, 255)
				)

			arc_textures.black := make_arc(create{GAME_COLOR}.make (0, 0, 0, 255))
			arc_textures.red := make_arc(create{GAME_COLOR}.make (255, 0, 0, 255))
			arc_textures.green := make_arc(create{GAME_COLOR}.make (0, 255, 0, 255))
			arc_textures.blue := make_arc(create{GAME_COLOR}.make (0, 0, 255, 255))
			arc_textures.white := make_arc(create{GAME_COLOR}.make (255, 255, 255, 255))
		end

	get_player_texture_tuple:TUPLE[black, red, green, blue, white: GAME_TEXTURE]
			-- Returns a tuple containing the player's textures
		once("PROCESS")
			Result := player_textures
		end

	get_arcs_texture_tuple:TUPLE[black, red, green, blue, white: GAME_TEXTURE]
			-- Returns a tuple containing the arcs' textures
		once("PROCESS")
			Result := arc_textures
		end

	make_player_texture(a_texture_color_begin, a_texture_color_end:GAME_COLOR):GAME_TEXTURE
			--Makes the player texture of color a_texture_color_begin to a_texture_color_end
		local
			l_pixels:GAME_PIXEL_READER_WRITER
		do
			l_pixels := make_transparent_texture(player_texture_dimension, player_texture_dimension)
			image_generator.make_circle(l_pixels, a_texture_color_begin,
				a_texture_color_end, void, 0
				)
			Result := make_texture_from_pixels(l_pixels)
		end

	make_arc(a_color:GAME_COLOR):GAME_TEXTURE
			-- Makes and returns an arc of color a_color.
		local
			l_pixels:GAME_PIXEL_READER_WRITER
		do
			l_pixels := make_transparent_texture(400,400)
			image_generator.make_arc(l_pixels, a_color,
						[(l_pixels.height / 2), (l_pixels.width / 2)], 0, player_arc_angle, l_pixels.height // 2, 75)
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
