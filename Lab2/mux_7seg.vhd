library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_7seg is
	
	-- Takes in two 4-bit values, operator (adder), outputs an 8-bit value for the 7-SEG based on the button inputs
	PORT
	(		
		bin_A		: in std_logic_vector(3 downto 0);
		bin_B		: in std_logic_vector(7 downto 4);
		sum		: in std_logic_vector(7 downto 0);
		OPERATOR	: in std_logic_vector(3 downto 0);
		output_8	: out std_logic_vector(7 downto 0)
	);
end mux_7seg;

Architecture logical_operators of mux_7seg is

begin

	-- If Operator is ADD (1000) output the SUM
	-- If two or more are pressed return 10001000 (error code 88)
	-- Otherwise output the SWITCHES
	with OPERATOR select 
	output_8 <=
			bin_B & bin_A when "0000",
			bin_B & bin_A when "0001",
			bin_B & bin_A when "0010",
			bin_B & bin_A when "0100",
					  sum	  when "1000",
				"10001000" when others;
			
end Architecture logical_operators;

	