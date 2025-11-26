-- File: individual_component_test.vhd
-- Top-level container entity adapted for DE10-Lite naming (CLOCK_50, KEY, SW, LED, UART_TXD, UART_RXD)
-- Added GPIO port (bidirectional). Adjust GPIO_N and directions as needed.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity individual_component_test is
    port (
        CLOCK_50  : in  std_logic;                             -- board clock (50 MHz)

        -- 40-Pin Headers
        GPIO              : inout std_logic_vector(35 downto 0);

        -- Seven Segment Displays
        HEX0              : out std_logic_vector(7 downto 0);
        HEX1              : out std_logic_vector(7 downto 0);
        HEX2              : out std_logic_vector(7 downto 0);
        HEX3              : out std_logic_vector(7 downto 0);
        HEX4              : out std_logic_vector(7 downto 0);
        HEX5              : out std_logic_vector(7 downto 0);

        -- Pushbuttons
        KEY               : in  std_logic_vector(1 downto 0);

        -- LEDs
        LEDR              : out std_logic_vector(9 downto 0);

        -- Slider Switches
        SW                : in  std_logic_vector(9 downto 0)
    );
end entity;

architecture Behavioral of individual_component_test is
    signal dist : std_logic_vector(9 downto 0);
 
begin

-- Instantiate TELEMETRE_US component
TELEMETRE_US_inst : entity work.TELEMETRE_US
    port map (
        clk      => CLOCK_50,
        rst_n    => KEY(0),
        echo     => GPIO(3),
        trig     => GPIO(1),
        dist_cm  => dist,
		read_n   => '0',
		readdata => open,
        chipselect => '1'
    );

-- Display distance on HEX displays

SEVSEG_inst : entity work.binary_to_sevseg_3dig
    port map (
        clk => CLOCK_50,
        rst_n    => KEY(0),  -- active low asynchronous reset
        bin_in  => dist,
        seg_units  =>  HEX0(6 downto 0), -- a..g active LOW
        seg_tens    =>  HEX1(6 downto 0),
        seg_hundreds =>  HEX2(6 downto 0)
    );

    LEDR(9 downto 0) <= dist;

 
end architecture;