-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ------------------------------
    Entity SEVEN_SEG is
-- ------------------------------
  port ( Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
         Pol    : in  std_logic;                    -- '0' if active LOW
         Segout : out std_logic_vector(6 downto 0));   -- Segments A, B, C, D, E, F, G
end entity SEVEN_SEG;

-- -----------------------------------------------
    Architecture COMB of SEVEN_SEG is
-- ------------------------------------------------

begin
	
	process(Data,Pol)
	begin
		
	if pol = '1' then
	
		if Data = "0000" then
			segout <= "1111110";
			
		elsif Data = "0001" then
			segout <= "0110000";
			
		elsif Data = "0010" then
			segout <= "1101101";
			
		elsif Data = "0011" then
			segout <= "1111001";
			
		elsif Data = "0100" then
			segout <= "0110011";
			
		elsif Data = "0101" then
			segout <= "1011011";
			
		elsif Data = "0110" then
			segout <= "1011111";
			
		elsif Data = "0111" then
			segout <= "1110000";
			
		elsif Data = "1000" then
			segout <= "1111111";
			
		elsif Data = "1001" then
			segout <= "1111011";
			
		elsif Data = "1010" then -- A
			segout <= "1110111"; -- A, B, C, E, F, G
			
		elsif Data = "1011" then -- B
			segout <= "0011111"; -- C, D, E, F, G
			
		elsif Data = "1100" then -- C
			segout <= "1001110"; -- A, D, E, F
			
		elsif Data = "1101" then -- D
			segout <= "0111101"; -- B, C, D, E, G
			
		elsif Data = "1110" then -- E
			segout <= "1001111"; -- A, D, E, F, G
			
		elsif Data = "1111" then -- F
			segout <= "1000111"; -- A, E, F, G
		else
			segout <= "0000000";
			
		end if;
		
		
	else
	
		if Data = "0000" then
			segout <= "1000000";
			
		elsif Data = "0001" then
			segout <= "1111001";
			
		elsif Data = "0010" then
			segout <= "0100100";
			
		elsif Data = "0011" then
			segout <= "0110000";
			
		elsif Data = "0100" then
			segout <= "0011001";
			
		elsif Data = "0101" then
			segout <= "0010010";
			
		elsif Data = "0110" then
			segout <= "0000010";
			
		elsif Data = "0111" then
			segout <= "1111000";
			
		elsif Data = "1000" then
			segout <= "0000000";
			
		elsif Data = "1001" then
			segout <= "0010000";
			
		elsif Data = "1010" then -- A
			segout <= "0001000"; -- A, B, C, E, F, G (active low)
			
		elsif Data = "1011" then -- B
			segout <= "0000011"; -- C, D, E, F, G (active low)
			
		elsif Data = "1100" then -- C
			segout <= "1000110"; -- A, D, E, F (active low)
			
		elsif Data = "1101" then -- D
			segout <= "0100001"; -- B, C, D, E, G (active low)
			
		elsif Data = "1110" then -- E
			segout <= "0000110"; -- A, D, E, F, G (active low)
			
		elsif Data = "1111" then -- F
			segout <= "0001110"; -- A, E, F, G (active low)
		else
			segout <= "1111111";
			
		end if;
			
	end if;
		
		
	end process;
			 

end architecture COMB;

