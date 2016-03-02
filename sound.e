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
			buffer_index:= 0
			byte_per_buffer_sample:= channel_count * (bits_per_sample // 8)
			sound_length:= a_sound_data.count
			is_open := True
			create sound_data.make (byte_per_buffer_sample * sound_length)
			from
				i := 1
			until
				i > sound_length - 1
			loop
				sound_data.put_integer_16 (a_sound_data.at (i), (i - 1) * byte_per_buffer_sample)
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
			l_buffer_size: INTEGER_32
			l_index_max: INTEGER_32
			l_sound_length_byte: INTEGER_32
		do
			l_index_max:= buffer_index + a_max_length
			l_sound_length_byte:= sound_length * byte_per_buffer_sample
			if(l_index_max >= l_sound_length_byte) then
				l_buffer_size:= l_sound_length_byte - buffer_index
			else
				l_buffer_size:= a_max_length
			end
			if(l_buffer_size <= 0) then
				restart
			else
				a_buffer.memory_copy (sound_data.item.plus (buffer_index), l_buffer_size)
				buffer_index := (buffer_index + l_buffer_size)
			end
			last_buffer_size:= l_buffer_size
		end

	restart
		do
			buffer_index := 0
		end

	is_openable: BOOLEAN = False

	open	--nothing. This is actually useless but necessary.
		do

		end

end
