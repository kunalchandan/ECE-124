library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY MOORE_SM2 IS PORT (
    CLK                  : in  std_logic := '0';
    RESET_n              : in  std_logic := '0';
    EXTEND_BTN           : in  std_logic := '0';
    EXTEND_EN            : in  std_logic := '0';
    GRAP_ON              : out std_logic
);
END ENTITY;

ARCHITECTURE SM OF MOORE_SM2 IS

-- list all the STATES  
   TYPE STATES IS (INIT, RETRACTED, FW_EXTENDING_1, FW_EXTENDING_2, FW_EXTENDING_3, BW_EXTENDING_1, BW_EXTENDING_2, BW_EXTENDING_3, FULL_EXTEND);

   SIGNAL current_state, next_state            :  STATES;       -- current_state, next_state signals are of type STATES
-- SIGNAL OPEN1_CLOSE0    : std_logic;

BEGIN


-- STATE MACHINE: MOORE Type

REGISTER_SECTION: PROCESS(CLK, RESET_n, next_state) -- creates sequential logic to store the state. The rst_n is used to asynchronously clear the register
BEGIN
    IF (RESET_n = '0') THEN
        current_state <= INIT;
    ELSIF (rising_edge(CLK)) then
        current_state <= next_state; -- on the rising edge of clock the current state is updated with next state
    END IF;
END PROCESS;
    

TRANSITION_LOGIC: PROCESS(EXTEND_EN, EXTEND_BTN, current_state) -- logic to determine next state. 
BEGIN
    CASE current_state IS
        -- Initial state, if EXTEND_EN, begin opening
        WHEN INIT =>        
            IF ((EXTEND_EN='1') AND (EXTEND_BTN='1')) THEN 
                next_state <= FW_EXTENDING_1;
            ELSE
                next_state <= INIT;
            END IF;
                
        -- Retracted state, if EXTEND_EN, begin opening
        WHEN RETRACTED =>        
            IF ((EXTEND_EN='1') AND (EXTEND_BTN='1')) THEN 
                next_state <= FW_EXTENDING_1;
            ELSE
                next_state <= RETRACTED;
            END IF;

        -- OPENING STATES
        WHEN FW_EXTENDING_1 =>
            next_state <= FW_EXTENDING_2;
                
        WHEN FW_EXTENDING_2 =>
            next_state <= FW_EXTENDING_3;
                
        WHEN FW_EXTENDING_3 =>
            next_state <= FULL_EXTEND;
                
                
        -- CLOSING STATES
        WHEN BW_EXTENDING_1 =>
            next_state <= RETRACTED;
                
        WHEN BW_EXTENDING_2 =>
            next_state <= BW_EXTENDING_1;
                
        WHEN BW_EXTENDING_3 =>
            next_state <= BW_EXTENDING_2;
                
        -- FULLY EXTENDED STATE
        WHEN FULL_EXTEND =>        
            IF ((EXTEND_EN='1') AND (EXTEND_BTN='0')) THEN 
               next_state <= BW_EXTENDING_3;
            ELSE
                next_state <= FULL_EXTEND;
            END IF;
        
        -- OTHERS
        WHEN OTHERS =>
                next_state <= INIT;
         END CASE;
 END PROCESS;

 MOORE_DECODER: PROCESS(current_state)             -- logic to determine outputs from state machine states
   BEGIN
     CASE current_state IS
      -- INIT, RETRACTED, FW_EXTENDING_1, FW_EXTENDING_2, FW_EXTENDING_3, BW_EXTENDING_1, BW_EXTENDING_2, BW_EXTENDING_3, FULL_EXTEND
      
            WHEN INIT =>
                EXTEND_OUT <= '0';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '0';
                LEFT_RIGHT <= '-'; -- DON'T CARE
      
            WHEN RETRACTED =>
                EXTEND_OUT <= '0';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '0';
                LEFT_RIGHT <= '-'; -- DON'T CARE
      
            WHEN FW_EXTENDING_1 =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '1';
                LEFT_RIGHT <= '1';
      
            WHEN FW_EXTENDING_2 =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '1';
                LEFT_RIGHT <= '1';
      
            WHEN FW_EXTENDING_3 =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '1';
                LEFT_RIGHT <= '1';
      
            WHEN BW_EXTENDING_1 =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '1';
                LEFT_RIGHT <= '0';
      
            WHEN BW_EXTENDING_2 =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '1';
                LEFT_RIGHT <= '0';
      
            WHEN BW_EXTENDING_3 =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '0';
                CLOCK_ENBL <= '1';
                LEFT_RIGHT <= '0';
      
            WHEN FULL_EXTEND =>
                EXTEND_OUT <= '1';
                GRAPPLE_EN <= '1';
                CLOCK_ENBL <= '0';
                LEFT_RIGHT <= '-'; -- DON'T CARE
             
        END CASE;

 END PROCESS;
END SM;
