library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
-- 7-segment display driver. It displays a 4-bit number on a 7-segment
-- This is created as an entity so that it can be reused many times easily
--

entity SevenSegment is port (

   err_led  :  in  std_logic;
   clock    :  in  std_logic;
   bin      :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end SevenSegment;

architecture Behavioral of SevenSegment is
   signal zero   : std_logic;
-- 
-- The following statements convert a 4-bit input, called dataIn to a pattern of 7 bits
-- The segment turns on when it is '1' otherwise '0'
--
begin
   zero <= err_led and clock;
   -- Additional zero prepended to bin vector to identify when the sevenseg display should be cleared
   with zero & bin select --           GFEDCBA        Z3210      -- data in   
                          sevenseg <= "0111111" when "00000",    -- [0]
                                      "0000110" when "00001",    -- [1]
                                      "1011011" when "00010",    -- [2]      +---- a -----+
                                      "1001111" when "00011",    -- [3]      |            |
                                      "1100110" when "00100",    -- [4]      |            |
                                      "1101101" when "00101",    -- [5]      f            b
                                      "1111101" when "00110",    -- [6]      |            |
                                      "0000111" when "00111",    -- [7]      |            |
                                      "1111111" when "01000",    -- [8]      +---- g -----+
                                      "1101111" when "01001",    -- [9]      |            |
                                      "1110111" when "01010",    -- [A]      |            |
                                      "1111100" when "01011",    -- [b]      e            c
                                      "1011000" when "01100",    -- [c]      |            |
                                      "1011110" when "01101",    -- [d]      |            |
                                      "1111001" when "01110",    -- [E]      +---- d -----+
                                      "1110001" when "01111",    -- [F]
                                      "0000000" when  others;    -- [ ]
end architecture Behavioral;
----------------------------------------------------------------------
