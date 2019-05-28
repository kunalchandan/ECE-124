library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
-- 7-segment display driver. It displays a 4-bit number on a 7-segment
-- This is created as an entity so that it can be reused many times easily
--

entity SevenSegment is port (
   
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end SevenSegment;

architecture Behavioral of SevenSegment is

-- 
-- The following statements convert a 4-bit input, called dataIn to a pattern of 7 bits
-- The segment turns on when it is '1' otherwise '0'
--
begin
   with hex select						     --GFEDCBA        3210      -- data in   
	sevenseg 				    <= "0111111" when "0000",    -- [0]
										 "0000110" when "0001",    -- [1]
										 "1011011" when "0010",    -- [2]      +---- a -----+
										 "1001111" when "0011",    -- [3]      |            |
										 "1100110" when "0100",    -- [4]      |            |
										 "1101101" when "0101",    -- [5]      f            b
										 "1111101" when "0110",    -- [6]      |            |
										 "0000111" when "0111",    -- [7]      |            |
										 "1111111" when "1000",    -- [8]      +---- g -----+
										 "1101111" when "1001",    -- [9]      |            |
										 "1110111" when "1010",    -- [A]      |            |
										 "1111100" when "1011",    -- [b]      e            c
										 "1011000" when "1100",    -- [c]      |            |
										 "1011110" when "1101",    -- [d]      |            |
										 "1111001" when "1110",    -- [E]      +---- d -----+
										 "1110001" when "1111",    -- [F]
										 "0000000" when others;    -- [ ]
end architecture Behavioral; 
----------------------------------------------------------------------
