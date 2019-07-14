library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY MOORE_SM2 IS PORT (
   CLK                : in  std_logic := '0';
   RESET_n            : in  std_logic := '0';
   GRAP_BUTTON        : in  std_logic := '0';
   GRAP_ENBL          : in  std_logic := '0';
   GRAP_ON            : out std_logic
);
END ENTITY;

ARCHITECTURE SM OF MOORE_SM2 IS

-- list all the STATES  
   TYPE STATES IS (INIT, GRAP_OPEN, GRAP_CLOSED);   

   SIGNAL current_state, next_state    :  STATES;       -- current_state, next_state signals are of type STATES
BEGIN


-- STATE MACHINE: MOORE Type

REGISTER_SECTION: PROCESS(CLK, RESET_n) -- creates sequential logic to store the state. The rst_n is used to asynchronously clear the register
   BEGIN
      IF (RESET_n = '0') THEN
         current_state <= INIT;
      ELSIF (rising_edge(CLK)) then
         current_state <= next_state; -- on the rising edge of clock the current state is updated with next state
      END IF;
   END PROCESS;
    

TRANSITION_LOGIC: PROCESS(GRAP_ENBL, GRAP_BUTTON, current_state) -- logic to determine next state. 
   BEGIN
      CASE current_state IS
         WHEN INIT =>        
            IF (GRAP_ENBL='1') THEN 
               next_state <= GRAP_OPEN;
            ELSE
               next_state <= INIT;
            END IF;
        
         WHEN GRAP_OPEN =>        
            IF ((GRAP_ENBL='1') AND (GRAP_BUTTON='1')) THEN 
               next_state <= GRAP_CLOSED;
                ELSE
               next_state <= GRAP_OPEN;
            END IF;

         WHEN GRAP_CLOSED =>        
            IF ((GRAP_ENBL='1') AND (GRAP_BUTTON='1')) THEN 
               next_state <= GRAP_OPEN;
            ELSE
               next_state <= GRAP_CLOSED;
            END IF;
                
         WHEN OTHERS =>
            next_state <= INIT;
                    
         END CASE;
 END PROCESS;

 MOORE_DECODER: PROCESS(current_state)             -- logic to determine outputs from state machine states
   BEGIN
      CASE current_state IS
         WHEN INIT =>        
            GRAP_ON    <= '0';

         WHEN GRAP_OPEN =>        
            GRAP_ON    <= '0';
                          
         WHEN GRAP_CLOSED =>
            GRAP_ON    <= '1';
             
         WHEN OTHERS =>
            GRAP_ON    <= '0';
             
        END CASE;

 END PROCESS;
END SM;
