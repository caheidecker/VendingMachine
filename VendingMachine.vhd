LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
--USE ieee.std_logic_signed.all;
Entity VendingMachine is
PORT( 	
      add_five        : IN std_logic;
		add_ten         : IN std_logic;
		SET_BINARY_COST : IN std_logic_vector(3 downto 0);
		READY				 : OUT std_logic;
		NOT_READY		 : OUT std_logic;
		DISPLAY_DEPOSIT : OUT std_logic_vector(15 downto 0);
      DISPLAY_CHANGE  : OUT std_logic_vector(15 downto 0);
		DISPLAY_COST    : OUT std_logic_vector(15 downto 0));	
END VendingMachine;
ARCHITECTURE OUTPUT OF VendingMachine is
       signal TOTAL : std_logic_vector(7 downto 0);
		 signal CHANGE: std_logic_vector(7 downto 0);
		 signal COST  : std_logic_vector(7 downto 0);
BEGIN                 

multiply5:process(SET_BINARY_COST)
begin
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

count:process(add_five,add_ten)
begin

	if(COST > TOTAL) THEN
		else if(add_five = '1') THEN TOTAL <= TOTAL + 5;
			else if(add_ten = '1') THEN TOTAL <= TOTAL + 10;
				if(COST <= TOTAL) THEN TOTAL <= COST;
				end if;
			end if;
		end if;
	end if;
end process count;--end of count

MAKE_CHANGE:process(TOTAL,COST)
begin
	CHANGE <= (COST - TOTAL);
end process MAKE_CHANGE;

isReady:process(TOTAL,COST)
begin
	if(TOTAL = COST) THEN READY <= '1';
		else NOT_READY <= '1';
	end if;
end process isReady;

hex_COST:process(COST)
	begin
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
	
hex_DEPOSIT:process(TOTAL)
	begin
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
	
hex_CHANGE:process(CHANGE)
	begin
		case CHANGE is
      when x"00"=> DISPLAY_CHANGE <= "1100000011000000";--00
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

