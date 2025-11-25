library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decimal_Digits is
    Port ( input_num : in  INTEGER range 0 to 9999;  -- 4-digit number input
           digit1    : out INTEGER range 0 to 9;    -- First digit
           digit2    : out INTEGER range 0 to 9;    -- Second digit
           digit3    : out INTEGER range 0 to 9;    -- Third digit
           digit4    : out INTEGER range 0 to 9     -- Fourth digit
           );
end Decimal_Digits;

architecture Behavioral of Decimal_Digits is
begin
    process(input_num)
    begin
        -- Extracting each digit using modulo and division by 10
        digit1 <= input_num / 1000;          -- Thousands place
        digit2 <= (input_num / 100) mod 10;  -- Hundreds place
        digit3 <= (input_num / 10) mod 10;   -- Tens place
        digit4 <= input_num mod 10;          -- Ones place
    end process;
end Behavioral;
