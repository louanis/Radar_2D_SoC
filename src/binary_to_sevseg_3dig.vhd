library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity binary_to_sevseg_3dig is
    generic (
        N : natural := 10  -- width of binary input
    );
    port (
        clk      : in  std_logic;
        rst_n    : in  std_logic;  -- active low asynchronous reset
        bin_in   : in  std_logic_vector(N-1 downto 0);  -- 10-bit binary input (0-999)
        seg_units    : out std_logic_vector(6 downto 0); -- a..g active LOW
        seg_tens     : out std_logic_vector(6 downto 0);
        seg_hundreds : out std_logic_vector(6 downto 0)
    );
end binary_to_sevseg_3dig;

architecture Behavioral of binary_to_sevseg_3dig is

    -- Declare the SEVEN_SEG component
    component SEVEN_SEG is
        port ( 
            Data   : in  std_logic_vector(3 downto 0);  -- Expected within 0..9
            Pol    : in  std_logic;                      -- '0' if active LOW
            Segout : out std_logic_vector(6 downto 0)    -- Segments A, B, C, D, E, F, G
        );
    end component;

    -- Declare the BCD counter component (CompCodageBCD)
    component Decimal_Digits is
    Port ( input_num : in  INTEGER range 0 to 9999;  -- 4-digit number input
           digit1    : out INTEGER range 0 to 9;    -- First digit
           digit2    : out INTEGER range 0 to 9;    -- Second digit
           digit3    : out INTEGER range 0 to 9;    -- Third digit
           digit4    : out INTEGER range 0 to 9     -- Fourth digit
           );
    end component;

    -- Signals to hold the BCD digits for units, tens, and hundreds
    signal bin_units   : integer;   -- Units (0-9)
    signal bin_tens    : integer;   -- Tens (0-9)
    signal bin_hundreds: integer;   -- Hundreds (0-9)
    signal reset      : std_logic;  -- Reset signal for BCD counter

begin

    -- Instantiate the CompCodageBCD component for BCD counting
    U1 : Decimal_Digits
        port map (
            input_num => to_integer(unsigned(bin_in)),
            digit1    => open,  -- First digit
            digit2    => bin_hundreds,    -- Second digit
            digit3    => bin_tens,    -- Third digit
            digit4    => bin_units     -- Fourth digit
        );

    -- Instantiate the SEVEN_SEG component for each digit (units, tens, hundreds)
    U2 : SEVEN_SEG
        port map (
            Data   => std_logic_vector(to_unsigned(bin_units,4)),
            Pol    => '0',          -- Active LOW
            Segout => seg_units
        );

    U3 : SEVEN_SEG
        port map (
            Data   => std_logic_vector(to_unsigned(bin_tens,4)),
            Pol    => '0',          -- Active LOW
            Segout => seg_tens
        );

    U4 : SEVEN_SEG
        port map (
            Data   => std_logic_vector(to_unsigned(bin_hundreds,4)),
            Pol    => '0',          -- Active LOW
            Segout => seg_hundreds
        );

end Behavioral;
