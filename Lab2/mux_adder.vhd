library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_logical is
	
	-- Takes in two 4-bit values, operator (adder), outputs 1 8-bit value for LEDs.
	PORT
	(		
		bin_A		: in std_logic_vector(7 downto 4);
		bin_B		: in std_logic_vector(3 downto 0);
		sum		: in std_logic_vector(7 downto 0);
		OPERATOR	: in std_logic_vector(3 downto 0);
		output_8	: out std_logic_vector(7 downto 0)
	);
end mux_logical;

Architecture logical_operators of mux_logical is


begin

	-- Performs logical operators and pipes output to the LEDs
	with OPERATOR select 
	output_8 <=
		"0000" & (bin_A AND bin_B) when "0001",
		"0000" & (bin_A OR  bin_B) when "0010",
		"0000" & (bin_A XOR bin_B) when "0100",
									  sum when "1000",
							"00000000"	when "0000",
							"11111111"  when others;
	
end Architecture logical_operators;

	