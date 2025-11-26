library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servomoteur is
    port(
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        position : in  integer;
        commande : out std_logic
    );
end servomoteur ;

architecture rtl of servomoteur is

signal up_dur : integer := 25000; -- 500us in 20ns
signal cmp    : integer := 0;

constant per    : integer := 1000000; --  20ms in 20ns
signal glob_cmp : integer := 0;

type state is (START_PULSE, PULSE, DOWN);
signal curr_state : state := PULSE;

begin

    

    process(clk, rst_n) is
        
    begin
        if rst_n = '0' then
            cmp <= 0;
            glob_cmp <= 0;
            curr_state <= START_PULSE;
        elsif rising_edge(clk) then
            glob_cmp <= glob_cmp + 1;
            case curr_state is
                when START_PULSE =>
                    up_dur <= 500 + position*556;
                    glob_cmp <= 0;
                    cmp <= 0;
                    commande <= '1';
                    curr_state <= PULSE;
                when PULSE =>
                    if cmp < up_dur then
                        cmp <= cmp + 1;
                    else 
                        curr_state <= DOWN;
                        commande <= '0';
                    end if;
                when DOWN => 
                    if glob_cmp = per then
                        curr_state <= START_PULSE;
                    end if;
                when others =>
                    if glob_cmp = per then
                        curr_state <= START_PULSE;
                    end if;
            end case;
        end if;
    end process;
end rtl;