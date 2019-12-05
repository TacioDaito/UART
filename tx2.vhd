

-- Módulo TX (UART)

library ieee;
use ieee.std_logic_1164.all;

entity tx is
	port(
		clock, reset, switch_baud_rate, botao_envio : in	std_logic;
		entrada_tx : in	std_logic_vector(7 downto 0);
		saida_tx : out	std_logic
	);
end entity;
			
architecture rt2 of tx is
	type estados is (s0, s1, s2, s3);
	signal estado : estados := s0;
	signal conta_ciclo : integer range 0 to 5207 := 0;
	signal conta_bit: integer range 0 to 10 := 0;
	signal r0_botao : std_logic;
	signal r1_botao : std_logic;
	signal detector_borda : std_logic;
	signal max_conta_ciclo : integer range 433 to 5207;
begin
	detector_borda <= not r0_botao and r1_botao;
	
	alterar_baud_rate : process(switch_baud_rate)
	begin
		case switch_baud_rate is
			when '0' =>
				max_conta_ciclo <= 5207;
			when '1' =>
				max_conta_ciclo <= 433;
		end case;
	end process alterar_baud_rate;
	
	detector_borda_descida : process(clock, reset)
	begin
		if reset = '0' then
			r0_botao <= '0';
			r1_botao <= '0';
		elsif rising_edge(clock) then
			r0_botao <= botao_envio;
			r1_botao <= r0_botao;
		end if;
	end process detector_borda_descida;

	contador : process (clock, reset)
	begin
		if reset = '0' then
			conta_ciclo <= 0;
			conta_bit <= 0;
		elsif rising_edge(clock) then
			if not(estado = s0) then
				if conta_ciclo = max_conta_ciclo then
					conta_ciclo <= 0;
					if conta_bit = 10 then
						conta_bit <= 0;
					else
						conta_bit <= conta_bit+1;
					end if;
				else
					conta_ciclo <= conta_ciclo+1;
				end if;
			end if;	
		end if;
	end process contador;

	logica_estado : process (clock, reset)
	begin
		if reset = '0' then
			estado <= s0;
		elsif rising_edge(clock) then
			case estado is
				when s0 =>
					if detector_borda = '1' and botao_envio = '0' then
						estado <= s1;
					else
						estado <= s0;
					end if;
				when s1 =>
					if conta_bit = 1 then
						estado <= s2;
					else
						estado <= s1;
					end if;
				when s2 =>
					if conta_bit = 9 then
						estado <= s3;
					else
						estado <= s2;
					end if;
				when s3 =>
					if conta_bit = 10 then
						estado <= s0;
					else
						estado <= s3;
					end if;
			end case;
		end if;
	end process logica_estado;
	
	logica_operacao : process (clock, reset)
	begin
		if reset = '0' then
			saida_tx <= '0';
		elsif rising_edge(clock) then
			case estado is
				when s0 => 
					saida_tx <= '1';
				when s1 =>
					saida_tx <= '0';
				when s2 =>
					if conta_bit = 1 then
						saida_tx <= entrada_tx(0);
					elsif conta_bit = 2 then
						saida_tx <= entrada_tx(1);
					elsif conta_bit = 3 then
						saida_tx <= entrada_tx(2);
					elsif conta_bit = 4 then
						saida_tx <= entrada_tx(3);
					elsif conta_bit = 5 then
						saida_tx <= entrada_tx(4);
					elsif conta_bit = 6 then
						saida_tx <= entrada_tx(5);
					elsif conta_bit = 7 then
						saida_tx <= entrada_tx(6);
					elsif conta_bit = 8 then
						saida_tx <= entrada_tx(7);	
					end if;
				when s3 =>
					saida_tx <= '1';
			end case;
		end if;	
	end process logica_operacao;
	
end rt2;
