function out = jv3d_config()
    out.tabuleiro = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    out.jogador = 1;
    out.max_tentativas = 20;
    out.partidas = 1;
    out.pontuacao.brancas = 0;
    out.pontuacao.pretas = 0;
	%out.jogadores(1).name = '';
	%out.jogadores(1).pontos = 0;
	%out.jogadores(2).name = '';
	%out.jogadores(2).pontos = 0;
end