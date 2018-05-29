library ieee;
use ieee.std_logic_1164.all;

entity PS2Tester is
  
  port (
    PS2clk  : out std_logic;
    PS2data : out std_logic );

end PS2Tester;


architecture behavior of PS2Tester is

  procedure writePS2Data (
    signal   clk   : out std_logic;
    signal   data  : out std_logic;
    constant value : in  std_logic_vector(7 downto 0));

  -- purpose: function to write out serial data in PS2 format
  procedure writePS2Data (
    signal   clk   : out std_logic;
    signal   data  : out std_logic;
    constant value : in  std_logic_vector(7 downto 0)) is
    variable parity : std_logic := '1';
  begin  -- writePS2Data
    -- write start bit
    data <= '0';
    clk  <= '1';
    wait for 15 us;
    clk  <= '0';
    wait for 15 us;
    -- write data
    for i in 0 to 7 loop
      data <= value(i);
      clk  <= '1';
      parity := parity xor value(i);
      wait for 15 us;
      clk <= '0';
      wait for 15 us;
    end loop;  -- i
    -- write parity bit
    data <= parity;
    clk  <= '1';
    wait for 15 us;
    clk  <= '0';
    wait for 15 us;
    -- write stop bit
    data <= '1';
    clk  <= '1';
    wait for 15 us;
    clk  <= '0';
    wait for 15 us;
    clk  <= '1';
  end writePS2Data;

begin  -- behavior

  -- purpose: write out PS2 data
  -- type   : combinational
  -- inputs : 
  -- outputs: PS2data, PS2clk
  writeData: process
  begin  -- process writeData
    -- init clock and data to '1'
    PS2clk <= '1';
    PS2data <= '1';

    ---------------------------------------------------------------------------
    -- If different / more scancodes are required, change or add additional
    -- blocks to write PS2 data
    ---------------------------------------------------------------------------

    -- wait for other components to init
    wait for 25 ms;

    -- key "Keypad 3" press 
    writePS2Data(PS2clk, PS2data, X"7A");
    wait for 1 ms;
    -- key "Keypad 3" release
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"7A");


    -- wait before next "Keystroke"
    wait for 1 ms;

    -- key "Keypad 4" press 
    writePS2Data(PS2clk, PS2data, X"6B");
    wait for 1 ms;
    -- key "Keypad 4" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"6B");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad *" press and release    
    writePS2Data(PS2clk, PS2data, X"7C");
    wait for 1 ms;
    -- key "Keypad *" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"7C");

    -- wait before next "Keystroke"
    wait for 1 ms;

    -- key "Keypad 7" press
    writePS2Data(PS2clk, PS2data, X"6C");
    wait for 1 ms;
    -- key "Keypad 7" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"6C");

    -- wait before next "Keystroke"
    wait for 1 ms;

    -- key "Keypad /" press 
    writePS2Data(PS2clk, PS2data, X"E0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"4A");
    wait for 1 ms;
    -- key "Keypad /" release    
    writePS2Data(PS2clk, PS2data, X"E0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"4A");

    -- wait before next "Keystroke"
    wait for 1 ms;

    -- key "Keypad 2" press 
    writePS2Data(PS2clk, PS2data, X"72");
    wait for 1 ms;
    -- key "Keypad 2" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"72");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad ENTER" press 
    writePS2Data(PS2clk, PS2data, X"E0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"5A");
    wait for 1 ms;
    -- key "Keypad ENTER" release    
    writePS2Data(PS2clk, PS2data, X"E0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"5A");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad 8" press    
    writePS2Data(PS2clk, PS2data, X"75");
    wait for 1 ms;
    -- key "Keypad 8" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"75");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad 4" press    
    writePS2Data(PS2clk, PS2data, X"6B");
    wait for 1 ms;
    -- key "Keypad 4" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"6B");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad -" press    
    writePS2Data(PS2clk, PS2data, X"7B");
    wait for 1 ms;
    -- key "Keypad -" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"7B");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad 1" press    
    writePS2Data(PS2clk, PS2data, X"69");
    wait for 1 ms;
    -- key "Keypad 1" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"69");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad ENTER" press    
    writePS2Data(PS2clk, PS2data, X"E0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"5A");
    wait for 1 ms;
    -- key "Keypad ENTER" release    
    writePS2Data(PS2clk, PS2data, X"E0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"5A");

    -- wait before next "Keystroke"    
    wait for 1 ms;

    -- key "Keypad 1" press    
    writePS2Data(PS2clk, PS2data, X"69");
    wait for 1 ms;
    -- key "Keypad 1" release    
    writePS2Data(PS2clk, PS2data, X"F0");
    wait for 40 us;
    writePS2Data(PS2clk, PS2data, X"69");


    -- wait forever
    wait;
    
    
    
  end process writeData;

    

end behavior;
