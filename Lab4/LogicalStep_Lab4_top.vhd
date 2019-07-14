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
    leds        : out std_logic_vector(7 downto 0); -- for displaying the switch content
    seg7_data   : out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
    seg7_char1  : out std_logic;                    -- seg7 digi selectors
    seg7_char2  : out std_logic                     -- seg7 digi selectors
    );
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

---------------------------- COMPONENT DECLARATIONS --------------------------------
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
  
  component mealy_state_machineV2 IS Port (
    clk_input, rst_n          : in std_logic;
    extender_out              : in std_logic; -- This is a state, since it is a toggle button
 
    x_drive_en                : in std_logic; -- Pb(3)
    y_drive_en                : in std_logic; -- Pb(2)

    X_EQ, X_GT, X_LT                : in std_logic; -- Inputs from multi-comparator for X
    Y_EQ, Y_GT, Y_LT                : in std_logic; -- Inputs from multi-comparator for y

    extender_en               : out std_logic; 
    x_move_en                 : out std_logic; -- if the clock is on, 1 is increment, 0 is decrement x
    y_move_en                 : out std_logic; -- if the clock is on, 1 is increment, 0 is decrement y
    x_clk_en                  : out std_logic; -- enables 4bit counter for X-drive
    y_clk_en                  : out std_logic; -- enables 4bit counter for Y-drive
    error_led                 : out std_logic  -- LED 0
 );
  end component;
  
  
  component segment7_mux is port (
    clk          : in  std_logic := '0';
    DIN2         : in  std_logic_vector(6 downto 0);    
    DIN1         : in  std_logic_vector(6 downto 0);
    DOUT         : out std_logic_vector(6 downto 0);
    DIG2         : out std_logic;
    DIG1         : out std_logic
);
end component;

component SevenSegment is port (

   err_led  :  in  std_logic;
   clock    :  in  std_logic;
   bin      :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component;

component display_driver is port (
    target    : in  std_logic_vector(3 downto 0);
    curren    : in  std_logic_vector(3 downto 0);
    enable    : in  std_logic;
    seg_7     : out std_logic_vector(3 downto 0)
);
end component;

component MOORE_SM2 is port (
   CLK                : in  std_logic := '0';
   RESET_n            : in  std_logic := '0';
   GRAP_BUTTON        : in  std_logic := '0';
   GRAP_ENBL          : in  std_logic := '0';
   GRAP_ON            : out std_logic
);
end component;


component MOORE_SM1 is port (
    CLK                  : in  std_logic := '0';
    RESET_n              : in  std_logic := '0';
    EXTEND_BTN           : in  std_logic := '0';
    EXTEND_EN            : in  std_logic := '0';
    EXTEND_OUT           : out std_logic;
    GRAPPLE_EN           : out std_logic;
    CLOCK_ENBL           : out std_logic;
    LEFT_RIGHT           : out std_logic

);
end component;

component multi_comparator is
    -- Takes in four single-bit comparators and outputs the final value of A>B, A=B or A<B
    PORT
    (        
        switches          : in  std_logic_vector(3 downto 0); -- The switch inputs
        current           : in  std_logic_vector(3 downto 0); -- Either x or y positions
        A_GT_B            : out std_logic;
        A_EQ_B            : out std_logic;
        A_LT_B            : out std_logic
    );
end component;
----------------------------------------------------------------------------------------------------
    CONSTANT sim                : boolean := FALSE;     -- set to TRUE for simulation runs otherwise keep at 0.
    CONSTANT CLK_DIV_SIZE       : integer := 26;    -- size of vectors for the counters

    SIGNAL   Main_CLK           : std_logic;             -- main clock to drive sequencing of State Machine

    SIGNAL   bin_counter        : unsigned(CLK_DIV_SIZE-1 downto 0); -- := to_unsigned(0,CLK_DIV_SIZE); -- reset binary counter to zero
    
    
--------------- GENERAL INPUT SIGNALS ---------------------
    
    -- Desired position set using switches
    signal x_target   : std_logic_vector(3 downto 0);
    signal y_target   : std_logic_vector(3 downto 0);
    
    -- Initial X and Y position
    signal x_cur   : std_logic_vector(3 downto 0) := "1000";
    signal y_cur   : std_logic_vector(3 downto 0) := "1000";
    
    -- Enable signals for x or y drive
    signal x_drive_en : std_logic;
    signal y_drive_en : std_logic;
    signal x_move_en  : std_logic;
    signal y_move_en  : std_logic;
    
    -- Toggle buttons for extender or grappler
    signal t_ex       : std_logic;
    signal t_gr       : std_logic;    
    
    signal X_EQ       : std_logic;
    signal X_GT       : std_logic;
    signal X_LT       : std_logic;
    signal x_clk_en   : std_logic;
    
    signal Y_EQ       : std_logic;
    signal Y_GT       : std_logic;
    signal Y_LT       : std_logic;
    signal y_clk_en   : std_logic;
    
    signal extender_out    : std_logic;
    signal extender_en     : std_logic;

    signal grp_out         : std_logic;
    signal grp_en          : std_logic;
    signal Shift_clk_en    : std_logic;
    signal Shift_LeftRight : std_logic;

    signal error_led  : std_logic;
    signal x_led      : std_logic_vector(3 downto 0);
    signal y_led      : std_logic_vector(3 downto 0);
    signal seg7_A     : std_logic_vector(6 downto 0);
    signal seg7_B     : std_logic_vector(6 downto 0);

    
----------------------------------------------------------------------------------------------------
BEGIN
-- Gathering inputs:

    x_target <= sw(7 downto 4);
    y_target <= sw(3 downto 0);
     
    x_drive_en <= not(pb(3));
    y_drive_en <= not(pb(2));
    
    t_ex <= not(pb(1));
    t_gr <= not(pb(0));
      
    X_COMPX4: multi_comparator port map (x_cur, x_target, X_GT, X_EQ, X_LT);
    Y_COMPX4: multi_comparator port map (y_cur, y_target, Y_GT, Y_EQ, Y_LT);

    --MEALY_SM: mealy_state_machine port map (Main_Clk, rst_n, ext_out, x_en, y_en, x_target, y_target, x_cur, y_cur, X_EQ, X_GT, X_LT, Y_EQ, Y_GT, Y_LT, ext_en, x_move_en, y_move_en, x_clk, y_clk, err_led);
    MEALY_SM_V2 : mealy_state_machineV2 port map (Main_Clk, rst_n, extender_out, x_drive_en, y_drive_en, X_EQ, X_GT, X_LT, Y_EQ, Y_GT, Y_LT, 
                                                    extender_en, x_move_en, y_move_en, x_clk_en, y_clk_en, error_led);

    MOORE_SM_1  : MOORE_SM1 port map (Main_Clk, rst_n, t_ex, extender_en, extender_out, grp_en, Shift_clk_en, Shift_LeftRight);
    MOORE_SM_2  : MOORE_SM2 port map (Main_Clk, rst_n, t_gr, grp_en, grp_out);

    SHIFTER: Bidir_shift_reg port map (Main_Clk, rst_n, Shift_clk_en, Shift_LeftRight, leds(7 downto 4));

    X_UD_COUNTER: U_D_Bin_Counter4bit port map (Main_Clk, rst_n, x_clk_en, x_move_en, x_cur);
    Y_UD_COUNTER: U_D_Bin_Counter4bit port map (Main_Clk, rst_n, y_clk_en, y_move_en, y_cur);


    -- Display MUXs
    X_DECIDER: display_driver port map (x_target, x_cur, x_drive_en, x_led);
    Y_DECIDER: display_driver port map (y_target, y_cur, y_drive_en, y_led);
    
    MAP_A: SevenSegment port map (error_led, Main_Clk, x_led, seg7_A);
    MAP_B: SevenSegment port map (error_led, Main_Clk, y_led, seg7_B);

    DECODER: segment7_mux port map (clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);
    
    leds(2) <= extender_out;
    leds(1) <= grp_out;
    leds(0) <= error_led;
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