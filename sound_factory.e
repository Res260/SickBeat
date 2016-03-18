note
	description: "Class that creates (generates) sounds for the game."
	author: "Émilio G!"
	date: "16-2-22"
	revision: "16w07a"

class
	SOUND_FACTORY

inherit
	DOUBLE_MATH
	MATH_CONST

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
		--Method that creates a sound for a menu button click.
		local
			l_wave:LIST[INTEGER_16]
			l_sound: SOUND
		do
			l_wave:= create_sine_wave(84, 420)
			repeat_wave(l_wave, 222)
			create l_sound.make(l_wave)
			Result:= l_sound
		end

	create_square_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):LIST[INTEGER_16]
		--Method that creates a single square wave and returns it as a list of INTEGER_16
		-- amplitude is in (relative) dB, frequency is in Hz
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
		--Method that creates a sine square wave and returns it as a list of INTEGER_16
		-- amplitude is in (relative) dB, frequency is in Hz

		local
			l_length: INTEGER_32
			l_highest_number: INTEGER_16
			l_wave: ARRAYED_LIST[INTEGER_16]
			i: INTEGER_32
		do
			l_length := (sample_rate // a_frequency) * number_of_channels
			l_highest_number := get_max_number_from_amplitude(a_amplitude)
			create l_wave.make (l_length)
			from
				i:= 0
			until
				i >= (l_length)
			loop
				l_wave.extend ((sine((i/l_length) * 2 * pi) * l_highest_number).rounded.to_integer_16)
				i := i + 1
			end
			Result := l_wave
		end

	create_triangle_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):LIST[INTEGER_16]
		--Method that creates a triangle square wave and returns it as a list of INTEGER_16
		-- amplitude is in (relative) dB, frequency is in Hz

		local
			l_length: INTEGER_32
			l_half_length: INTEGER_32
			l_highest_number: INTEGER_16
			l_max_range: INTEGER_32
			l_wave: ARRAYED_LIST[INTEGER_16]
			l_second_half_begin_index: INTEGER_32
			i: INTEGER_32
		do
			l_length := (sample_rate // a_frequency) * number_of_channels
			l_half_length := l_length // 2
			l_highest_number := get_max_number_from_amplitude(a_amplitude)
			print(l_highest_number)
			l_max_range := l_highest_number * 2
			create l_wave.make (l_length)
			from
				i:= 0
			until
				i >= l_half_length
			loop
				l_wave.extend (-l_highest_number + ((i / l_half_length) * l_max_range).rounded.to_integer_16)
				i := i + 1
			end

			from
				i := i
			until
				i >= l_length
			loop
--				print(l_wave.count)
--				io.put_new_line
--				print(l_length)
--				io.put_new_line
				l_wave.extend (l_highest_number - (((i - l_half_length) / l_half_length) * l_max_range).rounded.to_integer_16) --not working
				i := i + 1
			end

			Result := l_wave
		end

	get_max_number_from_amplitude(a_amplitude: REAL_32): INTEGER_16
		--calculates the highest possible number for a given amplitude.
		require
			a_amplitude <= max_amplitude
			a_amplitude >= 0
		do
			Result := (10^(a_amplitude / 20)).rounded.to_integer_16
		end

	get_wave_length_from_frequency(a_frequency: INTEGER_32): INTEGER_32
		--calculates the wave's length (in samples) for a given frequency.
		require
			a_frequency <= max_frequency
			a_frequency >= min_frequency
		do

			Result := (sample_rate // a_frequency) * number_of_channels
		end

	repeat_wave(a_sound: LIST[INTEGER_16]; a_repetition: INTEGER_32)
		--Appends a copy of a_sound to a_sound (a_repetition - 1) time(s).
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
