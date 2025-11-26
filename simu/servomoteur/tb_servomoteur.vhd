library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_servomoteur is
end tb_servomoteur;

architecture sim of tb_servomoteur is

    -- DUT signals
    signal clk_tb      : std_logic := '0';
    signal rst_n_tb    : std_logic := '0';
    signal position_tb : integer   := 0;
    signal commande_tb : std_logic;

    -- Clock period 20 ns (50 MHz)
    constant CLK_PERIOD : time := 20 ns;

begin

    --------------------------------------------------------------------
    -- Clock generator
    --------------------------------------------------------------------
    clk_gen : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    --------------------------------------------------------------------
    -- Instantiate DUT
    --------------------------------------------------------------------
    DUT : entity work.servomoteur
        port map(
            clk      => clk_tb,
            rst_n    => rst_n_tb,
            position => position_tb,
            commande => commande_tb
        );

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    stim_proc : process
    begin
        
        -- Hold reset low
        rst_n_tb <= '0';
        wait for 200 ns;
        rst_n_tb <= '1';
        wait for 200 ns;

        ------------------------------------------------------------
        -- Test 0°  => expected pulse ≈ 0.5 ms
        ------------------------------------------------------------
        position_tb <= 0;
        wait for 40 ms;   -- observe two PWM periods

        ------------------------------------------------------------
        -- Test 90° => expected pulse ≈ 1.5 ms
        ------------------------------------------------------------
        position_tb <= 90;
        wait for 40 ms;

        ------------------------------------------------------------
        -- Test 180° => expected pulse ≈ 2.5 ms
        ------------------------------------------------------------
        position_tb <= 180;
        wait for 40 ms;

        ------------------------------------------------------------
        -- End simulation
        ------------------------------------------------------------
        wait;
    end process;

end architecture;
