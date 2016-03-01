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
			end

			from
				i := i
			until
				i >= l_length
			loop
				l_wave.extend (-l_highest_number)
			end
			Result:= l_wave
		end

end
