note
	description: "Class used to store the ressources only once in RAM."
	author: "Guillaume Jean"
	date: "Thd, 03 March 2016 12:57"
	revision: "16w06a"

class
	RESSOURCE_FACTORY

create
	make

feature {NONE} -- Constants

	ressources_directory: READABLE_STRING_GENERAL
			-- Main ressources directory
		once
			Result := "ressources"
		end

	images_directory: READABLE_STRING_GENERAL
			-- Main images directory
		once
			Result := "images"
		end

	sounds_directory: READABLE_STRING_GENERAL
			-- Main sounds directory
		once
			Result := "sounds"
		end

	fonts_directory: READABLE_STRING_GENERAL
			-- Main fonts directory
		once
			Result := "fonts"
		end

	sounds_extension: READABLE_STRING_GENERAL
			-- Sounds' file extension
		once
			Result := "ogg"
		end

	images_extension: READABLE_STRING_GENERAL
			-- Images' file extension
		once
			Result := "png"
		end

	fonts_extension: READABLE_STRING_GENERAL
			-- Fonts' file extension
		once
			Result := "ttf"
		end

feature {NONE} -- Initialization

	make(a_renderer: GAME_RENDERER; a_format: GAME_PIXEL_FORMAT_READABLE)
			-- Initialization of `Current' using `a_renderer' and `a_format'
			-- to initialize images.
		do
			-- Init all images/sounds
			menu_background := load_image(a_renderer, "main_menu", "background")
		end

feature -- Access

	has_error: BOOLEAN
			-- Previous action caused an error

	menu_background: detachable GAME_TEXTURE
			-- Image texture used in every menus' background

	menu_font(a_size: INTEGER): TEXT_FONT
		local
			l_path: PATH
		do
			create l_path.make_from_string(ressources_directory)
			l_path := l_path.extended(fonts_directory)
			l_path := l_path.extended("ubuntu")
			l_path := l_path.appended_with_extension(fonts_extension)
			create Result.make(l_path.name, a_size)
			if Result.is_openable then
				Result.open
			end
		ensure
			Font_Is_Open: Result.is_open
		end

feature {NONE} -- Implementation

	load_image(a_renderer: GAME_RENDERER; a_sub_folder, a_image_name: READABLE_STRING_GENERAL): detachable GAME_TEXTURE
			-- Loading the image named `a_image_name' into RAM.
		local
			l_image: IMG_IMAGE_FILE
			l_path: PATH
		do
			Result := Void
			create l_path.make_from_string(ressources_directory)
			l_path := l_path.extended(images_directory)
			l_path := l_path.extended(a_sub_folder)
			l_path := l_path.extended(a_image_name)
			l_path := l_path.appended_with_extension(images_extension)
			create l_image.make(l_path.name)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create Result.make_from_image (a_renderer, l_image)
				end
			end
		ensure
			Result_Has_No_Error: attached Result as result_img and then not result_img.has_error
		end
end
