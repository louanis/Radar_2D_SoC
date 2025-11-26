library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DE10_Lite_Computer is
    Port (
        -- Clock pins
        CLOCK_50          : in  std_logic;
        CLOCK2_50         : in  std_logic;
        CLOCK_ADC_10      : in  std_logic;

        -- ARDUINO
        ARDUINO_IO        : inout std_logic_vector(15 downto 0);
        ARDUINO_RESET_N   : inout std_logic;

        -- SDRAM
        DRAM_ADDR         : out std_logic_vector(12 downto 0);
        DRAM_BA           : out std_logic_vector(1 downto 0);
        DRAM_CAS_N        : out std_logic;
        DRAM_CKE          : out std_logic;
        DRAM_CLK          : out std_logic;
        DRAM_CS_N         : out std_logic;
        DRAM_DQ           : inout std_logic_vector(15 downto 0);
        DRAM_LDQM         : out std_logic;
        DRAM_RAS_N        : out std_logic;
        DRAM_UDQM         : out std_logic;
        DRAM_WE_N         : out std_logic;

        -- Accelerometer
        G_SENSOR_CS_N     : out std_logic;
        G_SENSOR_INT      : in  std_logic_vector(2 downto 1);
        G_SENSOR_SCLK     : out std_logic;
        G_SENSOR_SDI      : inout std_logic;
        G_SENSOR_SDO      : inout std_logic;

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
        SW                : in  std_logic_vector(9 downto 0);

        -- VGA
        VGA_B             : out std_logic_vector(3 downto 0);
        VGA_G             : out std_logic_vector(3 downto 0);
        VGA_HS            : out std_logic;
        VGA_R             : out std_logic_vector(3 downto 0);
        VGA_VS            : out std_logic
    );
end entity;

architecture Behavioral of DE10_Lite_Computer is

    signal hex3_hex0 : std_logic_vector(31 downto 0);
    signal hex5_hex4 : std_logic_vector(15 downto 0);
	 signal sdram_dqm : std_logic_vector(1 downto 0);
	 

	 
	 
	 component Computer_System is
        port (
            arduino_gpio_export                : inout std_logic_vector(15 downto 0) := (others => 'X'); -- export
            arduino_reset_n_export             : out   std_logic;                                        -- export
            hex3_hex0_export                   : out   std_logic_vector(31 downto 0);                    -- export
            hex5_hex4_export                   : out   std_logic_vector(15 downto 0);                    -- export
            pushbuttons_export                 : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
            sdram_addr                         : out   std_logic_vector(12 downto 0);                    -- addr
            sdram_ba                           : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_cas_n                        : out   std_logic;                                        -- cas_n
            sdram_cke                          : out   std_logic;                                        -- cke
            sdram_cs_n                         : out   std_logic;                                        -- cs_n
            sdram_dq                           : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_dqm                          : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_ras_n                        : out   std_logic;                                        -- ras_n
            sdram_we_n                         : out   std_logic;                                        -- we_n
            sdram_clk_clk                      : out   std_logic;                                        -- clk
            slider_switches_export             : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
            system_pll_ref_clk_clk             : in    std_logic                     := 'X';             -- clk
            system_pll_ref_reset_reset         : in    std_logic                     := 'X';             -- reset
            vga_CLK                            : out   std_logic;                                        -- CLK
            vga_HS                             : out   std_logic;                                        -- HS
            vga_VS                             : out   std_logic;                                        -- VS
            vga_BLANK                          : out   std_logic;                                        -- BLANK
            vga_SYNC                           : out   std_logic;                                        -- SYNC
            vga_R                              : out   std_logic_vector(3 downto 0);                     -- R
            vga_G                              : out   std_logic_vector(3 downto 0);                     -- G
            vga_B                              : out   std_logic_vector(3 downto 0);                     -- B
            video_pll_ref_clk_clk              : in    std_logic                     := 'X';             -- clk
            video_pll_ref_reset_reset          : in    std_logic                     := 'X';             -- reset
            ip_telem_avalon_0_conduit_end_trig : out   std_logic;                                        -- trig
            ip_telem_avalon_0_conduit_end_dist : out   std_logic_vector(9 downto 0);                     -- dist
            ip_telem_avalon_0_conduit_end_echo : in    std_logic                     := 'X'              -- echo
        );
    end component Computer_System;
	 
	 

begin

    DRAM_UDQM <= sdram_dqm(1);   
	 DRAM_LDQM <= sdram_dqm(0);

    HEX0 <= not hex3_hex0(7 downto 0);
    HEX1 <= not hex3_hex0(15 downto 8);
    HEX2 <= not hex3_hex0(23 downto 16);
    HEX3 <= not hex3_hex0(31 downto 24);
    HEX4 <= not hex5_hex4(7 downto 0);
    HEX5 <= not hex5_hex4(15 downto 8);

  
		  
		  u0 : component Computer_System
        port map (
            arduino_gpio_export                => ARDUINO_IO,                --                  arduino_gpio.export
            arduino_reset_n_export             => ARDUINO_RESET_N,             --               arduino_reset_n.export
            hex3_hex0_export                   => hex3_hex0,                   --                     hex3_hex0.export
            hex5_hex4_export                   => hex5_hex4,                   --                     hex5_hex4.export
            pushbuttons_export                 => not KEY(1 downto 0),                 --                   pushbuttons.export
            sdram_addr                         => DRAM_ADDR,                         --                         sdram.addr
            sdram_ba                           => DRAM_BA,                           --                              .ba
            sdram_cas_n                        => DRAM_CAS_N,                        --                              .cas_n
            sdram_cke                          => DRAM_CKE,                          --                              .cke
            sdram_cs_n                         => DRAM_CS_N,                         --                              .cs_n
            sdram_dq                           => DRAM_DQ,                           --                              .dq
            sdram_dqm                          => sdram_dqm,                          --                              .dqm
            sdram_ras_n                        => DRAM_RAS_N,                        --                              .ras_n
            sdram_we_n                         => DRAM_WE_N,                         --                              .we_n
            sdram_clk_clk                      => DRAM_CLK,                      --                     sdram_clk.clk
            slider_switches_export             => SW,             --               slider_switches.export
            system_pll_ref_clk_clk             => CLOCK_50,             --            system_pll_ref_clk.clk
            system_pll_ref_reset_reset         =>  '0',         --          system_pll_ref_reset.reset
            vga_CLK                            => open,                            --                           vga.CLK
            vga_HS                             => vga_HS,                             --                              .HS
            vga_VS                             => vga_VS,                             --                              .VS
            vga_BLANK                          => open,                          --                              .BLANK
            vga_SYNC                           => open,                           --                              .SYNC
            vga_R                              => vga_R,                              --                              .R
            vga_G                              => vga_G,                              --                              .G
            vga_B                              => vga_B,                              --                              .B
            video_pll_ref_clk_clk              => CLOCK2_50,              --             video_pll_ref_clk.clk
            video_pll_ref_reset_reset          => '0',          --           video_pll_ref_reset.reset
            ip_telem_avalon_0_conduit_end_trig => GPIO(1), -- ip_telem_avalon_0_conduit_end.trig
            ip_telem_avalon_0_conduit_end_dist => LEDR, --                              .dist
            ip_telem_avalon_0_conduit_end_echo => GPIO(3)  --                              .echo
        );



end architecture;


  