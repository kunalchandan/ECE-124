library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_adder is
	
	-- Takes in two 4-bit values, operator (adder), outputs two 4-bit values.
	PORT
	(		
		LEDS_IN	: in std_logic_vector(7 downto 0);
		OPERATOR	: in std_logic_vector(3 downto 0);
		BIN_A		: out std_logic_vector(7 downto 4);
		BIN_B		: out std_logic_vector(3 downto 0)
	);
end mux_adder;

Architecture logical_operators of mux_adder is

	signal SUM_OF_BINS	: std_logic_vector(7 downto 0); 

begin

	-- Takes in the 8 bit number and adds its digits when PB3 is pressed. Otherwise leaves as is.
	with OPERATOR select 
		SUM_OF_BINS <= 
		"0000" & std_logic_vector(unsigned(LEDS_IN(7 downto 4)) + unsigned(LEDS_IN(3 downto 0))) when "1000",
		LEDS_IN when others;
							
	-- Split the sum into its digits:
		BIN_A <= SUM_OF_BINS(7 downto 4);
		BIN_B <= SUM_OF_BINS(3 downto 0);
		
		
		
	-- If operator is 1000
	-- Add both binary digits
	-- Split into OUT1 and OUT2
	-- OUT1 = HEX_A
	-- OUT2 =
			
end Architecture logical_operators;

	