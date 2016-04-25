note
	description: "[
		Eiffel tests that can be executed by testing tool.
		Tests the {BOUNDING_BOX} class.
	]"
	author: "Guillaume Jean"
	date: "21 April 2016"
	revision: "16w11a"
	testing: "type/manual"

class
	BOUNDING_BOX_TEST

inherit
	EQA_TEST_SET

feature -- Test routines

	bounding_box_collision_with_box_test
			-- Tests the bounding box collision with another box
		local
			l_box1, l_box2: BOUNDING_BOX
		do
			create l_box1.make_box(0, 0, 4, 4)
			create l_box2.make_box(2, 2, 6, 6)
			assert("Bounding box collision with box normal test failed.", l_box1.collides_with_box(l_box2))
			assert("Bounding box collision with other normal test failed.", l_box1.collides_with_other(l_box2))
			l_box2.update_to([(4).to_double, (4).to_double], [(8).to_double, (8).to_double])
			assert("Bounding box collision with box corner limit test failed.", l_box1.collides_with_box(l_box2))
			assert("Bounding box collision with other corner limit test failed.", l_box1.collides_with_other(l_box2))
			l_box2.update_to([(4).to_double, (2).to_double], [(8).to_double, (6).to_double])
			assert("Bounding box collision with box side limit test failed.", l_box1.collides_with_box(l_box2))
			assert("Bounding box collision with other side limit test failed.", l_box1.collides_with_other(l_box2))
		end

	bounding_box_update_test
			-- Tests the bounding box coordinates update
		local
			l_box: BOUNDING_BOX
		do
			create l_box.make_box(0, 0, 2, 2)
			assert("Initial coordinates test failed.",
						l_box.lower_corner.x ~ 0 and l_box.lower_corner.y ~ 0 and l_box.upper_corner.x ~ 2 and l_box.upper_corner.y ~ 2)
			l_box.update_to([(2).to_double, (2).to_double], [(4).to_double, (4).to_double])
			assert("Updated coordinates test failed.",
						l_box.lower_corner.x ~ 2 and l_box.lower_corner.y ~ 2 and l_box.upper_corner.x ~ 4 and l_box.upper_corner.y ~ 4)
		end
end


