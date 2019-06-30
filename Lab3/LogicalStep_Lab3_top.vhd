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

	component multi_comparator is port (		
		switches   		: in  std_logic_vector(7 downto 0); -- The switch inputs
		A_GT_B			: out std_logic;
		A_EQ_B			: out std_logic;	
		A_LT_B			: out std_logic	
	);
	end component;
	
		
	component desired_temp is port (
     vac_stat       : in  std_logic;
     set_temp       : in  std_logic_vector(3 downto 0);
     desired        : out std_logic_vector(3 downto 0)
	);
	end component;
		
	component toggle_mux is port (
     INPUT       : in  std_logic;
     dor_stat    : in  std_logic;
     win_stat    : in  std_logic;
     OUTPUT      : out std_logic
	);
	end component;
		
	component SevenSegment is port (
   
		bin	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
		sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
	); 
	end component;
		
	component segment7_mux is port (
		clk         : in  std_logic := '0';
		DIN2 			: in  std_logic_vector(6 downto 0);	
		DIN1 			: in  std_logic_vector(6 downto 0);
		DOUT			: out	std_logic_vector(6 downto 0);
		DIG2			: out	std_logic;
		DIG1			: out	std_logic
	);
	end component;
------------------------------------------------------------------
	
	
-- Create any signals, or temporary variables to be used
   signal desired  : std_logic_vector(3 downto 0);
   signal current  : std_logic_vector(3 downto 0);

	signal GT        : std_logic;
	signal EQ        : std_logic;
	signal LT        : std_logic;
	
 	signal seg7_A    :	std_logic_vector(6 downto 0);
	signal seg7_B    :	std_logic_vector(6 downto 0);
	
	signal fur_stat  : std_logic;
	signal tmp_stat  : std_logic;
	signal a_c_stat  : std_logic;
	signal blo_stat  : std_logic;	
	
	signal dor_stat  : std_logic;
	signal win_stat  : std_logic;
	
	signal vac_stat  : std_logic;

   signal TEST_PASS : std_logic;
	
	
-- Here the circuit begins

begin
	
	-- Temperature signals based on binary (switches)
   current <= sw(3 downto 0);
	
	-- Take in the push button status, invert it because it is by default 1 when not pushed
	dor_stat <= NOT(pb(0));
	win_stat <= NOT(pb(1));
	vac_stat <= NOT(pb(3));
	
	-- Define a mux that will take in the vacataion push button and the desired_switches and decide what to set the final desired temperature to.
	DESIRE:    desired_temp port map (vac_stat, sw(7 downto 4), desired);
	
	-- Compares the current with the desired temperature and returns 3 std_logic signals that represent > == <
	CONDITION: multi_comparator port map (current & desired, GT, EQ, LT);
	
	-- Does not require its own mux if the system is at desired temperature.
	tmp_stat <= EQ;
	
	-- Create a toggle MUX that will turn something(AC or Furnace) if all parameters are satisfied -- dor_stat==true, win_stat=true
	FURNACE_M: toggle_mux port map (LT, dor_stat, win_stat, fur_stat);
	AIR_CON_M: toggle_mux port map (GT, dor_stat, win_stat, a_c_stat);
	BLOWER_M : toggle_mux port map (fur_stat or a_c_stat, dor_stat, win_stat, blo_stat);	
	
	-- Map the binary value to 7 segment compatible input
	MAP_A: SevenSegment port map (desired, seg7_A);
	MAP_B: SevenSegment port map (current, seg7_B);

	-- 
   DECODER: segment7_mux port map (clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);

	-- Output for various signals (led(6) is in its own Testbench1 process).
   leds(7) <= vac_stat;
   leds(5) <= win_stat;
   leds(4) <= dor_stat;
   leds(3) <= blo_stat;
   leds(2) <= a_c_stat;
   leds(1) <= tmp_stat;
   leds(0) <= fur_stat;
	
PROCESS (sw, GT, EQ, LT, pb(2)) is
   variable EQ_PASS, GE_PASS, LE_PASS : std_logic :=	'0';

	begin

		IF    ((sw(3 downto 0)  = sw(7 downto 4)) AND (EQ = '1')) THEN
			EQ_PASS := '1';
			GE_PASS := '0';
			LE_PASS := '0';
		
		ELSIF ((sw(3 downto 0) >= sw(7 downto 4)) AND (GT = '1')) THEN
			GE_PASS := '1';
			EQ_PASS := '0';
			LE_PASS := '0';
		
		ELSIF ((sw(3 downto 0) <= sw(7 downto 4)) AND (LT = '1')) THEN
			LE_PASS := '1';
			EQ_PASS := '0';
			GE_PASS := '0';
		
		ELSE 
			LE_PASS := '0';
			EQ_PASS := '0';
			GE_PASS := '0';
		
		END IF;
		
		TEST_PASS <= pb(2) AND ( EQ_PASS OR GE_PASS OR LE_PASS);
		leds(6) <= TEST_PASS;
end process;
	
 
end Energy_Monitor;

