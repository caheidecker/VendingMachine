LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
Entity VendingMachine is --declare entity
PORT( 	
		add_five        : IN std_logic;--nickels button
		add_ten         : IN std_logic;--dimes button
		change_switch   : IN std_logic;--change return
		SET_BINARY_COST : IN std_logic_vector(3 downto 0);--cost of item 4 bits
		READY		    	 : OUT std_logic:='1';--food pickup LED
		NOT_READY	    : OUT std_logic:='1';--insufficient money LED
		TURN_OFF_LEDS   : OUT std_logic_vector(7 downto 0):=x"00";--vector to eliminate LED's other than food pickup and insufficient money
		
		CHANGE,TOTAL : buffer std_logic_vector(7 downto 0);
		DISPLAY_DEPOSIT : OUT std_logic_vector(15 downto 0);--16 bits for 2 7-segment displays
      DISPLAY_CHANGE  : OUT std_logic_vector(15 downto 0);--16 bits for 2 7-segment displays
		DISPLAY_COST    : OUT std_logic_vector(15 downto 0));--16 bits for 2 7-segment displays
END VendingMachine;--close entity
ARCHITECTURE OUTPUT OF VendingMachine is
      -- signal CHANGE: std_logic_vector(7 downto 0);
		 signal COST	  : std_logic_vector(7 downto 0); 
		 --signal TOTAL : std_logic_vector(7 downto 0):= (others => '0');
		 signal TOTAL_OUT	: std_logic_vector(7 downto 0);
		 signal TOTAL_OUT2	: std_logic_vector(7 downto 0);
		 signal NICKEL_BUTTON_COUNTER : integer range 0 to 700000000;
		 signal DIMES_BUTTON_COUNTER	: integer range 0 to 1000000; 
BEGIN                

COUNT_FIVE_CENTS:process(add_five)
BEGIN
	if(change_switch='1') then 
		NICKEL_BUTTON_COUNTER<=0;
		TOTAL_OUT<="00000000";--reset nickel counter to zero and total to zero if change return switch goes high
		else if(change_switch='0') then --if change return switch is low, do the following
	if (add_five='0') then NICKEL_BUTTON_COUNTER<=NICKEL_BUTTON_COUNTER+1;--nickel button pressed, bump nickel counter
	if(NICKEL_BUTTON_COUNTER>=7) then TOTAL_OUT<="00100011";--if nickels pressed 7 times, stop total at 35 max
		else if(NICKEL_BUTTON_COUNTER<=7) then TOTAL_OUT<=TOTAL_OUT+5;--if nickels havent been pressed 7 times yet, bump by 5 when pressed
					end if;
				end if;
			end if;
		end if;
	end if;--close all if statements
end process COUNT_FIVE_CENTS;--end of count



COUNT_TEN_CENTS:process(add_ten)
BEGIN
	if(change_switch='1') then
		DIMES_BUTTON_COUNTER<=0;
		TOTAL_OUT2<="00000000";--reset dime counter to zero and total to zero if change return switch goes high
		else if(change_switch='0') then --if change return switch is low, do the following
	if (add_ten='0') then DIMES_BUTTON_COUNTER<=DIMES_BUTTON_COUNTER+1;--dime button pressed, bump dime counter
	if(DIMES_BUTTON_COUNTER>=3)then TOTAL_OUT2<="00101000";--if dimes pressed 4 times, stop total at 40 max
		else if(DIMES_BUTTON_COUNTER<=3) then TOTAL_OUT2<=TOTAL_OUT2+10;--if dimes havent been pressed 4 times yet, bump by 10 when pressed
					end if;
				end if;
			end if;
		end if;
	end if;--close all if statements
end process COUNT_TEN_CENTS;--end of count

TOTALMONEY:process(TOTAL_OUT,TOTAL_OUT2)
BEGIN
	TOTAL<=(TOTAL_OUT+TOTAL_OUT2); --update total every time total_out or total_out2 changes
end process TOTALMONEY;

MAKE_CHANGE:process(TOTAL,COST)
BEGIN
	if(change_switch='1') then CHANGE<="00000000";
	else if(TOTAL>COST) then
	READY<='1'; NOT_READY<='0';
	CHANGE<=(TOTAL-COST);
	else if(TOTAL<COST) then 
	READY<='0'; NOT_READY<='1'; CHANGE<="00000000";
	else if(TOTAL=COST) then
	READY<='1'; NOT_READY<='0'; CHANGE<=x"FF";
	
end if; end if; end if;end if;
end process MAKE_CHANGE;

multiply5:process(SET_BINARY_COST)
BEGIN
	case SET_BINARY_COST is
		when "0000" => COST <= x"00";--0
		when "0001" => COST <= x"05";--5
		when "0010" => COST <= x"0A";--10
		when "0011" => COST <= x"0F";--15
		when "0100" => COST <= x"14";--20
		when "0101" => COST <= x"19";--25
		when "0110" => COST <= x"1E";--30
		when "0111" => COST <= x"23";--35
		when "1000" => COST <= x"28";--40
		when "1001" => COST <= x"2D";--45
		when "1010" => COST <= x"32";--50
		when "1011" => COST <= x"37";--55
		when "1100" => COST <= x"3C";--60
		when "1101" => COST <= x"41";--65
		when "1110" => COST <= x"46";--70
		when "1111" => COST <= x"4B";--75
		when others => COST <= x"00";
	end case;
end process multiply5;

hex_COST:process(COST)-- HEX5,HEX4
	BEGIN
		case COST is
		when x"00"=> DISPLAY_COST <= "1100000011000000";--00
		when x"05"=> DISPLAY_COST <= "1100000010010010";--05
		when x"0A"=> DISPLAY_COST <= "1111100111000000";--10
		when x"0F"=> DISPLAY_COST <= "1111100110010010";--15
		when x"14"=> DISPLAY_COST <= "1010010011000000";--20
		when x"19"=> DISPLAY_COST <= "1010010010010010";--25
		when x"1E"=> DISPLAY_COST <= "1011000011000000";--30
		when x"23"=> DISPLAY_COST <= "1011000010010010";--35
		when x"28"=> DISPLAY_COST <= "1001100111000000";--40
		when x"2D"=> DISPLAY_COST <= "1001100110010010";--45
		when x"32"=> DISPLAY_COST <= "1001001011000000";--50
		when x"37"=> DISPLAY_COST <= "1001001010010010";--55
		when x"3C"=> DISPLAY_COST <= "1000001011000000";--60
		when x"41"=> DISPLAY_COST <= "1000001010010010";--65
		when x"46"=> DISPLAY_COST <= "1111100011000000";--70
		when x"4B"=> DISPLAY_COST <= "1111100010010010";--75
		when others => DISPLAY_COST <= "1100000011000000"; --display 00
	end case;
end process hex_COST;--end of display
	
hex_DEPOSIT:process(TOTAL)-- HEX3, HEX2
	BEGIN
		case TOTAL is
		when x"00"=> DISPLAY_DEPOSIT <= "1100000011000000";--00
		when x"05"=> DISPLAY_DEPOSIT <= "1100000010010010";--05
		when x"0A"=> DISPLAY_DEPOSIT <= "1111100111000000";--10
		when x"0F"=> DISPLAY_DEPOSIT <= "1111100110010010";--15
		when x"14"=> DISPLAY_DEPOSIT <= "1010010011000000";--20
		when x"19"=> DISPLAY_DEPOSIT <= "1010010010010010";--25
		when x"1E"=> DISPLAY_DEPOSIT <= "1011000011000000";--30
		when x"23"=> DISPLAY_DEPOSIT <= "1011000010010010";--35
		when x"28"=> DISPLAY_DEPOSIT <= "1001100111000000";--40
		when x"2D"=> DISPLAY_DEPOSIT <= "1001100110010010";--45
		when x"32"=> DISPLAY_DEPOSIT <= "1001001011000000";--50
		when x"37"=> DISPLAY_DEPOSIT <= "1001001010010010";--55
		when x"3C"=> DISPLAY_DEPOSIT <= "1000001011000000";--60
		when x"41"=> DISPLAY_DEPOSIT <= "1000001010010010";--65
		when x"46"=> DISPLAY_DEPOSIT <= "1111100011000000";--70
		when x"4B"=> DISPLAY_DEPOSIT <= "1111100010010010";--75
		when others => DISPLAY_DEPOSIT <= "1100000011000000"; --display 00
	end case;
end process hex_DEPOSIT;--end of display
	
hex_CHANGE:process(CHANGE)-- HEX1, HEX0
	BEGIN
		case CHANGE is
		when x"00"=> DISPLAY_CHANGE <= "1111111111111111";--blank
      when x"FF"=> DISPLAY_CHANGE <= "1100000011000000";--00
		when x"05"=> DISPLAY_CHANGE <= "1100000010010010";--05
		when x"0A"=> DISPLAY_CHANGE <= "1111100111000000";--10
		when x"0F"=> DISPLAY_CHANGE <= "1111100110010010";--15
		when x"14"=> DISPLAY_CHANGE <= "1010010011000000";--20
		when x"19"=> DISPLAY_CHANGE <= "1010010010010010";--25
		when x"1E"=> DISPLAY_CHANGE <= "1011000011000000";--30
		when x"23"=> DISPLAY_CHANGE <= "1011000010010010";--35
		when x"28"=> DISPLAY_CHANGE <= "1001100111000000";--40
		when x"2D"=> DISPLAY_CHANGE <= "1001100110010010";--45
		when x"32"=> DISPLAY_CHANGE <= "1001001011000000";--50
		when x"37"=> DISPLAY_CHANGE <= "1001001010010010";--55
		when x"3C"=> DISPLAY_CHANGE <= "1000001011000000";--60
		when x"41"=> DISPLAY_CHANGE <= "1000001010010010";--65
		when x"46"=> DISPLAY_CHANGE <= "1111100011000000";--70
		when x"4B"=> DISPLAY_CHANGE <= "1111100010010010";--75
		when others => DISPLAY_CHANGE <= "1100000011000000"; --display 00
	end case;
end process hex_CHANGE;--end of display
END OUTPUT; 

