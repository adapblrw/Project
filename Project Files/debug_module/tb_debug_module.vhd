library ieee;
use ieee.std_logic_1164.all;


entity tb_debug_module is
end entity tb_debug_module;


architecture beh of tb_debug_module is

  -- component declarations
  component debug_module is
    port (
      -- clock and reset
      clk     : in    std_logic;
      rst     : in    std_logic; -- asynchronous, active high
      -- processor bus
      dataIO  : inout std_logic_vector(15 downto 0);
      oe      : in    std_logic;
      wren    : in    std_logic;
      -- inputs from rotation encoder hardware
      rot_a   : in    std_logic;
      rot_b   : in    std_logic;
      rot_btn : in    std_logic;
      -- outputs to LEDs
      leds    : out   std_logic_vector( 7 downto 0)
    );
  end component;

  -- signal definitions
  signal clk      : std_logic := '0';
  signal rst      : std_logic := '1';

  signal dataIO   : std_logic_vector(15 downto 0);
  signal oe       : std_logic;
  signal wren     : std_logic;

  signal rot_a    : std_logic;
  signal rot_b    : std_logic;
  signal rot_btn  : std_logic;

  signal leds     : std_logic_vector( 7 downto 0);

begin

  clk_gen: process (clk)
  begin
    clk <= not(clk) after 10 ns;
  end process clk_gen;

  sequential_rot: process
  begin
    rot_a   <= '0';
    rot_b   <= '0';
    rot_btn <= '0';
    wait for 1000 ns;
    -- pushes the button with some bouncing
    rot_btn <= '1';
    wait for 20 ns;
    rot_btn <= '0';
    wait for 20 ns;
    rot_btn <= '1';
    wait for 200 ns;
    rot_btn <= '0';
    wait for 1000 ns;
    -- rotates left
    rot_a   <= '1';
    wait for 400 ns;
    rot_b   <= '1';
    wait for 200 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_b   <= '0';
    wait for 1000 ns;
    -- rotates right
    rot_b   <= '1';
    wait for 400 ns;
    rot_a   <= '1';
    wait for 20 ns;
    rot_a   <= '0';
    wait for 80 ns;
    rot_a   <= '1';
    wait for 60 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 20 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 200 ns;
    rot_b   <= '0';
    wait for 80 ns;
    rot_a   <= '0';
    wait for 1000 ns;
    -- rotates right
    rot_b   <= '1';
    wait for 800 ns;
    rot_a   <= '1';
    wait for 300 ns;
    rot_b   <= '0';
    wait for 80 ns;
    rot_a   <= '0';
    wait for 1000 ns;
    -- rotates left
    rot_a   <= '1';
    wait for 20 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 20 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 200 ns;
    rot_b   <= '1';
    wait for 20 ns;
    rot_b   <= '0';
    wait for 80 ns;
    rot_b   <= '1';
    wait for 60 ns;
    rot_b   <= '0';
    wait for 20 ns;
    rot_b   <= '1';
    wait for 20 ns;
    rot_b   <= '0';
    wait for 20 ns;
    rot_b   <= '1';
    wait for 200 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 20 ns;
    rot_a   <= '0';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 20 ns;
    rot_a   <= '1';
    wait for 80 ns;
    rot_b   <= '0';
    wait for 20 ns;
    rot_b   <= '1';
    wait for 60 ns;
    rot_b   <= '0';
    wait for 80 ns;
    rot_b   <= '1';
    wait for 20 ns;
    rot_b   <= '0';
    wait for 20 ns;
    wait;
  end process sequential_rot;

  sequential_bus: process
  begin
    dataIO  <= (others => 'Z');
    oe      <= '0';
    wren    <= '0';
    wait for 500 ns;
    rst <= '0';
    wait for 20 ns;
    -- read from debug_module, should be 0x00AA
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    -- toggle led<3:0>, set led<7:4> to '0101'
    dataIO  <= x"0F_5A";
    wren    <= '1';
    wait for 20 ns;
    wren    <= '0';
    wait for 20 ns;
    dataIO  <= (others => 'Z');
    wait for 1000 ns;
    -- read from debug_module, should be rot_push = '1', led_out<7:0> = "50"
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    wait for 1000 ns;
    -- read from debug_module, check clearing of rot_*
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    wait for 1000 ns;
    -- read from debug_module, check clearing of rot_*
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    wait for 1000 ns;
    -- read from debug_module, check clearing of rot_*
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    wait for 1000 ns;
    -- read from debug_module, check clearing of rot_*
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    wait for 1000 ns;
    -- read from debug module to confirm decoding of rot_a/b 
    oe      <= '1';
    -- wait for the leds to toggle 9 times (4.5 periods) ...
    wait for 4500 ms;
    -- read from debug_module, led_out<7:0> should be "5F"
    oe      <= '1';
    wait for 20 ns;
    oe      <= '0';
    wait for 20 ns;
    -- wait for the leds to toggle 1 more time (0.5 periods) ...
    wait for 500 ms;
    dataIO  <= x"00_0F";
    wren    <= '1';
    wait for 20 ns;
    dataIO  <= (others => 'Z');
    wren    <= '0';
    wait for 20 ns;
    wait;
  end process sequential_bus;

  -- component instantiations
  debug_module_inst: debug_module
    port map (
      -- clock and reset
      clk     => clk,
      rst     => rst,
      -- processor bus
      dataIO  => dataIO,
      oe      => oe,
      wren    => wren,
      -- inputs from rotation encoder hardware
      rot_a   => rot_a,
      rot_b   => rot_b,
      rot_btn => rot_btn,
      -- outputs to LEDs
      leds    => leds
    );

end architecture;

