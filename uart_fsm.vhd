-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): xbarta50
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK     : in std_logic;
   RST     : in std_logic;
   DIN     : in std_logic;
   COUNT1  : in std_logic_vector(4 downto 0);
   COUNT2  : in std_logic_vector(3 downto 0);
   RECEIVE : out std_logic;
   COUNTSON: out std_logic;
   VALID   : out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type STATE_TYPE is (WAIT_START, WAIT_TO_READ_FIRST_BIT, GET_DATA, WAIT_STOP_BIT, VALIDATE);
signal state : STATE_TYPE := WAIT_START; 
begin

   RECEIVE <= '1' when state = GET_DATA
   else '0';
   COUNTSON <= '1' when state = WAIT_TO_READ_FIRST_BIT or state = GET_DATA
   else '0';
   VALID <= '1' when state = VALIDATE
   else '0';

   process (CLK) begin
      if rising_edge(CLK) then
         if RST = '1' then 
				state <= WAIT_START;
         else 
            case state is
               when WAIT_START => if DIN = '0' then
                                    state <= WAIT_TO_READ_FIRST_BIT;
                                    end if;
               when WAIT_TO_READ_FIRST_BIT => if COUNT1 = "10110" then
                                                      state <= GET_DATA;
                                                      end if;
               when GET_DATA => if COUNT2 = "1000" then
                                    state <= WAIT_STOP_BIT;
                                    end if;
               when WAIT_STOP_BIT => if DIN = '1' then
                                       state <= VALIDATE;
                                       end if;
               when VALIDATE => state <= WAIT_START;
               when others => null;
            end case;
         end if;
      end if;
   end process;
end behavioral;
