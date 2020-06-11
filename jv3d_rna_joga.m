function out = jv3d_rna_joga(p_rna, p_tabuleiro, p_max_tentativas, p_jogador)
    tem_erro = 1;
    tentativas = 0;
    out.erro.cod = 0;
    out.erro.msg = 'ok';
    out.erro.debug = '';
    while tem_erro ~= 0
        [sY1,sPf1,sAf1,sE1,sperf1] = sim(p_rna, jv3d_situacao(p_tabuleiro',p_jogador));
        [valor1,indice1] = max(sY1);
        classificacao1= jv3d_classificacao(p_tabuleiro, indice1, p_jogador);
        [p_rna,Y1,E1,Pf1,Af1] = adapt(p_rna,jv3d_situacao(p_tabuleiro',p_jogador),classificacao1.pinos_perc');
        %E1
        tem_erro = classificacao1.erro;
        if tem_erro ~= 0
            tentativas= tentativas + 1;
        end
        if tentativas > p_max_tentativas
            out.erro.cod = 1;
            out.erro.msg = 'erro de loop infinito';
			out.erro.jogador = p_jogador;
            out.erro.debug = classificacao1;
            break;
        end
    end
    out.pontos= classificacao1.pontos;
    out.marca= classificacao1.marca;
    out.tira= classificacao1.tira;
    out.pos= classificacao1.pos;
    out.situacao= classificacao1.situacao;
    out.rna= p_rna;