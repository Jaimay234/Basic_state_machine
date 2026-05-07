library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity three_k_plus_one is
	port(
    	reset  	: in  std_logic;
    	clk    	: in  std_logic;
    	number_out : out unsigned(6 downto 0);
    	term_out   : out unsigned(6 downto 0);
    	done_out   : out std_logic
	);
end three_k_plus_one;

architecture asm of three_k_plus_one is

	type state is (reset_state, test_state, increment, reload_term, generate_state, divide_state, mult_add, DONE); – 8 states from waveform in the diagram in the project
	signal current, next_state : state;
	signal num_reg   : unsigned(6 downto 0); – internal num since its an output and cant be read
	signal temp_term : unsigned(6 downto 0); – internal signal that acts as term
	signal counter   : unsigned(3 downto 0); -- counts steps this is the length register

begin

process(clk, reset)
variable internal_term: unsigned(6 downto 0);
begin
–reused statenames from waveform for easier checking so they wont match asm
– but general idea remains the same 
number_out <= num_reg;
term_out  <= temp_term;
	if reset = '1' then
	current <= reset_state;
	elsif rising_edge(clk) then
    	current <= next_state;
    	case current is
        	when reset_state =>
            	counter   <= "0001";
            	done_out  <= '0';
            	temp_term <= "0000001";
            	num_reg <= "0000001";
   	 next_state <= test_state;
        	when test_state =>
            	if temp_term = "0000001" then
           		 if counter = "1001" then
           			 next_state <= done;
           		 else
           			 next_state <= increment;
           		 end if;
           	else
          		 next_state <= generate_state;
            	end if;
           	 
    	when increment =>
    	if next_state /= reload_term then
   		 num_reg <= num_reg + 1;
   		 next_state <= reload_term;
– this state had an issue with repeating its operation so num_reg would go up 2 instead of 1
    	end if;
    	when reload_term =>
   		 next_state <= test_state;
   		 counter <= "0001";
   		 temp_term <= num_reg;
    	when generate_state =>
    	if next_state = generate_state then
   		 counter <= counter +1;
– this if statement fixes counter jumping up by two per state rather than by 1
    	end if;
   		 if temp_term = "0000001" then
   			 next_state <= test_state;
   			 --counter <= "0001";
   		 elsif (temp_term(0) = '1')  then
   			 next_state <= mult_add;
   		 else
   			 next_state <= divide_state;
   		 end if;
    	when divide_state =>
    	if next_state /= test_state then
   		 internal_term := '0' & temp_term(6 downto 1);
   		 temp_term <= internal_term;
   		 next_state <= test_state;
– this would make it divide twice rather than once so if was introduced
    	end if;
    	when mult_add =>
    	if next_state /= test_state then
   		 internal_term := resize(temp_term*3 + 1, 7);
   		 temp_term <= internal_term;
   		 next_state <= test_state;
This would multiply 3x and get out of hand so it means that it would do extra operations
    	end if;
    	when DONE =>
   		 done_out <= '1';
    	end case;
	end if;
end process;

end asm;

