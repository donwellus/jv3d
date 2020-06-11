function jv3d_treinamento(p_numero_partidas, p_max_tentativas, p_inverte)
	%rna1 = jv3d_ff_27_49_9;
	%rna2 = jv3d_ff_27_49_9;
	%rna3 = jv3d_ff_27_129_9;
	%rna4 = jv3d_ff_27_129_9_9;

	%save('jv3d_rna3_ff_27_129_9','rna3');
	%save('jv3d_rna4_ff_27_129_9_9','rna4');

	if ~exist('jv3d_rna1_ff_27_49_9.mat','file')
		rna1 = jv3d_ff_27_49_9;
		save('jv3d_rna1_ff_27_49_9','rna1');
	end

	if ~exist('jv3d_rna2_ff_27_49_9.mat','file')
		rna2 = jv3d_ff_27_49_9;
		save('jv3d_rna2_ff_27_49_9','rna2');
	end

	if ~exist('jv3d_rna3_ff_27_129_9.mat','file')
		rna3 = jv3d_ff_27_129_9;
		save('jv3d_rna3_ff_27_129_9','rna3');
	end

	if ~exist('jv3d_rna4_ff_27_129_9_9.mat','file')
		rna4 = jv3d_ff_27_129_9_9;
		save('jv3d_rna4_ff_27_129_9_9','rna4');
	end

	load jv3d_rna1_ff_27_49_9;
	load jv3d_rna2_ff_27_49_9;
	load jv3d_rna3_ff_27_129_9;
	load jv3d_rna4_ff_27_129_9_9;

	jogadores= [jv3d_cria_jogador('R2D2') 
				jv3d_cria_jogador('C3PO')
				jv3d_cria_jogador('Wall-e');
				jv3d_cria_jogador('Numero 5')
				];

	%Vitoria Empate Derrota Pinico(V E D P)
	%				R2D2  C3PO  Walle Nume5
	%				V E D P V E D P V E D P V E D P
	tabela_jogos= [	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	 %R2D2
					0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	 %C3PO
					0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	 %Wall-e
					0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];%Numero 5
	itens= 4;

	if ~exist('p_numero_partidas','var')
		p_numero_partidas='1';
	end
	if ~exist('p_max_tentativas','var')
		p_max_tentativas='30';
	end
	if ~exist('p_inverte','var')
		p_inverte='nao';
	else
		p_inverte='sim';
	end

	%numero de partidas que as redes irão jogar
	partidas= str2num(p_numero_partidas);
	%multiplica por quatro para que todas as redes joguem a mesma quantidade de vezes
	partidas= 4.*partidas;

	max_tentativas= str2num(p_max_tentativas);
	li= 0;
	%início de relatório
	l_inicio= ['Inicio de Relatorio: ' datestr(now,0)]
	for li = 1:partidas
		tabuleiro= [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

		abortar=0;
		l_brancas = 0;
		l_pretas = 0;
		l_travas_b = 0;
		l_travas_p = 0;

		if strcmp(p_inverte, 'sim')
			jogador2= 4-mod(li+2,4);
			jogador1= 4-mod(li+1,4);
		else
			jogador1= 1+mod(li-1,4);
			jogador2= 1+mod(li,4);
		end

		switch(jogador1)
			case {1}
				l_rna1= rna1;
				l_rna2= rna2;
			case {2}
				l_rna1= rna2;
				l_rna2= rna3;
			case {3}
				l_rna1= rna3;
				l_rna2= rna4;
			case {4}
				l_rna1= rna4;
				l_rna2= rna1;
		end

		for i = 1:12
			%vez da rede neural 1
			retorno= jv3d_rna_joga(l_rna1, tabuleiro, max_tentativas, 1);
			l_rna1= retorno.rna;
			if retorno.erro.cod ~= 0
				%retorno.erro
				l_travas_b = l_travas_b + 1;
				break;
			end
			tabuleiro= retorno.situacao;
			l_brancas= l_brancas + retorno.marca;

			%vez da rede neural 2
			retorno= jv3d_rna_joga(l_rna2, tabuleiro, max_tentativas, -1);
			l_rna2= retorno.rna;
			if retorno.erro.cod ~= 0
				%retorno.erro
				l_travas_p = l_travas_p + 1;
				break;
			end
			tabuleiro= retorno.situacao;
			l_pretas= l_pretas + retorno.marca;
		end

		switch(jogador1)
			case {1}
				rna1= l_rna1;
				rna2= l_rna2;
				save('jv3d_rna1_ff_27_49_9','rna1');
				save('jv3d_rna2_ff_27_49_9','rna2');
			case {2}
				rna2= l_rna1;
				rna3= l_rna2;
				save('jv3d_rna2_ff_27_49_9','rna2');
				save('jv3d_rna3_ff_27_129_9','rna3');
			case {3}
				rna3= l_rna1;
				rna4= l_rna2;
				save('jv3d_rna3_ff_27_129_9','rna3');
				save('jv3d_rna4_ff_27_129_9_9','rna4');
			case {4}
				rna4= l_rna1;
				rna1= l_rna2;
				save('jv3d_rna4_ff_27_129_9_9','rna4');
				save('jv3d_rna1_ff_27_49_9','rna1');
		end
		jogadores(jogador1).marca= jogadores(jogador1).marca+l_brancas;
		jogadores(jogador2).marca= jogadores(jogador2).marca+l_pretas;
		jogadores(jogador1).travas= jogadores(jogador1).travas+l_travas_b;
		jogadores(jogador2).travas= jogadores(jogador2).travas+l_travas_p;

		%branca travou
		if l_travas_b
			jogadores(jogador2).vitorias= jogadores(jogador2).vitorias + 1;
			jogadores(jogador1).derrotas= jogadores(jogador1).derrotas + 1;
			tabela_jogos(jogador1,itens*jogador2-1)= tabela_jogos(jogador1,itens*jogador2-1) + 1;
			tabela_jogos(jogador2,itens*jogador1-3)= tabela_jogos(jogador2,itens*jogador1-3) + 1;
			tabela_jogos(jogador1,itens*jogador2)= tabela_jogos(jogador1,itens*jogador2) + 1;
		%preta travou
		elseif l_travas_p
			jogadores(jogador1).vitorias= jogadores(jogador1).vitorias + 1;
			jogadores(jogador2).derrotas= jogadores(jogador2).derrotas + 1;
			tabela_jogos(jogador1,itens*jogador2-3)= tabela_jogos(jogador1,itens*jogador2-3) + 1;
			tabela_jogos(jogador2,itens*jogador1-1)= tabela_jogos(jogador2,itens*jogador1-1) + 1;
			tabela_jogos(jogador2,itens*jogador1)= tabela_jogos(jogador2,itens*jogador1) + 1;
		%branca tem mais pontos
		elseif l_brancas > l_pretas
			jogadores(jogador1).vitorias= jogadores(jogador1).vitorias + 1;
			jogadores(jogador2).derrotas= jogadores(jogador2).derrotas + 1;
			tabela_jogos(jogador1,itens*jogador2-3)= tabela_jogos(jogador1,itens*jogador2-3) + 1;
			tabela_jogos(jogador2,itens*jogador1-1)= tabela_jogos(jogador2,itens*jogador1-1) + 1;
		%preta tem mais pontos
		elseif l_brancas < l_pretas
			jogadores(jogador2).vitorias= jogadores(jogador2).vitorias + 1;
			jogadores(jogador1).derrotas= jogadores(jogador1).derrotas + 1;
			tabela_jogos(jogador1,itens*jogador2-1)= tabela_jogos(jogador1,itens*jogador2-1) + 1;
			tabela_jogos(jogador2,itens*jogador1-3)= tabela_jogos(jogador2,itens*jogador1-3) + 1;
		%empate
		else
			jogadores(jogador1).empates= jogadores(jogador1).empates + 1;
			jogadores(jogador2).empates= jogadores(jogador2).empates + 1;
			tabela_jogos(jogador1,itens*jogador2-2)= tabela_jogos(jogador1,itens*jogador2-2) + 1;
			tabela_jogos(jogador2,itens*jogador1-2)= tabela_jogos(jogador2,itens*jogador1-2) + 1;
		end

		jogadas.num= li;
		jogadas.datetime= datestr(now,0);
		jogadas.partida= tabuleiro;
		jogadas.branca= {jogadores(jogador1).nome 'pt:' l_brancas 'tr:' l_travas_b};
		jogadas.preta= {jogadores(jogador2).nome 'pt:' l_pretas 'tr:' l_travas_p};
		jogadas
	end
	[
		{jogadores(1).nome 'pt:' jogadores(1).marca 'tr:' jogadores(1).travas 'v:' jogadores(1).vitorias 'e:' jogadores(1).empates 'd:' jogadores(1).derrotas}
		{jogadores(2).nome 'pt:' jogadores(2).marca 'tr:' jogadores(2).travas 'v:' jogadores(2).vitorias 'e:' jogadores(2).empates 'd:' jogadores(2).derrotas}
		{jogadores(3).nome 'pt:' jogadores(3).marca 'tr:' jogadores(3).travas 'v:' jogadores(3).vitorias 'e:' jogadores(3).empates 'd:' jogadores(3).derrotas}
		{jogadores(4).nome 'pt:' jogadores(4).marca 'tr:' jogadores(4).travas 'v:' jogadores(4).vitorias 'e:' jogadores(4).empates 'd:' jogadores(4).derrotas}
	]
	l_inicio
	tabela_jogos
	l_fim= ['Fim de Relatorio: ' datestr(now,0)]
end