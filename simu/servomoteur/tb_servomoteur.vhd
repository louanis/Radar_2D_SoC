library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_servomoteur is
end tb_servomoteur;

architecture sim of tb_servomoteur is

    --------------------------------------------------------------------
    -- DUT signals
    --------------------------------------------------------------------
    signal clk_tb        : std_logic := '0';
    signal rst_n_tb      : std_logic := '0';
    signal position_tb   : integer   := 0;
    signal commande_tb   : std_logic;

    --------------------------------------------------------------------
    -- Reference command
    --------------------------------------------------------------------
    signal commande_ref_tb : std_logic := '0';

    --------------------------------------------------------------------
    -- Enumeration type used for match checking
    --------------------------------------------------------------------
    type is_ok is (OK, NOT_OK);

    -- Match result signal
    signal OK_state_tb : is_ok := NOT_OK;

    --------------------------------------------------------------------
    -- Clock period 20 ns (50 MHz)
    --------------------------------------------------------------------
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
    -- Reference PWM Generator
    -- Produces the ideal servo pulse:
    --   0°  -> 0.5 ms
    -- 180°  -> 2.5 ms
    -- Period = 20 ms
    --------------------------------------------------------------------
    ref_gen : process
        variable pulse_us : integer;
    begin
        commande_ref_tb <= '0';

        -- Ideal high time in microseconds:
        pulse_us := integer(500 + position_tb * 2000 / 180);

        -- HIGH part of PWM
        commande_ref_tb <= '1';
        wait for pulse_us * 1 us;

        -- LOW part until 20 ms total
        commande_ref_tb <= '0';
        wait for (20 ms - pulse_us * 1 us);
    end process;


    --------------------------------------------------------------------
    -- Checker: compare DUT PWM to reference PWM
    --------------------------------------------------------------------
    check_proc : process(clk_tb)
    begin
        if rising_edge(clk_tb) then
            if commande_tb = commande_ref_tb then
                OK_state_tb <= OK;
            else
                OK_state_tb <= NOT_OK;
            end if;
        end if;
    end process;


    --------------------------------------------------------------------
    -- Test Stimulus
    --------------------------------------------------------------------
    stim_proc : process
    begin
        --------------------------------------------------------------------------------
        -- Reset
        --------------------------------------------------------------------------------
        rst_n_tb <= '0';
        wait for 200 ns;
        rst_n_tb <= '1';
        wait for 200 ns;

        --------------------------------------------------------------------------------
        -- Test 0°  => expected pulse ≈ 0.5 ms
        --------------------------------------------------------------------------------
        position_tb <= 0;
        wait for 40 ms;

        --------------------------------------------------------------------------------
        -- Test 90° => expected pulse ≈ 1.5 ms
        --------------------------------------------------------------------------------
        position_tb <= 90;
        wait for 40 ms;

        --------------------------------------------------------------------------------
        -- Test 180° => expected pulse ≈ 2.5 ms
        --------------------------------------------------------------------------------
        position_tb <= 180;
        wait for 40 ms;

        --------------------------------------------------------------------------------
        -- End simulation
        --------------------------------------------------------------------------------
        wait;
    end process;

end architecture sim;
