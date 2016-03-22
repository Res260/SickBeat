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

feature{NONE} --Initialization

	make
		do

		end

feature -- Access.

	create_sound_menu_click:SOUND
		--Method that creates a sound for a menu button click.
		local
			l_wave: LIST[INTEGER_16]
			l_wave2: LIST[INTEGER_16]
			l_wave3: LIST[INTEGER_16]
			l_sound: SOUND
		do
			l_wave:= sound_generator.create_sine_wave(75, 415)
--			l_wave:= sound_generator.create_sine_wave(0, 30)

			l_wave2:= sound_generator.create_sine_wave(90, 300)
			l_wave3:= sound_generator.create_sine_wave(90, 200)
			sound_generator.repeat_wave_from_duration(l_wave, 1)
			sound_generator.repeat_wave_from_duration(l_wave2, 0.1)
			sound_generator.repeat_wave_from_duration(l_wave3, 0.1)
--			sound_generator.fade(l_wave, 0.0, 1.0, 1.0, 0.0)
			sound_generator.fade(l_wave2, 0.0, 1.0, 0.8, 0.0)
			sound_generator.fade(l_wave3, 0.0, 1.0, 0.6, 0.0)
--			l_wave.append (l_wave2)
--			l_wave.append (l_wave3)
--			sound_generator.add_noise(l_wave, 80)
			create l_sound.make(l_wave)
			Result:= l_sound
		end

feature{NONE} --Implementation
end
