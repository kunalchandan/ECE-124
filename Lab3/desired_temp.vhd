library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity desired_temp is port (
     vac_stat       : in  std_logic;
     set_temp       : in  std_logic_vector(3 downto 0);
     desired        : out std_logic_vector(3 downto 0)
);
end desired_temp;

architecture DESIRED of desired_temp is

	
begin
     with vac_stat select
	  desired <= "0100"   when '1',
	             set_temp when others;
end architecture DESIRED;