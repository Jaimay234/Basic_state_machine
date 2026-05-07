library IEEE;
use ieee.numeric_std.all ; -- needed for "*" and "/" operators
-- and resize() function
use IEEE.std_logic_1164.all;
entity three_k_plus_one is
    port( reset : in std_logic; -- asynch
    clk : in std_logic;
    number_out : out unsigned(6 downto 0); --incremented number state
    term_out : out unsigned(6 downto 0); -- temporary number
    done_out : out std_logic := '0');
end three_k_plus_one;

architecture three_k of three_k_plus_one is
    signal counter: unsigned(3 downto 0);
    signal temp_number: unsigned(6 downto 0) := "0000000";
begin

process(clk, reset)
    variable temp_term: unsigned(6 downto 0) := "0000001";
    variable internal_reset: std_logic;
begin
if (reset = '1') then
    number_out <= "0000001"; --reset everything to base values
    term_out <= "0000001";
    done_out <= '0';
    counter <= "0001";
    temp_number <= "0000001";
    temp_term := "0000001";
elsif (clk'event and clk = '1') then
    if (temp_term = "0000001") then -- lock stage so that no changes take place
   	 if(counter >= "1001") then
   		 done_out<= '1';
   		 term_out <= temp_term;
   	 else
   		 number_out <= "0000001"; --reset everything to base values
   		 term_out <= "0000001";
   	 
   	 
   		 temp_number <= temp_number +1; --increment generally for fall back number
   		 temp_term := temp_number +1; --account for delay of signals and increment again
   		 number_out <= temp_term;
   		 if (counter /= "0000") then
   			 counter <= "0001";
   		 end if;
   	 end if;
    else --synchronous logic for deciding 3k+1 structure
   	 if ( temp_term(0) = '0') then -- logic for even numbers
   		 term_out <= temp_term;
   		 temp_term:= temp_term/2;
   		 counter <= counter +1;
   	 else
   		 term_out <= temp_term;   		 
   		 temp_term := resize(temp_term *3 + to_unsigned(1,temp_term'length) , 7); -- logic for odd numbers and ensuring it remains 7 bits wide after multiplication
   		 counter <= counter +1;

   	 end if;    
    end if;

end if;

end process;

end three_k;

