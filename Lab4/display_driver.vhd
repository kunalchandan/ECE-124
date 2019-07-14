library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity display_driver is port (
    target    : in  std_logic_vector(3 downto 0);
    curren    : in  std_logic_vector(3 downto 0);
    enable    : in  std_logic;
    error     : in  std_logic;
    seg_7     : out std_logic
);
end display_driver;

architecture DISPLAY of display_driver is

begin
    with std_logic_vector(enable & error) select
               seg_7 <= target when "00",
                        curren when "10",
                        "1111" when others;

end architecture DISPLAY;