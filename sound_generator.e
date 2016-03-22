note
	description: "Class that generates sound using lists of INTEGER_16"
	author: "�milio Gonzalez"
	date: "2016-03-22"
	revision: "1"

class
	SOUND_GENERATOR

inherit
	DOUBLE_MATH
	MATH_CONST

create
	make

feature --Initialization
	make
		do
			max_frequency := sample_rate // 2
			max_integer_16 := max_integer_16.Max_value
			min_integer_16 := max_integer_16.Min_value
			max_integer_32 := max_integer_32.Max_value
			min_integer_32 := max_integer_32.Min_value
		end

feature --Access

	sample_rate:INTEGER_32 = 44100

	number_of_channels:INTEGER_32 = 1

	bits_per_sample:INTEGER_32 = 16

	max_amplitude:REAL_64
		once
			Result := 20 * log10(2^(bits_per_sample - 1) - 1)
		end

	max_frequency: INTEGER_32

	min_frequency: INTEGER_32 = 20

	max_integer_16: INTEGER_16
	min_integer_16: INTEGER_16

	max_integer_32: INTEGER_32
	min_integer_32: INTEGER_32

	FADE_IN: INTEGER_8 =  0
	FADE_OUT: INTEGER_8 = 1

	create_square_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):LIST[INTEGER_16]
		--Method that creates a single square wave and returns it as a list of INTEGER_16
		-- amplitude is in (relative) dB, frequency is in Hz
		require
			Amplitude_Too_High: a_amplitude <= max_amplitude
			Amplitude_Too_Low: a_amplitude >= 0
			Frequency_Too_High: a_frequency <= max_frequency
			Frequency_Too_Low: a_frequency >= min_frequency
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
		require
			Amplitude_Too_High: a_amplitude <= max_amplitude
			Amplitude_Too_Low: a_amplitude >= 0
			Frequency_Too_High: a_frequency <= max_frequency
			Frequency_Too_Low: a_frequency >= min_frequency
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
		require
			Amplitude_Too_High: a_amplitude <= max_amplitude
			Amplitude_Too_Low: a_amplitude >= 0
			Frequency_Too_High: a_frequency <= max_frequency
			Frequency_Too_Low: a_frequency >= min_frequency
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
				l_wave.extend (l_highest_number - (((i - l_half_length) / l_half_length) * l_max_range).rounded.to_integer_16) --not working
				i := i + 1
			end

			Result := l_wave
		end

	amplify(a_sound: LIST[INTEGER_16]; a_amp_value: REAL_64)
		--amplifies a_sound by multiplicating a_sound[i] with a_amp_value
		--side effect on a_sound
		require
			a_amp_value >= 0
		local
			l_sound_length: INTEGER_32
			i: INTEGER_32
		do
			from
				i := 1
			until
				i > l_sound_length
			loop
				a_sound[i] := amplify_sample(a_sound[i], a_amp_value)
			end
		end

	amplify_sample(a_sample: INTEGER_16; a_amp_value: REAL_64): INTEGER_16
		local
			l_amp_result: REAL_64
		do
			l_amp_result := a_sample * a_amp_value
			if(l_amp_result > max_integer_16) then
				l_amp_result := max_integer_16
			elseif(l_amp_result < min_integer_16) then
				l_amp_result := min_integer_16
			end
			Result := l_amp_result.rounded.to_integer_16
		end

	mix(a_sound1: LIST[INTEGER_16]; a_sound2: LIST[INTEGER_16])
		-- Mixes two waves by adding up a_sound2[i] to a_sound2[i].
		-- if there is overflow, caps the amplitude.
		-- side effect on a_sound1
		local
			i: INTEGER_32
			l_length_difference: INTEGER_32
			l_mix_result: INTEGER_32
		do
			l_length_difference := a_sound2.count - a_sound1.count
			if(l_length_difference > 0) then
				add_silence_from_samples(a_sound1, l_length_difference)
			end
			from
				i := 1
			until
				i >= a_sound1.count
			loop
				a_sound1[i] := add_up(a_sound1[i], a_sound2[i])
				i := i + 1
			end
		end

	add_up(a_sample1: INTEGER_16; a_sample2: INTEGER_16): INTEGER_16
		local
			l_mix_result: INTEGER_32
		do
			l_mix_result := a_sample1 + a_sample2
			if(l_mix_result > max_integer_16) then
				l_mix_result := max_integer_16
			elseif(l_mix_result < min_integer_16) then
				l_mix_result := min_integer_16
			end
			Result := l_mix_result.to_integer_16
		end

	fade(a_sound: LIST[INTEGER_16]; a_begin_length_percentage:REAL_64; a_end_length_percentage: REAL_64;
				  a_begin_volume_percentage: REAL_64; a_end_volume_percentage:REAL_64;)
		-- fades (a_begin_length_percentage % to a_length_end_percentage) from (a_begin_volume_percentage % to a_end_volume_percentage %)
		-- of the sound. Fade out or fade in.
		-- side effect on a_sound.
		require
			Begin_Length_Good: a_begin_length_percentage >= 0 and a_begin_length_percentage <= 1
			End_length_Good:   a_end_length_percentage >= a_begin_length_percentage and a_end_length_percentage <= 1
			Begin_Volume_Good: a_begin_volume_percentage >= 0 and a_begin_volume_percentage <= 1
			End_Volume_Good: a_end_volume_percentage >= 0 and a_end_volume_percentage <= 1
		local
			l_sample_index_begin: INTEGER_32
			l_sample_index_end:   INTEGER_32
			l_number_of_fade_samples: INTEGER_32
			l_logarithmic_percentage_list: LIST[REAL_64]
			i: INTEGER_32
		do
			l_sample_index_begin := get_sample_index_from_percentage(a_sound.count, a_begin_length_percentage)
			l_sample_index_end := get_sample_index_from_percentage(a_sound.count, a_end_length_percentage)
			l_number_of_fade_samples := l_sample_index_end - l_sample_index_begin + 1
			l_logarithmic_percentage_list := get_logarithmic_percentage_list_from_linear_percentage_range(
										a_begin_volume_percentage, a_end_volume_percentage, l_number_of_fade_samples)
			from
				i := l_sample_index_begin
			until
				i > l_sample_index_end
			loop
				a_sound[i] := amplify_sample(a_sound[i], l_logarithmic_percentage_list[i - l_sample_index_begin + 1])
				i := i + 1
			end
		end

	get_logarithmic_percentage_list_from_linear_percentage_range(a_begin_volume_percentage: REAL_64;
							 a_end_volume_percentage: REAL_64; a_number_of_samples: INTEGER_32): LIST[REAL_64]
		local
			l_logarithmic_percentage_list: LIST[REAL_64]
			l_percentage_iteration: REAL_64
			i: INTEGER_32
		do
			l_percentage_iteration := (a_end_volume_percentage - a_begin_volume_percentage) / a_number_of_samples
			print(l_percentage_iteration)
			io.put_new_line
			create {ARRAYED_LIST[REAL_64]} l_logarithmic_percentage_list.make (a_number_of_samples)
			from
				i := 1
			until
				i > a_number_of_samples
			loop
				l_logarithmic_percentage_list.extend (
					get_logarithmic_percentage_from_linear_percentage(a_begin_volume_percentage + (i * l_percentage_iteration)))
				i := i + 1
			end
--			across l_logarithmic_percentage_list as la_element loop
--				io.put_new_line
--				io.put_string(la_element.item.out)
--			end
			Result := l_logarithmic_percentage_list
		end

	get_logarithmic_percentage_from_linear_percentage(a_linear_percentage: REAL_64):REAL_64
		require
			Linear_Percentage_Valid: a_linear_percentage <= 1 and a_linear_percentage >= 0
		do
			Result := 0.001*exp(6.908*a_linear_percentage)
			if(Result > 1) then
				Result := 1
			end
		end

	repeat_wave_from_repetitions(a_sound: LIST[INTEGER_16]; a_repetition: INTEGER_32)
		--Appends a copy of a_sound to a_sound (a_repetition - 1) duration(s).
		--1 = no repetition
		--Side effect on a_sound
		require
			a_repetition > 0
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
		ensure
			Repetition_Valid: a_sound.count = old a_sound.count * a_repetition
		end

	repeat_wave_from_duration(a_sound: LIST[INTEGER_16]; a_seconds: REAL_64)
		--Repeats a_sound until it lasts a_seconds seconds.
		--1 = no repetition
		--Side effect on a_sound
		require
			duration_Valid: a_seconds > get_duration_from_number_of_samples(a_sound.count)
		local
			i: INTEGER_32
			l_list:LIST[INTEGER_16]
			l_initial_sound_length: INTEGER_32
			l_number_of_silence_samples: INTEGER_32
		do
			l_initial_sound_length := a_sound.count
			l_number_of_silence_samples := get_number_of_samples_from_duration(a_seconds)
			from
				i:= l_initial_sound_length
			until
				i >= l_number_of_silence_samples
			loop
				a_sound.extend(a_sound[(i \\ l_initial_sound_length) + 1])
				i := i + 1
			end
		ensure
			Repetition_Valid: a_sound.count =get_number_of_samples_from_duration(a_seconds)
		end

	add_noise(a_sound:LIST[INTEGER_16]; a_amplitude:INTEGER_32)
		--adds random numbers to a_sound
		--side effect on a_sound
		require
			a_amplitude >= 0
		local
			l_max_number: INTEGER_16
			l_random_number: RANDOM
			i: INTEGER_32
		do
			l_max_number := get_max_number_from_amplitude(a_amplitude)
			create l_random_number.make
			from
				i := 1
			until
				i > a_sound.count
			loop
				a_sound[i] := add_up(a_sound[i], ((l_random_number.double_item - 0.5)* l_max_number).rounded.to_integer_16)
				l_random_number.forth
				i := i + 1
			end

		end

	add_silence_from_seconds(a_sound: LIST[INTEGER_16]; a_seconds: REAL_64)
		-- Adds a silence (zeros) of a_seconds seconds to a_sound.
		-- Of course, it has a side effect on a_sound.
		require
			Seconds_Valid: a_seconds > 0
		local
			i: INTEGER_32
			l_number_of_silence_samples: INTEGER_32
		do
			l_number_of_silence_samples := get_number_of_samples_from_duration(a_seconds)
			add_silence_from_samples(a_sound, l_number_of_silence_samples)
		ensure
			Sound_Count_Valid: a_sound.count = old a_sound.count + get_number_of_samples_from_duration(a_seconds)
			At_Least_One_Zero: across a_sound as la_sound some la_sound.item = 0 end
		end

	add_silence_from_samples(a_sound: LIST[INTEGER_16]; a_samples: INTEGER_32)
		-- Adds a silence (zeros) of a_samples samples to a_sound.
		-- Of course, it has a side effect on a_sound.
		require
			a_samples > 0
		local
			i: INTEGER_32
		do
			from
				i:= 1
			until
				i > a_samples
			loop
				a_sound.extend (0)
				i := i + 1
			end
		ensure
			Sound_Count_Valid: a_sound.count = old a_sound.count + get_number_of_samples_from_duration(a_samples)
			At_Least_One_Zero: across a_sound as la_sound some la_sound.item = 0 end
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

	get_number_of_samples_from_duration(a_seconds:REAL_64): INTEGER_32
		-- calculates the number of samples during a_seconds seconds.s
		require
			a_seconds >= 0
		do
			Result := (a_seconds * sample_rate).rounded
		ensure
			Result >= 0
		end

	get_duration_from_number_of_samples(a_samples: INTEGER_32):REAL_64
		-- calculates the duration a_samples samples takes to play.
		require
			Samples_Valid: a_samples >= 0
		do
			Result := a_samples / sample_rate
		ensure
			Result >= 0
		end

	get_sample_index_from_percentage(a_number_of_samples: INTEGER_32; a_percentage: REAL_64):INTEGER_32
		-- calculates the index of the sample at a_percentages of a_number_of_samples.
		require
			a_percentage >= 0
		do
			Result := (a_percentage * (a_number_of_samples - 1)).rounded + 1
		end

feature --debug
	print_wave(a_wave: LIST[INTEGER_16])
		--prints the wave in the console
		local
			i: INTEGER_32
			j: INTEGER_32
			format_integer:FORMAT_INTEGER
		do
			create format_integer.make (6)
			print("%N-------------------------------------------%N")
			print(a_wave.count)
			print(" samples vvvvvvvvvvvvvvvvvvvvv")
			print("%N-------------------------------------------%N")
			from
				i:= 1
			until
				i > a_wave.count
			loop
				from
					j := 1
				until
					j >= 14
				loop
					if(i <= a_wave.count) then
						format_integer.left_justify
						print ("[" + format_integer.formatted (a_wave[i]) + "] ")
						i := i + 1
					end
					j := j + 1
				end
				io.put_new_line
			end
			print("%N-------------------------------------------%N")
			print(a_wave.count)
			print(" samples ^^^^^^^^^^^^^^^^^^^^")
			print("%N-------------------------------------------%N")
		end

end
