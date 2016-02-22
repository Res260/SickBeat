note
	description: "Summary description for {IMAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE


feature

	bleh
		local
			has_error:BOOLEAN
		do
			if not has_error then
				allo
			else
				io.error.put_string ("Criss de cave")
			end

		rescue

		end
end
