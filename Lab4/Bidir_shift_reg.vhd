library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
Entity Bidir_shift_reg is port
(
    CLK          : in  std_logic := '0';
	 RESET_n      : in  std_logic := '0';
	 CLK_EN       : in  std_logic := '0'; 
	 LEFTO_RIGHT1 : in  std_logic := '0';
	 REG_BITS     : out std_logic_vector(7 downto 0)
); 
end Entity; 

ARCHITECTURE one OF Bidir_shift_reg IS 
    signal sreg : std_logic_vector(7 downto 0); 

BEGIN 

process (CLK, RESET_n) is 
begin 
    if (RESET_n = '0') then 
	     sreg <= "00000000"; 
    
	 elsif (rising_edge(CLK) AND (CLK_EN = '1')) then 
	     
		  if (LEFTO_RIGHT1 = '1') then -- TRUE for RIGHT shift 
		      -- Removes the rightmost bit, and appends a '1' to the left
				
		      sreg (7 downto 0) <= '1' & sreg(7 downto 1); -- right-shift of bits 
		  
		  elsif (LEFTO_RIGHT1 = '0') then 
		      -- Removes the leftmost bit, and appends a '0' to the right
		      sreg (7 downto 0) <= sreg(6 downto 0) & '0'; -- left-shift of bits 
	
	  end if; 
	
	end if;

end process; 
REG_BITS <= sreg; 

END one;