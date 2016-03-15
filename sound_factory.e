note
	description: "Class that creates (generates) sounds for the game."
	author: "Émilio G!"
	date: "16-2-22"
	revision: "16w07a"

class
	SOUND_FACTORY

inherit
	DOUBLE_MATH

create
	make

feature{NONE}

	make
		do
		end

feature -- Access.

	sample_rate:INTEGER_32 = 44100

	number_of_channels:INTEGER_32 = 1

	bits_per_sample:INTEGER_32 = 16

	max_amplitude:REAL_64
		once
			Result := 20 * log10(2^(bits_per_sample - 1) - 1)
		end

	max_frequency: INTEGER_16 = 20000

	min_frequency: INTEGER_16 = 20

	create_sound_menu_click:SOUND
		local
			l_wave:LIST[INTEGER_16]
			l_sound: SOUND
		do
			l_wave:= create_square_wave(50, 400)
			repeat_wave(l_wave, 22)
			create l_sound.make(l_wave)
			Result:= l_sound
		end

	create_square_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):LIST[INTEGER_16]
		-- amplitude is in dB

		local
			l_wave: ARRAYED_LIST[INTEGER_16]
			l_highest_number: INTEGER_16
			l_length: INTEGER_32
			i: INTEGER_32
		do
			l_length:= get_wave_length_from_frequency(a_frequency)
			create l_wave.make (l_length)
			l_highest_number:= get_max_number_from_amplitude(a_amplitude)
			io.put_integer_16(l_highest_number)
			io.put_new_line
			print(max_amplitude)
			from
				i:= 0
			until
				i >= (l_length) // 2
			loop
				l_wave.extend (l_highest_number)
				i := i + 1
			end

			from
				i := i
			until
				i >= l_length
			loop
				l_wave.extend (-l_highest_number)
				i := i + 1
			end

			Result:= l_wave
		end

	create_sine_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):LIST[INTEGER_16]
		--amplitude is in dB

		local
			l_length: INTEGER_32
			l_wave: ARRAYED_LIST[INTEGER_16]
		do
			l_length := (sample_rate // a_frequency) * number_of_channels
			create l_wave.make (l_length)
--			from
--				i:= 0
--			until
--				i >= (l_length) // 2
--			loop
--				l_wave.extend (l_highest_number)
--				i := i + 1
--			end
			Result := l_wave
		end

	get_max_number_from_amplitude(a_amplitude: REAL_32): INTEGER_16
		--calculates highest number of and integer_16 for a given amplitude.
		require
			a_amplitude <= max_amplitude
			a_amplitude >= 0
		do
			Result := (10^(a_amplitude / 20)).rounded.to_integer_16
		end

	get_wave_length_from_frequency(a_frequency: INTEGER_32): INTEGER_32
		--calculates the wave's length for a given frequency.
		require
			a_frequency <= max_frequency
			a_frequency >= min_frequency
		do

			Result := (sample_rate // a_frequency) * number_of_channels
		end

	repeat_wave(a_sound: LIST[INTEGER_16]; a_repetition: INTEGER_32)
			--1 = no repetition
			--Side effect on a_sound
		local
			i: INTEGER_32
			l_list:LIST[INTEGER_16]
		do
			l_list := a_sound.twin
			from
				i:= 1
			until
				i >= a_repetition
			loop
				a_sound.append (l_list)
				i := i + 1
			end
		end

end
