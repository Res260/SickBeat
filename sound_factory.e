note
	description: "Class that creates sounds for the game."
	author: "Émilio G!"
	date: "16-4-25"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	SOUND_FACTORY

inherit
	SOUND_GENERATOR_SHARED

create
	make

feature {NONE} -- Initialization
	make
			--Initialization for `Current'
		do
			create{ARRAYED_LIST[SOUND]} sounds_list.make (max_frequency // min_frequency)
		end

feature {NONE}

	min_frequency:INTEGER_32 = 200
		--Minimum frequency for sounds_list

	max_frequency:INTEGER_32 = 300
		--Maximum frequency for sounds_list

feature --Access

	sounds_list:CHAIN[SOUND]
		--List of sounds to play.

	create_sound_menu_click:SOUND
			--Method that creates a sound for a menu button click.
		local
			l_wave : CHAIN[INTEGER_16]
			l_initial_frequency: INTEGER_32
		once("PROCESS")
			l_initial_frequency := 200
			l_wave:= sound_generator.create_sine_wave(70, l_initial_frequency)
			sound_generator.repeat_wave_from_duration(l_wave, 0.4)
			sound_generator.fade (l_wave, 0, 1, 1, 0)
			create Result.make(l_wave)
		end

	create_menu_music:SOUND
			--'Music' for the menu. lol not much to see here.
		local
			l_wave_bass: CHAIN[INTEGER_16]
			l_wave_bass2: CHAIN[INTEGER_16]
			l_wave_silence: CHAIN[INTEGER_16]
		once
			l_wave_silence := sound_generator.create_square_wave (0, 500)
--			sound_generator.add_silence_from_seconds (l_wave_silence, 0.8)

			l_wave_bass := sound_generator.create_sine_wave (0, 60)
--			sound_generator.repeat_wave_from_duration (l_wave_bass, 0.2)
--			sound_generator.fade (l_wave_bass, 0, 0.40, 0, 1)
--			sound_generator.fade (l_wave_bass, 0.6, 1, 1, 0)
--			sound_generator.add_silence_from_seconds (l_wave_bass, 0.3)
--			sound_generator.repeat_wave_from_repetitions (l_wave_bass, 3)
--			sound_generator.add_silence_from_seconds (l_wave_bass, 0.3)
--			sound_generator.repeat_wave_from_duration (l_wave_bass, 20)

			l_wave_bass2 := sound_generator.create_sine_wave (0, 100)
--			sound_generator.repeat_wave_from_duration (l_wave_bass2, 0.2)
--			sound_generator.fade (l_wave_bass2, 0, 0.40, 0, 1)
--			sound_generator.fade (l_wave_bass2, 0.6, 1, 1, 0)
--			sound_generator.add_silence_from_seconds (l_wave_bass2, 0.8)
--			sound_generator.repeat_wave_from_repetitions (l_wave_bass2, 3)
--			sound_generator.add_silence_from_seconds (l_wave_bass2, 0.3)
--			sound_generator.repeat_wave_from_duration (l_wave_bass2, 20)

			sound_generator.mix (l_wave_bass, l_wave_bass2, 0)
			create Result.make (l_wave_bass)
		end

	populate_sounds_list
			--populates sounds_list by generating many sounds.
			--side effect on sounds_list.
		local
			i:INTEGER_32
			l_wave:CHAIN[INTEGER_16]
		do
			from
				i := min_frequency
			until
				i > max_frequency
			loop
				l_wave := sound_generator.create_sine_wave(55, i)
				sound_generator.repeat_wave_from_duration (l_wave, 4)
				sound_generator.fade (l_wave, 0, 0.01, 0, 1)
				sound_generator.fade (l_wave, 0.01, 1, 1, 0)
				sounds_list.extend(create{SOUND}.make (l_wave))
				i := (i * 1.5).rounded
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
