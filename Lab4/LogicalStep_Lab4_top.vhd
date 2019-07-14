LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
    (
    clkin_50    : in  std_logic;
    rst_n       : in  std_logic;
    pb          : in  std_logic_vector(3 downto 0);
    sw          : in  std_logic_vector(7 downto 0); -- The switch inputs
    leds        : out std_logic_vector(7 downto 0);    -- for displaying the switch content
    seg7_data   : out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
    seg7_char1  : out std_logic;                            -- seg7 digi selectors
    seg7_char2  : out std_logic                            -- seg7 digi selectors
    );
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

  -- COMPONENT DECLARATIONS
  component Bidir_shift_reg is port (
    CLK          : in  std_logic := '0';
    RESET_n      : in  std_logic := '0';
    CLK_EN       : in  std_logic := '0'; 
    LEFTO_RIGHT1 : in  std_logic := '0';
    REG_BITS     : out std_logic_vector(3 downto 0)
);
end component; 
  
  component U_D_Bin_Counter4bit is port (
    CLK          : in  std_logic := '0';
    RESET_n      : in  std_logic := '0';
    CLK_EN       : in  std_logic := '0';
    UP1_DOWN0    : in  std_logic := '0';
    COUNTER_BITS : out std_logic_vector(3 downto 0)
);
end component;
  
  component mealy_state_machine IS Port (
    clk_input, rst_n          : in std_logic;
    extender_out              : in std_logic; -- This is a state, since it is a toggle button
     
    x_drive_en                : in std_logic;
    y_drive_en                : in std_logic;
    
    x_target                  : in std_logic_vector(3 downto 0);
    y_target                  : in std_logic_vector(3 downto 0);
     
    x_current                 : in std_logic_vector(3 downto 0);
    y_current                 : in std_logic_vector(3 downto 0);
    
    X_EQ, X_GT, X_LT          : in std_logic; -- Inputs from multi-comparator for X
    Y_EQ, Y_GT, Y_KT          : in std_logic; -- Inputs from multi-comparator for y     
    extender_en               : out std_logic;
    x_move_en                 : out std_logic;
    y_move_en                 : out std_logic;
    x_clk_en                  : out std_logic;
    y_clk_en                  : out std_logic;
    error_led                 : out std_logic
 );
  end component;
    
----------------------------------------------------------------------------------------------------
    CONSTANT sim                : boolean := TRUE;     -- set to TRUE for simulation runs otherwise keep at 0.
    CONSTANT CLK_DIV_SIZE       : integer := 26;    -- size of vectors for the counters

    SIGNAL   Main_CLK           : std_logic;             -- main clock to drive sequencing of State Machine

    SIGNAL   bin_counter        : unsigned(CLK_DIV_SIZE 1 downto 0); -- := to_unsigned(0,CLK_DIV_SIZE); -- reset binary counter to zero
    
    
--------------- GENERAL INPUT SIGNALS ---------------------
    
    -- Desired position set using switches
    signal x_target   : std_logic_vector(3 downto 0);
    signal y_target   : std_logic_vector(3 downto 0);
    
    -- Initial X and Y position
    signal x_current   : std_logic_vector(3 downto 0);
    signal y_current   : std_logic_vector(3 downto 0);
    
    -- Enable signals for x or y drive
    signal x_en_btn   : std_logic;
    signal y_en_btn   : std_logic;
    
    -- Toggle buttons for extender or grappler
    signal t_ex       : std_logic;
    signal t_gr       : std_logic;    
    
    signal X_ET       : std_logic;
    signal X_GT       : std_logic;
    signal X_LT       : std_logic;
    signal x_clk      : std_logic;
    
    signal Y_EQ       : std_logic;
    signal Y_GT       : std_logic;
    signal Y_LT       : std_logic;
    signal y_clk      : std_logic;
    
    signal ext_out    : std_logic;
    signal ext_en     : std_logic;
    
    signal x_led      : std_logic_vector(3 downto 0);
    signal y_led      : std_logic_vector(3 downto 0);
    signal seg7_A     : std_logic_vector(6 downto 0);
    signal seg7_B     : std_logic_vector(6 downto 0);

    
----------------------------------------------------------------------------------------------------
BEGIN
-- Gathering inputs:

    x_target <= sw(7 downto 4);
    y_target <= sw(3 downto 0);
     
    x_en_btn <= pb(3);
    y_en_btn <= pb(2);
    
    t_ex <= pb(1);
    t_gr <= pb(1);

    x_cur <= "0000";
    y_cur <= "0000";
     
     
     --MEALY_SM: mealy_state_machine port map (Main_Clk, rst_n, ext_out, x_en, y_en, x_target, y_target, x_cur, y_cur, X_EQ, X_GT, X_LT, Y_EQ, Y_GT, Y_LT, ext_en, x_move_en, y_move_en, x_clk, y_clk, err_led);
    MEALY_SM_V2 : mealy_state_machine port map (Main_Clk, rst_n, ext_out, x_en_btn, y_en_btn, X_EQ, X_GT, X_LT, Y_EQ, Y_GT, Y_LT, ext_en, x_move_en, y_move_en, x_clk, y_clk, err_led);
     
    X_UD_COUNTER: U_D_Bin_Counter4bit port map (Main_Clk, rst_n, x_clk, x_move_en, x_cur);
    Y_UD_COUNTER: U_D_Bin_Counter4bit port map (Main_Clk, rst_n, y_clk, y_move_en, y_cur);
     
    X_COMPX4: multi_comparator port map (x_target, x_cur, X_GT, X_EQ, X_LT);
    Y_COMPX4: multi_comparator port map (y_target, y_cur, Y_GT, Y_EQ, Y_LT);


    -- Display MUXs
    DECIDER: display_driver port map (x_target, x_cur, x_en_btn, err_led, x_led);
    DECIDER: display_driver port map (y_target, y_cur, y_en_btn, err_led, y_led);
    
    MAP_A: SevenSegment port map (x_led, seg7_A);
    MAP_B: SevenSegment port map (y_led, seg7_B);

    DECODER: segment7_mux port map (clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);

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
                clkin_50 when sim = TRUE else              -- for simulations only
                std_logic(bin_counter(23));                -- for real FPGA operation
                
  -- SHIFTER: Bidir_shift_reg port map (Main_Clk, rst_n, pb(1), pb(0), leds);
    
                    
---------------------------------------------------------------------------------------------------

END SimpleCircuit;