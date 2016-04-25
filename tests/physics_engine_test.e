note
	description: "[
		Eiffel tests that can be executed by testing tool.
		Tests the {PHYSICS_ENGINE} class.
	]"
	author: "Guillaume Jean"
	date: "21 April 2016"
	revision: "16w11a"
	testing: "type/manual"

class
	PHYSICS_ENGINE_TEST

inherit
	EQA_TEST_SET

feature -- Test routines

	attribute_test: BOOLEAN
			-- Attribute used to test the collisions

	physics_engine_test
			-- Tests the physics engine creation
		note
			testing:  "execution/isolated"
		local
			l_physics_engine: PHYSICS_ENGINE
			l_box1, l_box2: BOUNDING_BOX
		do
			create l_physics_engine.make
			create l_box1.make_box(0, 0, 5, 5)
			create l_box2.make_box(2, 2, 7, 7)
			attribute_test := False
			l_box1.collision_actions.extend(agent(a_other: PHYSIC_OBJECT) do attribute_test := True end)
			l_box2.collision_actions.extend(agent(a_other: PHYSIC_OBJECT) do attribute_test := True end)
			l_physics_engine.physic_objects.extend(l_box1)
			l_physics_engine.physic_objects.extend(l_box2)
			l_physics_engine.check_all
			assert("Physics_engine.check_all test failed.", attribute_test)
		end

end


