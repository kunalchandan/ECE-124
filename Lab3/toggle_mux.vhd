library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity toggle_mux is port (
     INPUT       : in  std_logic;
     dor_stat    : in  std_logic;
     win_stat    : in  std_logic;
     OUTPUT      : out std_logic
);
end toggle_mux;

architecture TOGGLE of toggle_mux is

	
begin
     OUTPUT <= INPUT AND dor_stat AND win_stat;
end architecture TOGGLE;