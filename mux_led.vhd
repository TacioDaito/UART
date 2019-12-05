
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY disp7 IS
PORT (dec : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
  disp : OUT STD_LOGIC_VECTOR (9 DOWNTO 0));
END disp7;
  
ARCHITECTURE decod OF disp7 IS
BEGIN
  case dec is
    when "00000000" => disp <= "0000000000";
    when "00000001" => disp <= "0000000001"; 
    when "00000010" => disp <= "0000000011"; 
    when "00000011" => disp <= "0000000111"; 
    when "00000100" => disp <= "0000001111"; 
    when "00000101" => disp <= "0000011111"; 
    when "00000110" => disp <= "0000111111"; 
    when "00000111" => disp <= "0001111111"; 
    when "00001000" => disp <= "0011111111"; 
    when "00001001" => disp <= "0111111111"; 
    when "00001010" => disp <= "1111111111";
    when others => disp <= "0000000000";
  END case;
END decod;
