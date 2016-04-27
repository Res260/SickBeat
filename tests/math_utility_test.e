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

	dot_product_test
			-- Tests the `dot_product' routine
		do
			assert("Dot product normal test failed.", dot_product([5.0, 5.0], [5.0, 5.0]) ~ 50.0)
			assert("Dot product normal test 2 failed.", dot_product([0.0, 0.0], [0.0, 0.0]) ~ 0.0)
		end

	normalize_vector_test
			-- Tests the `normalize_vector' routine
		local
			l_vector_test: TUPLE[x, y: REAL_64]
			l_norm_result: REAL_64
			l_assert_result: BOOLEAN
		do
			l_vector_test := [(3).to_double, (4).to_double]
			l_norm_result := normalize_vector(l_vector_test)
			l_assert_result := l_norm_result ~ 5 and l_vector_test.x ~ (3.0/5.0) and l_vector_test.y ~ (4.0/5.0)
			assert("Normalized vector normal test failed.", l_assert_result)
			l_vector_test := [0.0, 0.0]
			l_norm_result := normalize_vector(l_vector_test)
			l_assert_result := l_norm_result ~ 0 and l_vector_test.x ~ 0.0 and l_vector_test.y ~ 0.0
			assert("Normalized vector limit test failed.", l_assert_result)
		end

	normalize_angle_test
			-- Tests the `normalize_angle' routine
		do
			assert("Normalized angle normal test failed.", normalize_angle(0, 0) ~ 0)
			assert("Normalized angle lower limit test failed.", normalize_angle(-Pi, Pi) ~ Pi)
			assert("Normalized angle upper limit test failed.", normalize_angle(Pi, Pi) ~ Pi)
		end

	is_angle_in_range_test
			-- Tests the `is_angle_in_range' routine
		do
			assert("Angle range normal test failed.", is_angle_in_range(Pi, 0, Two_Pi))
			assert("Angle range lower limit test failed.", is_angle_in_range(0, 0, Two_Pi))
			assert("Angle range upper limit test failed.", is_angle_in_range(Two_Pi, 0, Two_Pi))
		end

	are_is_angle_in_ranges_equal_test
			-- Test to verify the equality of the two methods
			-- is_angle_in_range is a better optimized version of is_angle_in_range2
			-- Temporary
		local
			l_angle_test: REAL_64
		do
			from
				l_angle_test := -Two_Pi
			until
				l_angle_test > Two_Pi
			loop
				assert("is_angle_in_range inequality.", is_angle_in_range(l_angle_test, Pi_2, Pi) ~ is_angle_in_range2(l_angle_test, Pi_2, Pi))
				l_angle_test := l_angle_test + (1 / (Pi * 720))
			end
		end

	calculate_circle_angle_test
			-- Tests the circle calculating routine
		local
			l_angle_test: REAL_64
		do
			l_angle_test := Pi_4
			assert("Circle angle normal value test failed.", atan2(cosine(l_angle_test), sine(l_angle_test)) ~ l_angle_test)
			assert("Circle angle limit value test failed.", atan2(-1, 0) ~ Pi)
			assert("Circle angle limit value test failed.", atan2(1, 0) ~ 0)
			assert("Circle angle limit value test failed.", atan2(0, -1) ~ Three_Pi_2)
			assert("Circle angle limit value test failed.", atan2(0, 1) ~ Pi_2)
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


