--*****************************************************************************
--*  Copyright (C) 2016 by Trevor Smouter
--*
--*  All rights reserved.
--*
--*  Redistribution and use in source and binary forms, with or without 
--*  modification, are permitted provided that the following conditions 
--*  are met:
--*  
--*  1. Redistributions of source code must retain the above copyright 
--*     notice, this list of conditions and the following disclaimer.
--*  2. Redistributions in binary form must reproduce the above copyright
--*     notice, this list of conditions and the following disclaimer in the 
--*     documentation and/or other materials provided with the distribution.
--*  3. Neither the name of the author nor the names of its contributors may 
--*     be used to endorse or promote products derived from this software 
--*     without specific prior written permission.
--*
--*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
--*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
--*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
--*  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
--*  THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
--*  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
--*  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
--*  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
--*  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
--*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
--*  THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
--*  SUCH DAMAGE.
--*
--*****************************************************************************
--*  History:
--*
--*  04.02.2016    First Version
--*****************************************************************************


-- ****************************************************************************
-- *  Library                                                                 *
-- ****************************************************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- ****************************************************************************
-- *  Entity                                                                  *
-- ****************************************************************************

entity segment7_mux is
   port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end entity segment7_mux;

-- *****************************************************************************
-- *  Architecture                                                             *
-- *****************************************************************************

architecture syn of segment7_mux is
	
	signal toggle 			: std_logic;
	signal DOUT_TEMP		: std_logic_vector(6 downto 0);
   
begin

   ----------------------------------------------
   -- Register File
   ----------------------------------------------

  
  	clk_proc:process(CLK)
  	variable COUNT			:unsigned(10 downto 0) := "00000000000";
  	begin 
		if (rising_edge(CLK)) then
  			COUNT := COUNT + 1;
		else 
			COUNT := COUNT;
  		end if;
 	toggle <= COUNT(10);
 	end process clk_proc;
	DIG1 <= NOT toggle;
	DIG2 <= toggle;
	
	DOUT_TEMP(0) <= (DIN2(0)) WHEN (toggle = '1')	ELSE (DIN1(0));
	DOUT_TEMP(1) <= (DIN2(1)) WHEN (toggle = '1')	ELSE (DIN1(1));
	DOUT_TEMP(2) <= (DIN2(2)) WHEN (toggle = '1')	ELSE (DIN1(2));
	DOUT_TEMP(3) <= (DIN2(3)) WHEN (toggle = '1')	ELSE (DIN1(3));
	DOUT_TEMP(4) <= (DIN2(4)) WHEN (toggle = '1')	ELSE (DIN1(4));
	DOUT_TEMP(5) <= (DIN2(5)) WHEN (toggle = '1')	ELSE (DIN1(5));
	DOUT_TEMP(6) <= (DIN2(6)) WHEN (toggle = '1')	ELSE (DIN1(6));
--	DOUT_TEMP(7) <= (DIN2(7)) WHEN (toggle = '1')	ELSE (DIN1(7));

	DOUT(0) <= '0' WHEN (DOUT_TEMP(0) = '0')	ELSE '1';
	DOUT(1) <= '0' WHEN (DOUT_TEMP(1) = '0')	ELSE 'Z'; --open drain
	DOUT(2) <= '0' WHEN (DOUT_TEMP(2) = '0')	ELSE '1'; 
	DOUT(3) <= '0' WHEN (DOUT_TEMP(3) = '0')	ELSE '1'; 
	DOUT(4) <= '0' WHEN (DOUT_TEMP(4) = '0')	ELSE '1'; 
	DOUT(5) <= '0' WHEN (DOUT_TEMP(5) = '0')	ELSE 'Z'; --open drain
	DOUT(6) <= '0' WHEN (DOUT_TEMP(6) = '0')	ELSE 'Z'; --open drain
--	DOUT(7) <= '0' WHEN (DOUT_TEMP(7) = '0')	ELSE '1'; 

	

	

end architecture syn;
