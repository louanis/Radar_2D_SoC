-- filepath: c:\Users\yanis\Cours\3A\S6\VHDL S6\Projet\Monocycle_ARM7TDMI\ALU.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity telemetre_us is
    port(
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        echo     : in  std_logic;
        Read_n   : in  std_logic;
        trig     : out std_logic;
        dist_cm  : out std_logic_vector(9 downto 0);
        readdata : out std_logic_vector(31 downto 0)
    );
end telemetre_us;

architecture rtl of telemetre_us is
    type state is (TRIGGER, WAIT_ECHO, WAIT_END_ECHO, CALC_DIST, WAIT_TRIGGER);
    signal curr_state : state;

    signal cmpt : integer := 0;
    constant cmpt_10us : integer := 500;


    signal cmpt_global : integer := 0;
    constant compt_60ms : integer := 3000000;


    signal cmpt_echo : integer := 0;


    signal result : signed(31 downto 0);
begin

    process(clk, rst_n)
        variable dist : integer := 0;
    begin

        if Read_n = '0' then
            readdata <= std_logic_vector(to_unsigned(cmpt_echo,32));
        else
            readdata <= (others => '0');
        end if;


        if rst_n = '0' then
            result <= (others => '0');
        elsif rising_edge(clk) then
            case curr_state is
                when TRIGGER =>
                    if cmpt = 0 then
                        trig <= '1';
                        cmpt <= cmpt + 1;
                    elsif cmpt < cmpt_10us then
                        cmpt <= cmpt + 1;
                    else
                        trig <= '0';
                        cmpt <= 0;
                        curr_state <= WAIT_ECHO;
                    end if;
                when WAIT_ECHO =>
                    if echo = '1' then
                        curr_state <= WAIT_END_ECHO;
                        cmpt_echo <= 0;
                    end if;
                when WAIT_END_ECHO =>
                    if echo = '1' then
                        cmpt_echo <= cmpt_echo + 1;
                    else
                        curr_state <= CALC_DIST;
                    end if;
                when CALC_DIST =>

                    dist := cmpt_echo * 7;
                    dist := dist / 20000;
                    dist_cm <= std_logic_vector(to_unsigned(dist, 10));
                    curr_state <= WAIT_TRIGGER;
                when WAIT_TRIGGER =>
                    -- There is a force reset outside of the case meaning that i can stay in that state as long as i want because i will be forced to go to TRIGGER after 60ms
                    null;
                when others =>
                    curr_state <= WAIT_TRIGGER;
            end case;

            if cmpt_global < compt_60ms then
                cmpt_global <= cmpt_global + 1;
            else
                cmpt_global <= 0;
                curr_state <= TRIGGER;
            end if;

        end if;
    end process;
end rtl;