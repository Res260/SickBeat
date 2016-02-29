note
	description: "Summary description for {SOUND_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND_FACTORY

inherit
	gobo_math

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

	create_square_wave(a_amplitude: REAL_32; a_frequency: INTEGER_32):ARRAYED_LIST[INTEGER_16]
		local
			l_wave: ARRAYED_LIST[INTEGER_16]
			l_length: INTEGER_32
		do
			Result:= l_wave
		end

end
