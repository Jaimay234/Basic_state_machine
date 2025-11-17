library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity full_state_machine is
port(
	in_bit: in std_logic;
	clk   : in std_logic;
	reset : in std_logic;	
	pattern_detected: out std_logic);
end full_state_machine;

architecture fsm of full_state_machine is
signal pattern: std_logic_vector(2 downto 0) := "000";
type state_type is (S0,S1,S2,S3);
signal state, next_state: state_type;
begin
process(clk)
begin
if reset = '1' then
pattern <= "000";
state <= S0;
elsif(clk = '1' and clk'event) then
pattern(0) <= in_bit;
for i in 0 to 1 loop
pattern(i+1) <= pattern(i);
end loop;
state <= next_state;
end if;
end process;

process(state,pattern)
begin
case state is
	when S0 =>
	pattern_detected <= '0';
	if pattern(0) = '1' then
	next_state <= S1;
	else
	next_state <= S0;
end if;
--2nd state declarations
	when S1 => 
	pattern_detected <= '0';
	if pattern(1) = '1' and pattern(0) = '0' then
	next_state <= S2;
	else
	next_state <= S1;
end if;
--3rd state declarations
	when S2 =>
	pattern_detected <= '0';
	if pattern = "101" then
	next_state <= S3;
	else
	next_state <= S2;
end if;
--Last state
	when S3 =>
	next_state <= S3;
	pattern_detected <= '1';
end case;
end process;
end fsm;

