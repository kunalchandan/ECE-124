library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MEALY State machine
Entity mealy_state_machine IS Port
(
 clk_input, rst_n          : in std_logic;
 extender_out              : in std_logic; -- This is a state, since it is a toggle button
 
 x_drive_en                : in std_logic;
 y_drive_en                : in std_logic;
 
 x_target                  : in std_logic_vector(3 downto 0);
 y_target                  : in std_logic_vector(3 downto 0);
 
 x_current                  : in std_logic_vector(3 downto 0);
 y_current                  : in std_logic_vector(3 downto 0);
 
 clk_en, x_move, y_move    : out std_logic
 );
END ENTITY;
 

 Architecture SM of mealy_state_machine is
 
 
 -- Set of all possible states
 TYPE STATE_NAMES IS 
     (idle, 
      x_moving, 
		y_moving, 
		xy_moving, 
		error);

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES
 Signal x_pos <= x_current;
 Signal y_pos <= y_current;

 BEGIN
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, rst_n)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= idle;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_State;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (x_drive_en, y_drive_en, x_pos, y_pos, x_target, y_target, extender_out, current_state) 

BEGIN
     CASE current_state IS
			
			 -- All idle state transitions
          WHEN idle =>		
				IF((extender_out='1') and ((x_drive_en ='1' and x_pos /= x_target) or (y_drive_en ='1' and y_pos /= y_target))) THEN
					next_state <= error;
					
				ELSIF(extender_out='1') THEN
					IF ((x_drive_en ='1' and x_pos /= x_target) and (y_drive_en ='1' and y_pos /= y_target)) THEN
						next_state <= xy_moving;
						
					ELSIF(x_drive_en ='1' and x_pos /= x_target) THEN
						next_state <= x_moving;
						
					ELSIF(y_drive_en ='1' and y_pos /= y_target) THEN
						next_state <= y_moving
						
					ELSE
						next_state <= idle;
						
					END IF;
					
				ELSE
					next_state <= idle;
					
				END IF;
				
			-- All xy_moving state transitions
         WHEN xy_moving =>		
					
					-- If we reach desired position -> Idle
					IF((x_pos = x_target) and (y_pos = y_target)) THEN
						next_state <= idle;
					
					-- If we release BOTH drive btns -> Idle
					ELSIF((x_drive_en = '0') and (y_drive_en ='0')) THEN
						next_state <= idle;
					
					-- If we release the X-drive -> y_moving
					ELSIF(x_drive_en = '0') THEN
						next_state <= y_moving;
						
					-- If X reaches its target and btns are held -> y_moving
					ELSIF((x_pos = x_target) and (y_drive_en ='1' and y_pos /= y_target) THEN
						next_state <= y_moving;	
						
					-- If we release the Y-drive -> x_moving
					ELSIF(y_drive_en = '0') THEN
						next_state <= x_moving;
					
					-- If Y reaches its target and btns are held -> x_moving
					ELSIF((x_drive_en ='1' and x_pos /= x_target) and (y_pos = y_target) THEN
						next_state <= x_moving;

					-- Otherwise stay in xy-moving
					ELSE
						next_state <= xy_moving;
					

			
         WHEN x_moving =>
				IF(x_pos = x_target) THEN
					next_state <= idle;
				ELSE
					next_state <= x_moving;
				END IF;
				
         WHEN S3 =>		
				IF(I0='1') THEN
					next_state <= S4;
				ELSE
					next_state <= S3;
				END IF;

         WHEN S4 =>		
					next_state <= S5;

         WHEN S5 =>		
					next_state <= S6;
				
         WHEN S6 =>		
				IF(I0='1') THEN
					next_state <= S7;
				ELSE
					next_state <= S6;
				END IF;
				
         WHEN S7 =>		
				IF(I2='1') THEN
					next_state <= S0;
				ELSE
					next_state <= S7;
				END IF;

				WHEN OTHERS =>
               next_state <= S0;
 		END CASE;

 END PROCESS;

-- DECODER SECTION PROCESS (Moore Form) CHANGE TO MEALY -- ADD MULTI-COMPARATOR OUTPUTS

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
         WHEN S0 =>		
			output1 <= '1';
			output2 <= '0';
			
         WHEN S1 =>		
			output1 <= '0';
			output2 <= '0';

         WHEN S2 =>		
			output1 <= '0';
			output2 <= '0';
			
         WHEN S3 =>		
			output1 <= '0';
			output2 <= '0';

         WHEN S4 =>		
			output1 <= '0';
			output2 <= '0';

         WHEN S5 =>		
			output1 <= '0';
			output2 <= '0';
				
         WHEN S6 =>		
			output1 <= '0';
			output2 <= '1';
				
         WHEN S7 =>		
			output1 <= '0';
			output2 <= '0';
				
         WHEN others =>		
 			output1 <= '0';
			output2 <= '0';
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
