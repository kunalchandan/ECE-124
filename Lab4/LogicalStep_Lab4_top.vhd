
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

  -- COMPONENT DECLARATIONS
  component Bidir_shift_reg is port (
    CLK          : in  std_logic := '0';
	 RESET_n      : in  std_logic := '0';
	 CLK_EN       : in  std_logic := '0'; 
	 LEFTO_RIGHT1 : in  std_logic := '0';
	 REG_BITS     : out std_logic_vector(7 downto 0)
  ); 
  end component; 
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim							:  boolean := TRUE; 	-- set to TRUE for simulation runs otherwise keep at 0.
   CONSTANT CLK_DIV_SIZE				: 	INTEGER := 26;    -- size of vectors for the counters

   SIGNAL 	Main_CLK						:  STD_LOGIC; 			-- main clock to drive sequencing of State Machine

	SIGNAL 	bin_counter					:  UNSIGNED(CLK_DIV_SIZE-1 downto 0); -- := to_unsigned(0,CLK_DIV_SIZE); -- reset binary counter to zero
	
	
--------------- GENERAL INPUT SIGNALS ---------------------
	
	--
	signal x_target   : std_logic_vector(3 downto 0);
	signal y_target   : std_logic_vector(3 downto 0);
	
	-- Initial X and Y position
	signal x_current   : std_logic_vector(3 downto 0);
	signal y_current   : std_logic_vector(3 downto 0);
	
	-- Enable signals for x or y drive
	signal x_en       : std_logic;
	signal y_en       : std_logic;
	
	-- Toggle buttons for extender or grappler
	signal t_ex       : std_logic;
	signal t_gr       : std_logic;	

	
----------------------------------------------------------------------------------------------------
BEGIN
-- Gathering inputs::

    x_target <= sw(7 downto 4);
	 y_target <= sw(3 downto 0);
	 
	 x_en <= pb(3);
	 y_en <= pb(2);
	 
	 t_ex <= pb(1);
	 t_gr <= pb(1);

	 x_cur <= "0000";
	 y_cur <= "0000";

-- PROCESSES
-- CLOCKING GENERATOR WHICH DIVIDES THE INPUT CLOCK DOWN TO A LOWER FREQUENCY

   BinCLK: PROCESS(clkin_50, rst_n) is
   BEGIN
		IF (rising_edge(clkin_50)) THEN -- binary counter increments on rising clock edge
         bin_counter <= bin_counter + 1;
      END IF;
   END PROCESS;

   Clock_Source:
				Main_Clk <= 
				clkin_50 when sim = TRUE else				-- for simulations only
				std_logic(bin_counter(23));				-- for real FPGA operation
				
   SHIFTER: Bidir_shift_reg port map (Main_Clk, rst_n, pb(1), pb(0), leds);
	
					
---------------------------------------------------------------------------------------------------

END SimpleCircuit;
