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
   bin   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
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
	);
	end component;
	
	component mux_adder port (
	LEDS_IN	: in std_logic_vector(7 downto 0);
	OPERATOR	: in std_logic_vector(3 downto 0);
	BIN_A		: out std_logic_vector(7 downto 4);
	BIN_B		: out std_logic_vector(3 downto 0)
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--

	signal seg7_A		: std_logic_vector(6 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);
	signal bin_A		: std_logic_vector(3 downto 0);
	signal bin_B		: std_logic_vector(7 downto 4);
	signal pb_bar		: std_logic_vector(3 downto 0);
	signal leds_in		: std_logic_vector(7 downto 0);
	
	--signal Led_OUT		: std_logic_vector(7 downto 0);
	
-- Here the circuit begins

begin
	
	-- the two digits in binary (4-bit)
	bin_A <= sw(3 downto 0);
	bin_B <= sw(7 downto 4);
	-- invert push buttons
	pb_bar <= NOT(pb);
	
	leds_in <= leds(7 downto 0);
	
	
-- Instances (Component)

-- Both binary numbers, operator, LED array
	INST4: segment7_alu port map (bin_A, bin_B, pb_bar, leds);
	
-- TODO: Add a layer (mux_compnent) that takes in LEDS and returns both 4-bit digits
	INST0: mux_adder port map (leds_in, pb_bar, bin_A, bin_B); 
	
-- Bin to hex
	INST1: SevenSegment port map (bin_A, seg7_A);
	INST2: SevenSegment port map (bin_B, seg7_B);
	
-- Interprets and creates the numbers on sevenseg-display.
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1);

 
end SimpleCircuit;

