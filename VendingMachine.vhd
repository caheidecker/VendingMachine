LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
--USE ieee.std_logic_signed.all;
Entity VendingMachine is
PORT( 	
      add_five        : IN std_logic;
		add_ten         : IN std_logic;
		SET_BINARY_COST : IN std_logic_vector(3 downto 0);
		READY				 : OUT std_logic_vector(1 downto 0);
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
		when "0000" => COST <= x"00";
		when "0001" => COST <= x"05";
		when "0010" => COST <= x"0A";
		when "0011" => COST <= x"0F";
		when others => COST <= x"00";
	end case;
end process multiply5;

count5:process(add_five)
begin
    if(add_five = '1') THEN
		if(TOTAL >= COST) THEN TOTAL <= COST;
			if(TOTAL > COST) THEN TOTAL <= TOTAL + 5; 
			end if;
		end if;
  end if;
end process count5;--end of count5

count10:process(add_ten)
begin
    if(add_ten = '1') THEN
		if(TOTAL >= COST) THEN TOTAL <= COST;
			if(TOTAL > COST) THEN TOTAL <= TOTAL + 10; 
			end if;
		end if;
	end if;
end process count10;--end of count5

MAKE_CHANGE:process(TOTAL,COST)
begin
	CHANGE <= (COST - TOTAL);
end process MAKE_CHANGE;

hex_COST:process(COST)
	begin
		case COST is
		   when x"05"=> DISPLAY_COST <= "1100000010010010" ; --display 05
		   when x"0A"=> DISPLAY_COST <= "1111100111000000" ; --display 10
		   when x"15"=> DISPLAY_COST <= "1111100110010010" ; --display 15
		   when x"20"=> DISPLAY_COST <= "1010010011000000" ; --display 20
		   when x"25"=> DISPLAY_COST <= "1010010010010010" ; --display 25
		   when x"30"=> DISPLAY_COST <= "1011000011000000" ; --dislpay 30
			when others => DISPLAY_COST <= "1100000011000000" ; --display 00
		end case;
	end process hex_COST;--end of display
	
	hex_DEPOSIT:process(TOTAL)
	begin
		case TOTAL is
--		   when "00001"=> DISPLAY_DEPOSIT <= "1100000011111001" ; --display 01
--		   when "00010"=> DISPLAY_DEPOSIT <= "1100000010100100" ; --display 02
--		   when "00011"=> DISPLAY_DEPOSIT <= "1100000010110000" ; --display 03
--		   when "00100"=> DISPLAY_DEPOSIT <= "1100000010011001" ; --display 04
--		   when "00101"=> DISPLAY_DEPOSIT <= "1100000010010010" ; --display 05
--		   when "00110"=> DISPLAY_DEPOSIT <= "1100000010000010" ; --display 06
--		   when "00111"=> DISPLAY_DEPOSIT <= "1100000011111000" ; --display 07
--	      when "01000"=> DISPLAY_DEPOSIT <= "1100000010000000" ; --display 08
--		   when "01001"=> DISPLAY_DEPOSIT <= "1100000010011000" ; --display 09
--		   when "01010"=> DISPLAY_DEPOSIT <= "1111100111000000" ; --display 10
--		   when "01011"=> DISPLAY_DEPOSIT <= "1111100111111001" ; --display 11
--		   when "01100"=> DISPLAY_DEPOSIT <= "1111100110100100" ; --display 12
--		   when "01101"=> DISPLAY_DEPOSIT <= "1111100110110000" ; --display 13
--		   when "01110"=> DISPLAY_DEPOSIT <= "1111100110011001" ; --display 14
--		   when "01111"=> DISPLAY_DEPOSIT <= "1111100110010010" ; --display 15
--		   when "10000"=> DISPLAY_DEPOSIT <= "1111100110000010" ; --display 16
--		   when "10001"=> DISPLAY_DEPOSIT <= "1111100111111000" ; --display 17
--		   when "10010"=> DISPLAY_DEPOSIT <= "1111100110000000" ; --display 18
--		   when "10011"=> DISPLAY_DEPOSIT <= "1111100110011000" ; --display 19
--		   when "10100"=> DISPLAY_DEPOSIT <= "1010010011000000" ; --display 20
--		   when "10101"=> DISPLAY_DEPOSIT <= "1010010011111001" ; --display 21
--		   when "10110"=> DISPLAY_DEPOSIT <= "1010010010100100" ; --display 22
--		   when "10111"=> DISPLAY_DEPOSIT <= "1010010010110000" ; --display 23
--	      when "11000"=> DISPLAY_DEPOSIT <= "1010010010011001" ; --display 24
--		   when "11001"=> DISPLAY_DEPOSIT <= "1010010010010010" ; --display 25
--		   when "11010"=> DISPLAY_DEPOSIT <= "1010010010000010" ; --display 26
--		   when "11011"=> DISPLAY_DEPOSIT <= "1010010011111000" ; --display 27
--		   when "11100"=> DISPLAY_DEPOSIT <= "1010010010000000" ; --display 28
--		   when "11101"=> DISPLAY_DEPOSIT <= "1010010010011000" ; --display 29
--		   when "11110"=> DISPLAY_DEPOSIT <= "1011000011000000" ; --dislpay 30
			when others => DISPLAY_DEPOSIT <= "1100000011000000" ; --display 00
		end case;
	end process hex_DEPOSIT;--end of display
	
hex_CHANGE:process(CHANGE)
	begin
		case CHANGE is
         --when 
			when others => DISPLAY_CHANGE <= "1100000011000000" ; --display 00
		end case;
	end process hex_CHANGE;--end of display
	
END OUTPUT; 

