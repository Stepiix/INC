-- uart.vhd: UART controller - receiving part
-- Author(s): xbarta50
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK: 	    in std_logic;
	RST: 	    in std_logic;
	DIN: 	    in std_logic;
	DOUT: 	    out std_logic_vector(7 downto 0);
	DOUT_VLD: 	out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal count1    : std_logic_vector(4 downto 0);
signal count2    : std_logic_vector(3 downto 0);
signal receive : std_logic;
signal countson: std_logic;
signal valid   : std_logic;
begin
	FSM: entity work.UART_FSM(behavioral)
	port map (
				CLK 		=> CLK,
				RST			=> RST,
				DIN			=> DIN,
				COUNT1		=> count1,
				COUNT2	 	=> count2,
				RECEIVE		=> receive,
				COUNTSON 	=> countson,
				VALID 		=> valid
			);
			DOUT_VLD <= valid;
		process (CLK) begin
			if rising_edge(CLK) then

				if countson = '1' then 
					count1 <= count1 + 1;
				else 
					count1 <= "00000";
				end if;

				if count2(3) = '1' then
					count1 <= "00000";
					count2 <= "0000";
				end if;

				if receive = '1' then
					if count1 = "10111" then
						count1 <= "01000";
					case count2 is
						when "0000" => DOUT(0) <= DIN;
						when "0001" => DOUT(1) <= DIN;
						when "0010" => DOUT(2) <= DIN;
						when "0011" => DOUT(3) <= DIN;
						when "0100" => DOUT(4) <= DIN;
						when "0101" => DOUT(5) <= DIN;
						when "0110" => DOUT(6) <= DIN;
						when "0111" => DOUT(7) <= DIN;
						when others => null;
					end case;
					count2 <= count2 + 1;
					end if;
				else
					count2 <= "0000";
				end if;
			end if;
		end process;
end behavioral;
