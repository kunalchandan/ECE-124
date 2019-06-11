library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_comparator is
	
	-- Takes in two digits and outputs if the values are equal, greater than or less than. One of 4 instances.
	PORT
	(		
		bin_A		: in std_logic;
		bin_B		: in std_logic;
		A_GT_B	: out std_logic;	-- A AND B'
		A_EQ_B	: out std_logic;	-- NOT XOR
		A_LT_B	: out std_logic	-- A' AND B
	);
end single_comparator;

Architecture logical_operators of single_comparator is


begin
	
	-- Logical Outputs for Greater than, less than and equal to
	A_GT_B <= bin_A AND (NOT bin_B);
	A_EQ_B <= bin_A XOR bin_B;
	A_LT_B <= (NOT bin_A) AND bin_B;

	
end Architecture logical_operators;

	