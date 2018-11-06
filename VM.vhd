library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
 
entity VM is
  port (
    i_rst_l : in std_logic;
    i_clk   : in std_logic;
    i_a     : in std_logic_vector(4 downto 0);
    i_b     : in std_logic_vector(4 downto 0)
    );
end signed_unsigned;
 
architecture behave of VM is
  signal ru_SUM_RESULT : unsigned(7 downto 0) := (others => '0');
  signal ru_SUB_RESULT : unsigned(7 downto 0) := (others => '0');
         
begin
 
  -- Purpose: Add two numbers.  Does both the signed and unsigned
  -- addition for demonstration.  This process is synthesizable.
  p_SUM : process (i_clk, i_rst_l)
  begin
    if i_rst_l = '0' then             -- asynchronous reset (active low)
      rs_SUM_RESULT <= (others => '0');
      ru_SUM_RESULT <= (others => '0');
    elsif rising_edge(i_clk) then
       
      ru_SUM_RESULT <= unsigned(i_a) + unsigned(i_b);
     
    end if;
       
  end process p_SUM;
 
end behave;