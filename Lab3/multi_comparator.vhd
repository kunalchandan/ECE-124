library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multi_comparator is
	
	-- Takes in four single-bit comparators and outputs the final value of A>B, A=B or A<B
	PORT
	(		
		sw   		: in  std_logic_vector(7 downto 0); -- The switch inputs
		A_GT_B	: out std_logic;
		A_EQ_B	: out std_logic;	
		A_LT_B	: out std_logic	
	);
end multi_comparator;


Architecture multi_bit_operator of multi_comparator is

	-- Component Declaration of the Single Comparator (Compx1)
	component single_comparator is PORT (		
			bin_A		: in std_logic;
			bin_B		: in std_logic;
			A_GT_B	: out std_logic;	-- A AND B'
			A_EQ_B	: out std_logic;	-- NOT XOR
			A_LT_B	: out std_logic	-- A' AND B
	);
	end component;
	-- Signals
	signal NUM_A	: std_logic_vector(3 downto 0);
	signal NUM_B	: std_logic_vector(3 downto 0);
	
	signal A3_GT_B3: std_logic;
	signal A3_EQ_B3: std_logic;
	signal A3_LT_B3: std_logic;
	
	signal A2_GT_B2: std_logic;
	signal A2_EQ_B2: std_logic;
	signal A2_LT_B2: std_logic;
	
	signal A1_GT_B1: std_logic;
	signal A1_EQ_B1: std_logic;
	signal A1_LT_B1: std_logic;
	
	signal A0_GT_B0: std_logic;
	signal A0_EQ_B0: std_logic;
	signal A0_LT_B0: std_logic;
	
-- Here the circuit begins

begin
	-- Convert inputs to signals
	NUM_A <= sw(7 downto 4);
	NUM_B <= sw(3 downto 0);
	
	-- 	  single_comparator(in1,      in2,      A>B,      A=B,      A<B) (x4)
	SC3	: single_comparator port map (NUM_A(3), NUM_B(3), A3_GT_B3, A3_EQ_B3, A3_LT_B3);
	SC2	: single_comparator port map (NUM_A(2), NUM_B(2), A2_GT_B2, A2_EQ_B2, A2_LT_B2);
	SC1	: single_comparator port map (NUM_A(1), NUM_B(1), A1_GT_B1, A1_EQ_B1, A1_LT_B1);
	SC0	: single_comparator port map (NUM_A(0), NUM_B(0), A0_GT_B0, A0_EQ_B0, A0_LT_B0);

	-- Using Bigendian logic, compare largest digit first then require equality and compare next largest digit ...
	A_GT_B <= A3_GT_B3 OR 
				(A3_EQ_B3 AND A2_GT_B2) OR 
				(A3_EQ_B3 AND A2_EQ_B2 AND A1_GT_B1) OR
				(A3_EQ_B3 AND A2_EQ_B2 AND A1_EQ_B1 AND A0_GT_B0);
				
	A_LT_B <= A3_LT_B3 OR 
				(A3_EQ_B3 AND A2_LT_B2) OR 
				(A3_EQ_B3 AND A2_EQ_B2 AND A1_LT_B1) OR
				(A3_EQ_B3 AND A2_EQ_B2 AND A1_EQ_B1 AND A0_LT_B0);
				
	-- EQ is equal IFF all equal operators are true.
	A_EQ_B <= A3_EQ_B3 AND A2_EQ_B2 AND A1_EQ_B1 AND A0_EQ_B0;
	
	
end Architecture multi_bit_operator;

	