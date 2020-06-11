function out1 = jv3d_classificacao(p_situacao, p_pino, p_jogador)
    l_pinos_perc= [0 0 0 0 0 0 0 0 0];
    l_pinos_pontos= [0 0 0 0 0 0 0 0 0];
    l_pinos_marca= [0 0 0 0 0 0 0 0 0];
    l_pinos_tira= [0 0 0 0 0 0 0 0 0];
    l_pinos_pos= [0 0 0 0 0 0 0 0 0];
    l_comb= jv3d_combinacoes;
    l_combinacoes= l_comb.comb;
    l_percentagem= l_comb.perc;
	for k = 1:size(l_pinos_perc,2)
        l_soma= abs(p_situacao(k))+abs(p_situacao(k+9))+abs(p_situacao(k+18));
        if l_soma > 2
            l_pinos_perc(k) = -1;
        else
            l_posicao= k+l_soma*9;
            l_size= size(l_combinacoes);
            l_pontos= 0;
            l_marca= 0;
            l_tira= 0;
            l_grau= 0;
			for i = 1:l_size(1)
                cb1= l_combinacoes(i,1);
                cb2= l_combinacoes(i,2);
                cb3= l_combinacoes(i,3);
                l_tem= ((cb1==l_posicao)||(cb2==l_posicao)||(cb3==l_posicao));
                if l_tem
                    pri= p_situacao(cb1);
                    seg= p_situacao(cb2);
                    ter= p_situacao(cb3);
                    %v= [i l_posicao cb1 pri cb2 seg cb3 ter]
                    
                    %l_indice= 3-abs(pri+seg+ter);
                    %l_qtdelem= (abs(pri)+abs(seg)+abs(ter));
                    %l_indice= (l_indice+l_qtdelem)*l_indice;
                    %multiplica a quantidade de elementos por dois e soma
                    %com o somatório dos valores dos elementos multiplicado
                    %pelo valor do jogador(1 ou -1)
                    l_indice= ((abs(pri)+abs(seg)+abs(ter))*2)+((pri+seg+ter)*p_jogador);
					%vvv.i= i;
					%vvv.ind= l_indice;
					%vvv.pos= l_posicao;
					%vvv.comb= [cb1 cb2 cb3];
					%vvv
                    %jogador marca pontos
                    if l_indice == 6
                        l_grau= l_grau + l_percentagem(l_posicao)*4;%(l_percentagem(cb1)+l_percentagem(cb2)+l_percentagem(cb3));
                        l_pontos= l_pontos + 1;
                        l_marca= l_marca + 1;
                    %tira pontos do oponente
                    elseif l_indice == 2
                        l_grau= l_grau + l_percentagem(l_posicao)*3.9;%(l_percentagem(cb1)+l_percentagem(cb2)+l_percentagem(cb3));
                        l_pontos= l_pontos + 1;
                        l_tira= l_tira + 1;
                    %é a segunda peca sua pra marcacao dos pontos
                    elseif l_indice == 3
                        l_grau= l_grau + l_percentagem(l_posicao)/4;%(l_percentagem(cb1)+l_percentagem(cb2)+l_percentagem(cb3))/4;
                    %é a primeira peca pra marcacao dos pontos
                    elseif l_indice == 0
                        l_grau= l_grau + l_percentagem(l_posicao)/16;%(l_percentagem(cb1)+l_percentagem(cb2)+l_percentagem(cb3))/16;
                    %o oponente já tem uma peça na reta de marcação e vc
                    %está colocando a segunda
                    elseif l_indice == 1
                        l_grau= l_grau - l_percentagem(l_posicao)/16;%(l_percentagem(cb1)+l_percentagem(cb2)+l_percentagem(cb3))/2;
                    %cada jogador tem uma peça nesta reta de marcação e vc
                    %está colocando a terceira
                    elseif l_indice == 4
                        l_grau= l_grau - l_percentagem(l_posicao)/8;%(l_percentagem(cb1)+l_percentagem(cb2)+l_percentagem(cb3));%/32;
                    end
                end
			end
			%out1=1;
			%l_grau
			%return;
            l_pinos_perc(k)= l_grau;
            l_pinos_pontos(k)= l_pontos;
            l_pinos_marca(k)= l_marca;
            l_pinos_tira(k)= l_tira;
            l_pinos_pos(k)= l_posicao;
        end
	end
    for j = 1:size(l_pinos_perc,2)
        if l_pinos_perc(j) == -1
            l_pinos_perc(j) = -max(max(l_pinos_perc),1);
        end    
    end
    l_pinos_perc= l_pinos_perc/max(max(l_pinos_perc),1);
    out1.erro= 0;
    out1.erro_msg= 'ok';
    out1.pino= p_pino;
    out1.perc= l_pinos_perc(p_pino);
    out1.pontos= l_pinos_pontos(p_pino);
    out1.marca= l_pinos_marca(p_pino);
    out1.tira= l_pinos_tira(p_pino);
    out1.pos= l_pinos_pos(p_pino);   
    out1.pinos_perc= l_pinos_perc;
    out1.pinos_pontos= l_pinos_pontos;
    out1.pinos_marca= l_pinos_marca;
    out1.pinos_tira= l_pinos_tira;
    out1.pinos_pos= l_pinos_pos;
    out1.situacao= p_situacao;
    if l_pinos_pos(p_pino) ~= 0
        out1.situacao(l_pinos_pos(p_pino))= p_jogador;
    else
        out1.erro= 1;%erro: pino cheio
        out1.erro_msg= 'pino cheio';
    end