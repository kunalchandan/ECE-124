library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MEALY State machine
Entity mealy_state_machine IS Port
(
 clk_input, rst_n          : in std_logic;
 extender_out              : in std_logic; -- This is a state, since it is a toggle button
 
 x_drive_en                : in std_logic; -- Pb(3)
 y_drive_en                : in std_logic; -- Pb(2)
 
 X_EQ, X_GT, X_LT				: in std_logic; -- Inputs from multi-comparator for X
 Y_EQ, Y_GT, Y_KT				: in std_logic; -- Inputs from multi-comparator for y
 
 extender_en               : out std_logic; 
 x_move_en                 : out std_logic; -- if the clock is on, 1 is increment, 0 is decrement x
 y_move_en                 : out std_logic; -- if the clock is on, 1 is increment, 0 is decrement y
 x_clk_en                  : out std_logic; -- enables 4bit counter for X-drive
 y_clk_en                  : out std_logic; -- enables 4bit counter for Y-drive
 error_led                 : out std_logic; -- LED 0
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



-- TRANSITION LOGIC PROCESS -- Note: x_pos, y_pos might not be needed as they are signals 

Transition_Section: PROCESS (x_drive_en, y_drive_en, extender_out, current_state) 

BEGIN
     CASE current_state IS
			
---------------------------ALL IDLE STATE TRANSITIONS -----------------------------------------------------

          WHEN idle =>		
				
				-- If extender is out, current position is not desired position and the drives are enabled -> error
				IF((extender_out='1') and ((x_drive_en ='1' and X_EQ='0') or (y_drive_en ='1' and Y_EQ='0'))) THEN
					next_state <= error;
				
				-- If extender is retracted:
				ELSIF(extender_out='0') THEN
				
					-- current (x,y) != desired (x,y) and both drives are enabled -> xy_moving
					IF ((x_drive_en ='1' and X_EQ='0') and (y_drive_en ='1' and Y_EQ='0')) THEN
						next_state <= xy_moving;
						
					-- current_x != desired_x and x_drive is enabled -> x_moving	
					ELSIF(x_drive_en ='1' and X_EQ='0') THEN
						next_state <= x_moving;
						
					-- current_y != desired_y and y_drive is enabled -> y_moving
					ELSIF(y_drive_en ='1' and Y_EQ='0') THEN
						next_state <= y_moving
					
					-- go into idle (retracted arm)
					ELSE
						next_state <= idle;
						
					END IF;
				
				-- go into idle (extended arm)
				ELSE
					next_state <= idle;
					
				END IF;
				
---------------------------ALL XY_MOVING STATE TRANSITIONS -----------------------------------------------------
			 
         WHEN xy_moving =>		
					
					-- If we reach target position -> Idle
					IF((X_EQ='1') and (Y_EQ='1')) THEN
						next_state <= idle;
					
					-- If we release BOTH drive btns -> Idle
					ELSIF((x_drive_en = '0') and (y_drive_en ='0')) THEN
						next_state <= idle;
					
					-- If we release the X-drive -> y_moving
					ELSIF(x_drive_en = '0') THEN
						next_state <= y_moving;
						
					-- If X reaches its target and btns are held -> y_moving
					ELSIF((X_EQ='1') and (y_drive_en ='1' and Y_EQ='0') THEN
						next_state <= y_moving;	
						
					-- If we release the Y-drive -> x_moving
					ELSIF(y_drive_en = '0') THEN
						next_state <= x_moving;
					
					-- If Y reaches its target and btns are held -> x_moving
					ELSIF((x_drive_en ='1' and X_EQ='0') and (Y_EQ='0')) THEN
						next_state <= x_moving;

					-- Otherwise stay in xy-moving
					ELSE
						next_state <= xy_moving;
						
					END IF;
					
---------------------------ALL X_MOVING STATE TRANSITIONS -----------------------------------------------------

         WHEN x_moving =>
				
				-- If we reached target x position -> idle
				IF(X_EQ='1') THEN
					next_state <= idle;
					
				-- If we release the X-drive and the Y-drive is off -> idle	
				ELSIF(x_drive_en ='0' and y_drive_en ='0') THEN
					next_state <= idle;

				-- If we release the X-drive and we enable the Y-drive -> y_moving (this is unlikely as we change two-bits. This race condition is addressed in our Idle (x_moving -> idle -> y_moving) in faster clocks.)
				ELSIF(x_drive_en ='0' and (y_drive_en ='1' and Y_EQ='0')) THEN
					next_state <= y_moving;
					
				-- If we enabled Y-drive -> xy_moving
				ELSIF(x_drive_en ='1' and X_EQ='0') and (y_drive_en ='1' and Y_EQ='0') THEN
					next_state <= xy_moving;	
			
				-- continue -> x_moving
				ELSE
					next_state <= x_moving;
					
				END IF;
				
---------------------------ALL Y_MOVING STATE TRANSITIONS -----------------------------------------------------

         WHEN y_moving =>
				
				-- If we reached target y position -> idle
				IF(Y_EQ='1') THEN
					next_state <= idle;
					
				-- If we release the X-drive -> idle	
				ELSIF(x_drive_en ='0' and y_drive_en ='0') THEN
					next_state <= idle;

				-- If we release the Y-drive and we enable the X-drive -> X_moving (this is unlikely as we change two-bits. This race condition is addressed in our Idle (y_moving -> idle -> x_moving) in faster clocks.)
				ELSIF(y_drive_en ='0' and (x_drive_en ='1' and X_EQ='0')) THEN
					next_state <= x_moving;
				
				-- If we enabled x-drive -> xy_moving
				ELSIF(x_drive_en ='1' and X_EQ='0') and (y_drive_en ='1' and Y_EQ='0') THEN
					next_state <= xy_moving;	
			
				-- continue -> y_moving
				ELSE
					next_state <= y_moving;
					
				END IF;
				
---------------------------ALL ERROR/OTHER STATE TRANSITIONS -----------------------------------------------------

			WHEN others =>
			
				-- If we release BOTH drive btns -> idle
				IF(x_drive_en ='0' and y_drive_en ='0') THEN
					next_state <= idle;
					
				-- if btn(s) are held -> error	
				ELSE
					next_state <= error;
					
				END IF;
				 
 		END CASE;

 END PROCESS;

-- DECODER SECTION PROCESS (Moore Form) CHANGE TO MEALY -- 

Decoder_Section: PROCESS (X_EQ, X_GT, X_LT, Y_EQ, Y_GT, Y_KT, current_state) 

BEGIN
     CASE current_state IS
         WHEN idle =>		
				extender_en <= '1';
				x_move_en   <= '0';
				y_move_en   <= '0';
				x_clk_en    <= '0';
				y_clk_en    <= '0';
				error_led   <= '0';
			
         WHEN xy_moving =>		
				extender_en <= '0';
				
				-- We have to define behaviour for each outcome or else we get latches
				IF(X_GT='1') THEN
					x_move_en <= '0';
				ELSIF(X_LT='1') THEN
					x_move_en <= '1';
				ELSE
					x_move_en <= '-'; -- this value is arbitrary, but must be set	
				END IF;
				
				-- We have to define behaviour for each outcome or else we get latches
				IF(Y_GT='1') THEN
					y_move_en   <= '0';
				ELSIF(Y_LT='1') THEN
					y_move_en <= '1';
				ELSE
					y_move_en <= '-'; -- this value is arbitrary, but must be set	
				END IF;
				
				x_clk_en    <= '1'; -- Counter is enabled X
				y_clk_en    <= '1'; -- Counter is enabled Y
				error_led   <= '0';
		
			WHEN x_moving =>
				extender_en <= '0';

				-- We have to define behaviour for each outcome or else we get latches
				IF(X_GT='1') THEN
					x_move_en <= '0';
				ELSIF(X_LT='1') THEN
					x_move_en <= '1';
				ELSE
					x_move_en <= '-'; -- this value is arbitrary, but must be set	
				END IF;
				
				y_move_en   <= '0';
				x_clk_en    <= '1'; -- Counter is enabled X
				y_clk_en    <= '0';
				error_led   <= '0';
			
			WHEN y_moving =>
				extender_en <= '0';
				x_move_en   <= '0';

				-- We have to define behaviour for each outcome or else we get latches
				IF(Y_GT='1') THEN
					y_move_en <= '0';
				ELSIF(Y_LT='1') THEN
					y_move_en <= '1';
				ELSE
					y_move_en <= '-'; -- this value is arbitrary, but must be set	
				END IF;
				
				x_clk_en    <= '0';
				y_clk_en    <= '1'; -- Counter is enabled Y
				error_led   <= '0';
				
			-- when in Error state
         WHEN others =>		
				extender_en <= '0';
				x_move_en   <= '0';
				y_move_en   <= '0';
				x_clk_en    <= '0';
				y_clk_en    <= '0';
				error_led   <= '1'; -- Error LED is on
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
