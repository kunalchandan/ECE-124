library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb					: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port (
	clk	: in std_logic :='0';
	DIN2	: in std_logic_vector(6 downto 0);
	DIN1	: in std_logic_vector(6 downto 0);
	DOUT	: out std_logic_vector(6 downto 0);	
	DIG2	: out std_logic;
	DIG1	: out std_logic
	);
	end component;
	
	component segment7_alu port (
	OPIN1		: in std_logic_vector(3 downto 0);
	OPIN2		: in std_logic_vector(7 downto 4);
	OPERATOR	: in std_logic_vector(3 downto 0);
	LOUT		: out std_logic_vector(7 downto 0)
--	AOUTLed	: out std_logic_vector(7 downto 0);
--	AOUTSeg7	: out std_logic_vector(6 downto 0)
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A		: std_logic_vector(6 downto 0);
	signal hex_A		: std_logic_vector(3 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);
	signal hex_B		: std_logic_vector(7 downto 4);
	signal pb_bar		: std_logic_vector(3 downto 0);
	--signal Led_OUT		: std_logic_vector(7 downto 0);
	
-- Here the circuit begins

begin
	
	-- the two digits
	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);
	-- invert push buttons
	pb_bar <= NOT(pb);
	
	
-- Instances (Component)
	INST1: SevenSegment port map (hex_A, seg7_A);
	INST2: SevenSegment port map (hex_B, seg7_B);
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1); 
	INST4: segment7_alu port map (hex_A, hex_B, pb_bar, leds);

 
end SimpleCircuit;

