library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab3_top is port (
   clkin_50		: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	
); 
end LogicalStep_Lab3_top;


architecture Energy_Monitor of LogicalStep_Lab3_top is
--
-- Components Used
------------------------------------------------------------------- 

	component multi_comparator is PORT (		
			sw   		: in  std_logic_vector(7 downto 0); -- The switch inputs
			A_GT_B	: out std_logic;
			A_EQ_B	: out std_logic;	
			A_LT_B	: out std_logic	
	);
	end component;
------------------------------------------------------------------
	
	
-- Create any signals, or temporary variables to be used
	signal switches : std_logic_vector(7 downto 0);
	signal GT       : std_logic;
	signal EQ       : std_logic;
	signal LT       : std_logic;
	
	
-- Here the circuit begins

begin

	comp : multi_comparator port map (switches, GT, EQ, LT);
	
 
end Energy_Monitor;

