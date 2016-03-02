note
	description: "Summary description for {SOUND_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND_FACTORY

create
	make

feature{NONE}

	make
		do
			sample_rate:= 44100
			number_of_channels:= 1
			bits_per_sample:= 16
		end

feature -- Access.

	sample_rate:INTEGER_32

	number_of_channels:INTEGER_32

	bits_per_sample:INTEGER_32

	max_amplitude
		once

		end

	create_sound_menu_click:SOUND
		local
			l_wave:ARRAYED_LIST[INTEGER_16]
			l_sound: SOUND
		do
			l_wave:= create_square_wave(20, 400)
			repeat_wave(l_wave, 22)
			create l_sound.make(l_wave)
			Result:= l_sound
		end

	create_square_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):ARRAYED_LIST[INTEGER_16]
		-- amplitude is in dB
		local
			l_wave: ARRAYED_LIST[INTEGER_16]
			l_highest_number: INTEGER_16
			l_length: INTEGER_32
			i: INTEGER_32
		do
			l_length:= sample_rate // a_frequency
			create l_wave.make (l_length)
			l_highest_number:= 32767
			from
				i:= 0
			until
				i >= l_length // 2
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

	repeat_wave(a_sound: ARRAYED_LIST[INTEGER_16]; a_repetition: INTEGER_32)
			--1 = no repetition
			--Side effect on a_sound
		local
			i: INTEGER_32
			l_list:ARRAYED_LIST[INTEGER_16]
		do
			l_list := a_sound.twin
			from
				i:= 1
			until
				i > a_repetition
			loop
				a_sound.append (l_list)
				i := i + 1
			end
		end

end
