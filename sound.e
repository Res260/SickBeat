note
	description: "Class that holds information."
	author: "Émilio G!"
	date: "160223"
	revision: "$Revision$"

class
	SOUND

inherit
	AUDIO_SOUND

create
	make

feature {NONE}

	make (a_sound_data : ARRAYED_LIST[INTEGER_16])
		local
			i: INTEGER_32
		do
			io.put_string ("OK")
			channel_count:= 1
			frequency:= 44100
			bits_per_sample:= 16
			is_signed:= True
			byte_per_buffer_sample:= channel_count * (bits_per_sample // 8)
			sound_length:= a_sound_data.count
			is_open := True
			create sound_data.make (byte_per_buffer_sample * sound_length)
			from
				i := 1
			until
				i > sound_length
			loop
				--io.put_string ("%N")
				--io.put_integer_16 (a_sound_data.at (i))
				sound_data.put_integer_16 (a_sound_data.at (i), (i - 1) * 2)
				i := i + 1
			end
		end

feature

	buffer_index: INTEGER_32 --usefull in fill_buffer

	sound_data: MANAGED_POINTER

	sound_length: INTEGER_32 --length in samples

	channel_count:INTEGER_32

	frequency: INTEGER_32

	bits_per_sample: INTEGER_32

	is_signed: BOOLEAN

	byte_per_buffer_sample: INTEGER_32

	is_seekable: BOOLEAN = False

	fill_buffer(a_buffer: POINTER; a_max_length: INTEGER_32)
		local
			l_buffer: ARRAYED_LIST[INTEGER_16]
			l_max: INTEGER_32
			l_count: INTEGER_32
		do
			if(buffer_index + a_max_length > a_max_length) then
				a_buffer.memory_copy (sound_data.item.plus (buffer_index), sound_length * byte_per_buffer_sample)
				buffer_index := 0
			else
				a_buffer.memory_copy (sound_data.item.plus (buffer_index), a_max_length)
				buffer_index := (buffer_index + a_max_length)
			end
		end

	restart
		do

		end

	is_openable: BOOLEAN = False

	open	--nothing. This is actually useless but necessary.
		do

		end

end
