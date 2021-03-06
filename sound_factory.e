note
	description: "Class that creates sounds for the game."
	author: "�milio G!"
	date: "16-5-20"
	revision: "16w16a"
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

	min_frequency:INTEGER_32 = 120
		--Minimum frequency for sounds_list

	max_frequency:INTEGER_32 = 9000
		--Maximum frequency for sounds_list

feature --Access

	sounds_list:CHAIN[SOUND]
		--List of sounds to play.

	create_sound_hit_player: SOUND
			--Method that creates a sound for when a collision happen for a {PLAYER}.
		local
			l_wave: CHAIN[INTEGER_16]
		once("PROCESS")
		l_wave := sound_generator.create_sine_wave (60, 4000)
		sound_generator.repeat_wave_from_duration (l_wave, 0.05)
			create Result.make (l_wave)
		end

	create_sound_hit_enemy: SOUND
			--Method that creates a sound for when a collision happen for an {ENEMY}.
		local
			l_wave: CHAIN[INTEGER_16]
		once("PROCESS")
		l_wave := sound_generator.create_sine_wave (60, 500)
		sound_generator.repeat_wave_from_duration (l_wave, 0.03)
			create Result.make (l_wave)
		end

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
		once("PROCESS")
			l_wave_bass := sound_generator.create_sine_wave (50, 120)
			sound_generator.repeat_wave_from_duration (l_wave_bass, 0.25)
			sound_generator.add_silence_from_seconds (l_wave_bass, 0.25)
			create Result.make (l_wave_bass)
		end

	populate_sounds_list
			--populates sounds_list by generating many sounds.
			--side effect on sounds_list.
		local
			i, j:INTEGER_32
			l_wave:CHAIN[INTEGER_16]
			l_temp_wave: CHAIN[INTEGER_16]
			l_amplitude, l_amplitude_decay: REAL_64
			l_sound_duration, l_sound_duration_decay: REAL_64
		once("PROCESS")
			l_amplitude := 55
			l_amplitude_decay := 5
			l_sound_duration := 3.5
			l_sound_duration_decay := 0.3
			from
				i := min_frequency
			until
				i > max_frequency
			loop
				l_wave := sound_generator.create_sine_wave(l_amplitude, i)
				sound_generator.repeat_wave_from_duration (l_wave, l_sound_duration)
				from
					j := 1
				until
					j > 5
				loop
					l_temp_wave := sound_generator.create_sine_wave (l_amplitude - (l_amplitude_decay * j), (i - (i / 6) * j).rounded)
					sound_generator.add_silence_from_samples (l_temp_wave, l_temp_wave.count)
					sound_generator.repeat_wave_from_duration (l_temp_wave, l_sound_duration - (l_sound_duration_decay * j))
					sound_generator.mix (l_wave, l_temp_wave, 0)
					j := j + 1
				end
				sound_generator.fade (l_wave, 0, 0.01, 0, 1)
				sound_generator.fade (l_wave, 0.01, 1, 1, 0)
				sounds_list.extend(create{SOUND}.make (l_wave))
				i := (i * 2.5).rounded
			end
		ensure
			Good_Number_Of_Sounds: sounds_list.count = 5
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
