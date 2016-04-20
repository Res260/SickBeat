note
	description: "[
		Eiffel tests for SOUND_GENERATOR that can be executed by testing tool.
	]"
	author: "Émilio Gonzalez"
	date: "16-04-19"
	revision: "16w11b"
	testing: "type/manual"

class
	SOUND_GENERATOR_MANUAL

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end
	SOUND_GENERATOR
		undefine
			default_create
		end

feature -- Test routines

	on_prepare
		do
			make
		end

	create_square_wave_normal
			-- Tests a normal case for create_square_wave
		local
			l_wave:CHAIN[INTEGER_16]
		do
			l_wave := create_square_wave(50, 5000)
			assert ("create_square_wave_normal bad length", l_wave.count = (sample_rate // 5000) * number_of_channels)
		end

	create_square_wave_limit
			-- Tests a limit case for create_square_wave
		local
			l_wave:CHAIN[INTEGER_16]
		do
			l_wave := create_square_wave(max_amplitude, min_frequency)
			assert ("create_square_wave_normal bad length", l_wave.count = (sample_rate // min_frequency) * number_of_channels)
		end

	create_triangle_wave_normal
			-- Tests a normal case for create_triangle_wave
		local
			l_wave:CHAIN[INTEGER_16]
		do
			l_wave := create_triangle_wave(50, 5000)
			assert ("create_triangle_wave_normal bad length", l_wave.count = (sample_rate // 5000) * number_of_channels)
		end

	create_triangle_wave_limit
			-- Tests a limit case for create_triangle_wave
		local
			l_wave:CHAIN[INTEGER_16]
		do
			l_wave := create_triangle_wave(max_amplitude, min_frequency)
			assert ("create_triangle_wave_normal bad length", l_wave.count = (sample_rate // min_frequency) * number_of_channels)
		end

	create_sine_wave_normal
			-- Tests a normal case for create_sine_wave
		local
			l_wave:CHAIN[INTEGER_16]
		do
			l_wave := create_sine_wave(50, 5000)
			assert ("create_sine_wave_normal bad length", l_wave.count = (sample_rate // 5000) * number_of_channels)
		end

	create_sine_wave_limit
			-- Tests a limit case for create_sine_wave
		local
			l_wave:CHAIN[INTEGER_16]
		do
			l_wave := create_sine_wave(max_amplitude, min_frequency)
			assert ("create_sine_wave_normal bad length", l_wave.count = (sample_rate // min_frequency) * number_of_channels)
		end

	amplify_wave_normal
			-- Tests a normal case for amplify_wave
		local
			l_wave:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
		do
			l_wave := create_sine_wave(10, 300)
			l_value1 := l_wave[4]
			amplify_wave(l_wave, 1.5)
			assert("Invalid amplify_wave", l_wave[4].abs <= ((1.5 * l_value1)).rounded.abs + 1 and l_wave[4].abs >= ((1.5 * l_value1)).rounded.abs - 1)
		end

	amplify_wave_limit
			-- Tests a limit case for amplify_wave
		local
			l_wave:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
		do
			l_wave := create_sine_wave(0, 3000)
			l_value1 := l_wave[4]
			amplify_wave(l_wave, 5)
			assert("Invalid amplify_wave", l_wave[4] = 0 or l_wave[4] = 1 or l_wave[4] = -1)
		end

	mix_normal
			-- Tests a normal case for mix
		local
			l_wave:CHAIN[INTEGER_16]
			l_wave2:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
		do
			l_wave := create_sine_wave(60, 3000)
			l_wave2 := create_square_wave(65, 3000)
			l_value1 := l_wave[2] + l_wave2[2]
			mix(l_wave, l_wave2, 0)
			assert("Mix normal not working", l_wave[2] = l_value1)
		end

	mix_limit
			-- Tests a limit case for mix
		local
			l_wave:CHAIN[INTEGER_16]
			l_wave2:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
		do
			l_wave := create_sine_wave(60, 300)
			l_wave2 := create_square_wave(65, 3000)
			l_value1 := l_wave[l_wave.count - 2]
			mix(l_wave, l_wave2, 0)
			assert("Mix limit not working", l_wave[l_wave.count - 2] = l_value1)
		end

	fade_normal
			-- Tests a normal case for fade
		local
			l_wave:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
			l_value2:INTEGER_16
		do
			l_wave := create_sine_wave(60, 3000)
			l_value1 := l_wave[3]
			l_value2 := l_wave[l_wave.count]
			fade(l_wave, 0, 1, 0, 1)
			assert("Fade normal not working", l_wave[3].abs < l_value1.abs)
			assert("Fade normal not working2", l_wave[l_wave.count] = l_value2)
		end

	fade_limit
			-- Tests a limit case for fade
		local
			l_wave:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
			l_value2:INTEGER_16
		do
			l_wave := create_sine_wave(60, 3000)
			l_value1 := l_wave[1]
			l_value2 := l_wave[10]
			fade(l_wave, 0.5, 1, 1, 0.5)
			assert("Fade limit not working", l_wave[1] = l_value1)
			assert("Fade limit not working2", l_wave[10].abs < l_value2.abs)
		end

	repeat_wave_from_repetitions_wrong
			--Tests a normal case for repeat_wave_from_repetitions
		local
			l_wave:CHAIN[INTEGER_16]
			l_has_retry:BOOLEAN
			l_sound:SOUND_GENERATOR
		do
			if not l_has_retry then
				create l_sound.make
				l_wave := l_sound.create_triangle_wave(60, 3000)
				l_sound.repeat_wave_from_repetitions(l_wave,-1)
				assert("repeat_wave_from_repetitions_normal succeeds when supposed to fail", False)
			else
				assert("repeat_wave_from_repetitions_normal normal", True)
			end
		rescue
			l_has_retry := True
			retry
		end

	repeat_wave_from_repetitions_normal
			--Tests a normal case for repeat_wave_from_repetitions
		local
			l_wave:CHAIN[INTEGER_16]
			l_initial_count:INTEGER_32
		do
			l_wave := create_triangle_wave(50, 50)
			l_initial_count := l_wave.count
			repeat_wave_from_repetitions(l_wave, 2)
			assert("repeat_wave_from_repetitions_normal not normal", l_initial_count * 2 = l_wave.count)
		end

	repeat_wave_from_repetitions_limit
			--Tests a limit case for repeat_wave_from_repetitions
		local
			l_wave:CHAIN[INTEGER_16]
			l_initial_count:INTEGER_32
		do
			l_wave := create_triangle_wave(24, 921)
			l_initial_count := l_wave.count
			repeat_wave_from_repetitions(l_wave, 1)
			assert("repeat_wave_from_repetitions limit not normal", l_initial_count * 1 = l_wave.count)
		end

	repeat_wave_from_duration_normal
			--Tests a normal case for repeat_wave_from_duration
		local
			l_wave:CHAIN[INTEGER_16]
			l_initial_duration:REAL_64
		do
			l_wave := create_square_wave(50, 50)
			l_initial_duration := 0.02
			repeat_wave_from_duration(l_wave, 2)
			assert("repeat_wave_from_duration not normal", l_wave.count = l_initial_duration * 882 * 2 or l_wave.count = 88200)
		end

	repeat_wave_from_duration_limit
			--Tests a limit case for repeat_wave_from_duration
		local
			l_wave:CHAIN[INTEGER_16]
			l_initial_duration:REAL_64
		do
			l_wave := create_square_wave(50, 50)
			l_initial_duration := 0.02
			repeat_wave_from_duration(l_wave, 0.01)
			assert("repeat_wave_from_duration limit not normal", l_wave.count = 882)
		end

	add_noise_normal
			--Tests a normal case for add_noise
		local
			l_wave:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
		do
			l_wave := create_square_wave(20, 700)
			l_value1 := l_wave[5]
			add_noise(l_wave, 70)
			assert("add_noise not normal", l_value1 /= l_wave[5])
		end

	add_noise_limit
			--Tests a limit case for add_noise
		local
			l_wave:CHAIN[INTEGER_16]
			l_value1:INTEGER_16
		do
			l_wave := create_sine_wave(20, 700)
			l_value1 := l_wave[4]
			add_noise(l_wave, 0)
			assert("add_noise limit not normal", l_value1 = l_wave[4])
		end

	add_silence_from_seconds_normal
			--Tests a normal case for add_silence_from_seconds
		local
			l_wave:CHAIN[INTEGER_16]
			l_duration1:REAL_64
		do
			l_wave := create_sine_wave(20, 700)
			l_duration1 := l_wave.count / sample_rate
			add_silence_from_seconds(l_wave, 1)
			assert("add_silence_from_seconds not normal", l_duration1 + 1 = l_wave.count / sample_rate)
		end

	add_silence_from_seconds_limit
			--Tests a limit case for add_silence_from_seconds
		local
			l_wave:CHAIN[INTEGER_16]
			l_duration1:REAL_64
		do
			l_wave := create_sine_wave(20, 7020)
			l_duration1 := l_wave.count / sample_rate
			add_silence_from_seconds(l_wave, 0)
			assert("add_silence_from_seconds not normal", l_duration1 = l_wave.count / sample_rate)
		end

	add_silence_from_samples_normal
			--Tests a normal case for add_silence_from_samples
		local
			l_wave:CHAIN[INTEGER_16]
			l_count1:REAL_64
		do
			l_wave := create_sine_wave(22, 7022)
			l_count1 := l_wave.count
			add_silence_from_samples(l_wave, 500)
			assert("add_silence_from_samples not normal", l_count1 + 500 = l_wave.count)
		end

	add_silence_from_samples_limit
			--Tests a limit case for add_silence_from_samples
		local
			l_wave:CHAIN[INTEGER_16]
			l_count1:REAL_64
		do
			l_wave := create_sine_wave(22, 7022)
			l_count1 := l_wave.count
			add_silence_from_samples(l_wave, 0)
			assert("add_silence_from_samples limit not normal", l_count1 = l_wave.count)
		end

end
