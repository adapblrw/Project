-- led.vhd
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity led is
   port (
      clk         : in std_logic;
      reset       : in std_logic;
      status_led   : out std_logic;
      led0         : out std_logic;
      led1         : out std_logic;
      led2         : out std_logic;
      led3         : out std_logic;
      led4         : out std_logic;
      led5         : out std_logic;
      led6         : out std_logic );
end led;



architecture Behavioral of led is
   signal   count    : unsigned (25 downto 0) := (b"00" & x"000000");
   signal   led_int  : unsigned (3 downto 0) := x"0";
begin

   process(clk)
   begin
      if rising_edge(clk) then
            -- unsigned overflow -> reset to zero
            count <= count + 1;
				if reset = '0' then -- leds off while reset, but counter continues running
					led_int <= "0000";
				else
					led_int <= count(25 downto 22);
				end if;
      end if;
   end process;

   status_led <= '1';
   led0 <= led_int(3);
   led1 <= led_int(3) and led_int(2);
   led2 <= led_int(2);
   led3 <= led_int(2) and led_int(1);
   led4 <= led_int(1);
   led5 <= led_int(1) and led_int(0);
   led6 <= led_int(0);

end Behavioral;
