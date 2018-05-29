library ieee;
use ieee.std_logic_1164.all;

entity debug_processor_toplevel is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    -- inputs from rotation encoder hardware
    rot_a   : in  std_logic;
    rot_b   : in  std_logic;
    rot_btn : in  std_logic;
    -- outputs to LEDs
    leds    : out std_logic_vector( 7 downto 0)
    );
end debug_processor_toplevel;

architecture structural of debug_processor_toplevel is

  -- signal declarations
  signal interrupts : std_logic_vector(7 downto 0);
  signal addressBus : std_logic_vector(11 downto 0);
  signal dataBus    : std_logic_vector(15 downto 0);
  signal wren       : std_logic;
  signal oe         : std_logic;

  signal selDebug   : std_logic;
  signal oeDebug    : std_logic;
  signal wrenDebug  : std_logic;

  signal selMEM   : std_logic;
  signal oeMEM    : std_logic;
  signal wrenMEM  : std_logic;

begin  -- structural


  -- component instantiations

  -- processor
  UKM901_1: entity UKM901(structure)
    port map (
      clk        => clk,
      res        => reset,
      interrupts => interrupts,
      databus    => dataBus,
      wren       => wren,
      oe         => oe,
      addressbus => addressBus
    );

  -- program/data memory
  memory_1: entity memory(Behavioral)
    port map (
      clk    => clk,
      addr   => addressBus(10 downto 0),
      dataIO => dataBus,
      wren   => wrenMEM,
      oe     => oeMEM
    );

  -- debug module
  debug_module_inst: entity debug_module(rtl)
    port map (
      -- clock and reset
      clk     => clk,
      rst     => reset,
      -- processor bus
      dataIO  => dataBus,
      oe      => oeDebug,
      wren    => wrenDebug,
      -- inputs from rotation encoder hardware
      rot_a   => rot_a,
      rot_b   => rot_b,
      rot_btn => rot_btn,
      -- outputs to LEDs
      leds    => leds
    );

  -- address decoding
  selMEM   <= '1' when addressBus(11) = '0'             else '0';
  selDebug <= '1' when addressBus(11 downto 0) = x"fff" else '0';

  -- generate component specific enable signals
  wrenMEM   <= selMEM and wren;
  oeMEM     <= selMEM and oe;
  wrenDebug <= selDebug and wren;
  oeDebug   <= selDebug and oe;

  -- no interrupts needed for this implementation
  interrupts <= (others => '0');

end structural;

