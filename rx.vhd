
-- Módulo RX (UART)

library ieee;
use ieee.std_logic_1164.all;

entity rx is
	port(
		clock, reset, switch_baud_rate, entrada_rx : in	std_logic; -- Entradas do bloco RX
		saida_rx : out	std_logic_vector(7 downto 0) -- Saída do bloco RX (vetor de 8 bits) -- vai para os leds
	);
end entity;
			
architecture rtl of rx is
	type estados is (s0, s1, s2, s3); -- Estados da máquina de 4 estados de Moore - s0: 'espera', s1: 'começo', s2: 'recepção' e s3: 'término'
	signal estado : estados := s0; -- Estado inicial (s0)
	signal r0_entrada_rx : std_logic; -- Usado na verificação da borda de descida da entrada
	signal r1_entrada_rx : std_logic; -- " " "
	signal detector_borda : std_logic; -- Retorna 1 caso a entrada mude de 1 para 0 (borda de descida)
	signal b0, b1, b2, b3, b4, b5, b6, b7 : std_logic := '0'; -- Usados para a bufferização dos bits recebidos
	signal sinal_saida_rx : std_logic_vector(7 downto 0) := "00000000"; -- Usado como buffer para a saída
	signal conta_ciclo : integer range 1 to 5208 := 1; -- Conta cada ciclo de clock. Vai de 1 até 434 ou até 5208, dependendo do switch SW[9]
	signal conta_bit: integer range 1 to 10 := 1; -- Conta os tempos de cada bit. Vai de 1 a 10
	signal max_conta_ciclo : integer range 434 to 5208; -- Limite máximo do contador de ciclo. Varia de acordo com o switch SW[9], mudando o baud rate
	signal metade_conta_ciclo : integer range 217 to 2604; -- Metade do limite máximo do contador de ciclo. Usado para temporizar a amostragem dos bits
begin
	detector_borda <= not r0_entrada_rx and r1_entrada_rx;
	saida_rx <= sinal_saida_rx; -- Associa o valor da saída com o seu buffer
	
	alterar_baud_rate : process(switch_baud_rate) -- [ Responsável pela alteração e atribuição dos valores de baud rate ]
	begin
		case switch_baud_rate is
			when '0' =>
				max_conta_ciclo <= 5208;
				metade_conta_ciclo <= 2604;
			when '1' =>
				max_conta_ciclo <= 434;
				metade_conta_ciclo <= 217;
		end case;
	end process alterar_baud_rate;
	
	detector_borda_descida : process(clock, reset) -- [ Responsável por detectar o recebimento do bit de começo ]
	begin
		if reset = '0' then
			r0_entrada_rx <= '0';
			r1_entrada_rx <= '0';
		elsif rising_edge(clock) then -- Executa o código dentro do elsif toda vez que o clock subir
			r0_entrada_rx <= entrada_rx;
			r1_entrada_rx <= r0_entrada_rx;
		end if;
	end process detector_borda_descida;

	contador : process (clock, reset) -- [ Responsavel pela contagem dos ciclos de clock e dos tempos de bit ]
	begin
		if reset = '0' then
			conta_ciclo <= 1;
			conta_bit <= 1;
		elsif rising_edge(clock) then
			if not(estado = s0) then -- Dispara o contador quando o estado sai do estado de 'espera' (consequência do recebimento do bit de começo) ¹
				if conta_ciclo = max_conta_ciclo then -- Zera o contador de ciclos de clock quando o valor máximo - que depende do switch SW[9] - é atingido
					conta_ciclo <= 1;
					if conta_bit = 10 then -- Zera o contador de tempo de bit ao atingir 10
						conta_bit <= 1;
					else
						conta_bit <= conta_bit+1;
					end if;
				else
					conta_ciclo <= conta_ciclo+1;
				end if;
			end if;	
		end if;
	end process contador;

	logica_estado : process (clock, reset) -- [ Responsável pela lógica de mudança de estados ]
	begin
		if reset = '0' then
			estado <= s0;
		elsif rising_edge(clock) then
			case estado is
				when s0 => -- Estado de 'espera' (s0)
					if detector_borda = '1' and entrada_rx = '0' then -- Muda o estado - de 'espera' para 'começo' - quando o bit de começo é recebido, disparando o contador ¹
						estado <= s1;
					else
						estado <= s0; -- Continua no estado de 'espera' caso o bit de começo não seja recebido
					end if;
				when s1 => -- Estado de 'começo' (s1)
					if conta_bit = 2 then -- Muda o estado - de 'começo' para 'recepção' - após 1 tempo de bit (quando os bits de dados serão recebidos)
						estado <= s2;
					else
						estado <= s1; -- Continua no estado de 'começo' até 1 tempo de bit se passar
					end if;
				when s2 => -- Estado de 'recepção' (s2)
					if conta_bit = 10 then -- Muda o estado - de 'recepção' para 'término' - após 10 tempos de bit (quando o bit de parada é recebido)
						estado <= s3;
					else
						estado <= s2; -- Continua no estado de 'recepção' até 9 tempos de bit se passarem
					end if;
				when s3 => -- Estado de 'término' (s3)
					if conta_bit = 10 and conta_ciclo = max_conta_ciclo then -- Retorna o estado para 'espera' ao se completar 10 tempos de bit
						estado <= s0;
					else
						estado <= s3; 
					end if;
			end case;
		end if;
	end process logica_estado;
	
	logica_operacao : process (clock,reset) -- [ Responsável pela lógica de execução e atribuição da saída com base no estado atual ]
	begin
		if reset = '0' then
			sinal_saida_rx <= "00000000";
		 elsif rising_edge(clock) then
			case estado is
				when s0 => 
					sinal_saida_rx <= sinal_saida_rx;
				when s1 =>
					sinal_saida_rx <= sinal_saida_rx;
				when s2 =>
					sinal_saida_rx <= sinal_saida_rx;
					if conta_ciclo = metade_conta_ciclo then -- Armazena cada bit recebido nos seus respectivos buffers de bit
						if conta_bit = 2 then
							b0 <= entrada_rx;
						elsif conta_bit = 3 then
							b1 <= entrada_rx;
						elsif conta_bit = 4 then
							b2 <= entrada_rx;
						elsif conta_bit = 5 then
							b3 <= entrada_rx;
						elsif conta_bit = 6 then
							b4 <= entrada_rx;
						elsif conta_bit = 7 then
							b5 <= entrada_rx;
						elsif conta_bit = 8 then
							b6 <= entrada_rx;
						elsif conta_bit = 9 then
							b7 <= entrada_rx;	
						end if;
					end if;
				when s3 =>
					sinal_saida_rx <= b7 & b6 & b5 & b4 & b3 & b2 & b1 & b0; -- Sintetiza a saída do módulo RX concatenando os bits armazenados nos buffers de bit
			end case;
		end if;
	end process logica_operacao;
	
end rtl;
