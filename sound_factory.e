note
	description: "Class that creates (generates) sounds for the game."
	author: "Émilio G!"
	date: "16-3-29"
	revision: "16w08b"

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
			l_wave : LIST[INTEGER_16]
			l_wave2: LIST[INTEGER_16]
			l_wave3: LIST[INTEGER_16]
			l_sound: SOUND
			l_initial_frequency: INTEGER_32
		do
			l_initial_frequency := 200
			l_wave:= sound_generator.create_sine_wave(70, l_initial_frequency)
			sound_generator.repeat_wave_from_duration(l_wave, 0.15)
			sound_generator.fade (l_wave, 0, 1, 1, 0)
			create l_sound.make(l_wave)
			Result:= l_sound
		end

end
