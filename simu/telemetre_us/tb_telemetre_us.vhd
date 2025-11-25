-- Testbench for TELEMETRE_US
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_telemetre_us is
end tb_telemetre_us;

architecture tb of tb_telemetre_us is

    -- DUT ports
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    signal echo     : std_logic := '0';
    signal trig     : std_logic;
    signal dist_cm  : std_logic_vector(9 downto 0);

    -- Clock period for 50 MHz = 20 ns
    constant T_CLK : time := 20 ns;

    -- Simulation parameters
    -- Distance simulée : 100 cm par exemple
    constant SIM_DIST_CM : integer := 17;

    -- Temps de propagation : 58 us par cm (aller+retour)
    -- Valeur classique pour HC-SR04
    constant ECHO_PW : time := SIM_DIST_CM * 58 us;

begin

    ------------------------------------------------------------
    -- Clock generation 50 MHz
    ------------------------------------------------------------
    clk <= not clk after T_CLK/2;

    ------------------------------------------------------------
    -- DUT instantiation
    ------------------------------------------------------------
    uut: entity work.TELEMETRE_US
        port map(
            clk     => clk,
            rst_n   => rst_n,
            echo    => echo,
            trig    => trig,
            dist_cm => dist_cm
        );

    ------------------------------------------------------------
    -- Stimulus process
    ------------------------------------------------------------
    stim_proc : process
    begin
        --------------------------------------------------------
        -- Reset
        --------------------------------------------------------
        rst_n <= '0';
        wait for 200 ns;
        rst_n <= '1';
        wait for 200 ns;

        --------------------------------------------------------
        -- Simulation boucle :
        -- On détecte un front montant de trig,
        -- on laisse 1 us, puis on active echo pendant ECHO_PW.
        --------------------------------------------------------
        while now < 300 ms loop    -- durée de simulation
            ----------------------------------------------------
            -- attendre le front montant de trig du DUT
            ----------------------------------------------------
            wait until rising_edge(trig);

            -- Le vrai télémetre impose au moins 1 us avant echo
            wait for 1 us;

            -- echo = 1 pour une durée proportionnelle à la distance
            echo <= '1';
            wait for ECHO_PW;
            echo <= '0';

            -- Le télémetre réel impose 60 ms entre mesures
            wait for 60 ms;
        end loop;

        wait;
    end process;

end tb;
