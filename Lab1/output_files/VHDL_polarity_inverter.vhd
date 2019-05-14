LIBRARY ieee; 
USE ieee.std_logic_1164. all; 
LIBRARY work;

ENTITY VHDL_polarity_inverter IS 
	PORT
	(
		POLARITY, INPUT_1, INPUT_2, INPUT_3, INPUT_4: IN BIT; 
		OUT_1, OUT_2, OUT_3, OUT_4: OUT BIT 
	); 
END VHDL_polarity_inverter; 
ARCHITECTURE polar_gates OF VHDL_polarity_inverter IS 

BEGIN

OUT_1 <= POLARITY XOR INPUT_1;
OUT_2 <= POLARITY XOR INPUT_2;
OUT_3 <= POLARITY XOR INPUT_3;
OUT_4 <= POLARITY XOR INPUT_4;

END polar_gates; 
