note
	description: "Class that creates (generates) sounds for the game."
	author: "Émilio G!"
	date: "16-3-21"
	revision: "16w08a"

class
	SOUND_FACTORY

inherit
	SOUND_GENERATOR_SHARED

create
	make

feature --Initialization

	make
		do

		end

feature --Access

	create_sound_menu_click:SOUND
		--Method that creates a sound for a menu button click.
		local
			l_wave:LIST[INTEGER_16]
			l_wave2: LIST[INTEGER_16]
			l_sound: SOUND
			l_1:INTEGER_16
			l_2:INTEGER_16
		do
			l_wave:= sound_generator.create_sine_wave(90, 415)
			sound_generator.repeat_wave_from_duration(l_wave, 1)
			create l_sound.make(l_wave)
			Result:= l_sound
		end

end
