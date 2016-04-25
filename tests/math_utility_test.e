note
	description: "[
		Eiffel tests that can be executed by testing tool.
		Tests the {MATH_UTILITY} class.
	]"
	author: "Guillaume Jean"
	date: "21 April 2016"
	revision: "16w11a"
	testing: "type/manual"

class
	MATH_UTILITY_TEST

inherit
	EQA_TEST_SET
	MATH_UTILITY
		undefine
			default_create
		end

feature -- Test routines

	calculate_circle_angle_test
			-- Tests the circle calculating routine
		local
			l_angle_test: REAL_64
		do
			l_angle_test := Pi_4
			assert("Circle angle normal value test failed.", calculate_circle_angle(cosine(l_angle_test), sine(l_angle_test)) ~ l_angle_test)
			assert("Circle angle limit value test failed.", calculate_circle_angle(-1, 0) ~ Pi)
			assert("Circle angle limit value test failed.", calculate_circle_angle(1, 0) ~ 0)
			assert("Circle angle limit value test failed.", calculate_circle_angle(0, -1) ~ Three_Pi_2)
			assert("Circle angle limit value test failed.", calculate_circle_angle(0, 1) ~ Pi_2)
		end

	clamp_test
			-- Tests the clamp routine
		do
			assert("Clamp normal max value test failed.", clamp(10, 0, 20) ~ 10)
			assert("Clamp normal min value test failed.", clamp(-10, 0, 20) ~ 0)
			assert("Clamp limit value test failed.", clamp(0, 0, 20) ~ 0)
			assert("Clamp limit value test failed.", clamp(20, 0, 20) ~ 20)
		end

	modulo_test
			-- Tests the modulo routine
		do
			assert("Modulo normal value test failed.", modulo(10, 5) ~ 0)
			assert("Modulo negative normal value test failed.", modulo(-10, 5) ~ 0)
			assert("Modulo limit value test failed.", modulo(5, 5) ~ 0)
			assert("Modulo negative limit value test failed.", modulo(-1, 5) ~ 4)
		end

	constants_test
			-- Tests the constants in {MATH_UTILITY}
		do
			assert("3 Pi / 2 test failed.", Three_Pi_2 ~ 3 * Pi / 2)
			assert("2 * Pi test failed.", Two_Pi ~ 2 * Pi)
		end
end


