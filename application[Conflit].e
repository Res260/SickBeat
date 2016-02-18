note
	description : "SickBeat application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature -- Initialization

	game: GAME_ENGINE
			-- `game'
		attribute check False then end end --| Remove line when `game' is initialized in creation procedure.

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

	allo
		do
			if attached liste as la_liste then
				print(la_liste.item.out)
			end

		end

	liste:detachable LIST[INTEGER]

end
