-- Testbench for servomoteur.vhd
-- File: tb_servomoteur.vhd
-- Location: simu/servomoteur/
-- This testbench instantiates the servomoteur DUT and applies basic stimulus.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_servomoteur is
end entity tb_servomoteur;

architecture sim of tb_servomoteur is

    -- DUT generics (adjust as needed)
    constant CLK_PERIOD : time := 20 ns; -- 50 MHz

    -- DUT ports
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    signal angle    : integer;
    signal pwm_out  : std_logic;

begin

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Reset process
    rst_process : process
    begin
        rst_n <= '0';
        wait for 100 ns;
        rst_n <= '1';
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Wait for reset deassertion
        wait until rst_n = '1';
        wait for 50 ns;

        -- Sweep angle from 0 to 180 (assuming 8-bit input, 0-180 valid)
        for i in 0 to 180 loop
            angle <= i;
            wait for 1 ms;
        end loop;

        -- Hold at max angle
        wait for 5 ms;

        -- Sweep back to 0
        for i in 180 downto 0 loop
            angle <= i;
            wait for 1 ms;
        end loop;

        wait for 5 ms;
        -- End simulation
        wait;
    end process;

    -- DUT instantiation
    uut: entity work.servomoteur
        port map (
            clk     => clk,
            rst_n   => rst_n,
            position => angle,
            commande => pwm_out
        );

        waveform_proc : process
begin
    -- Wait for simulation to start
    wait for 0 ns;
    -- Add all signals in this testbench to the waveform window (ModelSim/Questa)
    -- This is a ModelSim/Questa-specific command; ignored by synthesis
    -- Uncomment the next line if you want to see all signals in the GUI
    -- report "Add signals to waveform window" severity note;
    wait;
end process;
end architecture sim;
-- Optionally, waveform dump for ModelSim/Questa (uncomment if needed)
-- This block helps with viewing signals in simulation tools.
-- Uncomment if you want automatic VCD/GUI waveform dump.

-- process
-- begin
--     -- Wait for simulation to start
--     wait for 0 ns;
--     -- For ModelSim: save all signals
--     assert false report "Add signals to waveform window" severity note;
--     wait;
-- end process;
-- Optional: Add signals to the waveform window automatically in ModelSim/Questa
