library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity segment7_alu is
	PORT
	(	OPIN1		: in std_logic_vector(3 downto 0);
		OPIN2		: in std_logic_vector(7 downto 4);
		OPERATOR	: in std_logic_vector(3 downto 0);
		LOUT		: out std_logic_vector(7 downto 0)
--		AOUTLed	: out std_logic_vector(7 downto 0);
--		AOUTSeg7	: out std_logic_vector(6 downto 0)
	);
end segment7_alu;

Architecture logical_operators of segment7_alu is

begin
	with OPERATOR select 
	LOUT <=
			"0000" & (OPIN1 AND OPIN2) when "0001",
			"0000" & (OPIN1 OR  OPIN2) when "0010",
			"0000" & (OPIN1 XOR OPIN2) when "0100",
			"00000000" 		 when others;

end Architecture logical_operators;

	