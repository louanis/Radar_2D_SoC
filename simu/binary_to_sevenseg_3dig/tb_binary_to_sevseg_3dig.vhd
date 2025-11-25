-- File: tb_binary_to_sevseg_3dig.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_binary_to_sevseg_3dig is
end entity;

architecture sim of tb_binary_to_sevseg_3dig is

    constant N : natural := 10;

    -- DUT signals
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    signal bin_in   : std_logic_vector(N-1 downto 0) := (others => '0');
    signal seg_u    : std_logic_vector(6 downto 0);
    signal seg_t    : std_logic_vector(6 downto 0);
    signal seg_h    : std_logic_vector(6 downto 0);

    -- OK signal indicating correct output
    signal ok       : std_logic := '0';

    -- clock period
    constant CLK_PERIOD : time := 10 ns;

    -- Expected 7-segment active-low codes (a..g)
    function seg7(d : integer) return std_logic_vector is
        variable s : std_logic_vector(6 downto 0);
    begin
        case d is
            when 0 => s := "0000001";
            when 1 => s := "1001111";
            when 2 => s := "0010010";
            when 3 => s := "0000110";
            when 4 => s := "1001100";
            when 5 => s := "0100100";
            when 6 => s := "0100000";
            when 7 => s := "0001111";
            when 8 => s := "0000000";
            when 9 => s := "0000100";
            when others => s := (others => '1');
        end case;
        return s;
    end;

begin

    -----------------------------------------------------------------------
    -- Clock generation
    -----------------------------------------------------------------------
    clk <= not clk after CLK_PERIOD/2;

    -----------------------------------------------------------------------
    -- DUT INSTANTIATION
    -----------------------------------------------------------------------
    dut : entity work.binary_to_sevseg_3dig
        generic map (N => N)
        port map (
            clk      => clk,
            rst_n    => rst_n,
            bin_in   => bin_in,
            seg_units    => seg_u,
            seg_tens     => seg_t,
            seg_hundreds => seg_h
        );

    -----------------------------------------------------------------------
    -- STIMULUS
    -----------------------------------------------------------------------
    stim : process
        procedure run_test(value : integer) is
            variable h, t, u : integer;
            variable ok_local : std_logic;
        begin
            ok <= '0';

            -- Apply input
            bin_in <= std_logic_vector(to_unsigned(value, N));

            -- Wait for one clock after input change
            wait until rising_edge(clk);

            -- Converter runs N cycles → wait N+1 clocks
            for i in 0 to N loop
                wait until rising_edge(clk);
            end loop;

            -- Compute expected digits
            if value > 999 then
                h := 9; t := 9; u := 9;
            else
                h := value / 100;
                t := (value / 10) mod 10;
                u := value mod 10;
            end if;

            -- Check outputs
            ok_local := '1';

            if seg_h /= seg7(h) then
                report "FAIL hundreds for " & integer'image(value)
                    severity error;
                ok_local := '0';
            end if;

            if seg_t /= seg7(t) then
                report "FAIL tens for " & integer'image(value)
                    severity error;
                ok_local := '0';
            end if;

            if seg_u /= seg7(u) then
                report "FAIL units for " & integer'image(value)
                    severity error;
                ok_local := '0';
            end if;

            -- Set ok flag
            ok <= ok_local;

            if ok_local = '1' then
                report "PASS value=" & integer'image(value);
            end if;

            -- Hold OK for one clock
            wait until rising_edge(clk);
            ok <= '0';
        end procedure;

    begin
        -------------------------------------------------------------------
        -- RESET
        -------------------------------------------------------------------
        rst_n <= '0';
        wait for 40 ns;
        rst_n <= '1';
        wait until rising_edge(clk);

        -------------------------------------------------------------------
        -- TEST VECTORS
        -------------------------------------------------------------------
        run_test(0);
        run_test(5);
        run_test(9);
        run_test(12);
        run_test(47);
        run_test(99);
        run_test(100);
        run_test(123);
        run_test(256);
        run_test(512);
        run_test(999);
        run_test(1000); -- check saturation
        run_test(1023); -- max for N=10 → saturation expected

        report "ALL TESTS COMPLETED";
        wait;
    end process;

end architecture;
