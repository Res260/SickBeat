note
	description: "Class that creates sounds for the game."
	author: "Émilio G!"
	date: "16-3-29"
	revision: "16w08b"
	legal: "See notice at end of class."

class
	SOUND_FACTORY

inherit
	SOUND_GENERATOR_SHARED

create
	make

feature --Initialization

	make
		-- Initialization for `Current'. Nothing for now.
		do

		end

feature --Access

	create_sound_menu_click:SOUND
		--Method that creates a sound for a menu button click.
		local
			l_wave : CHAIN[INTEGER_16]
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
		
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
