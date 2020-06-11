function jv3d_jogo

    S = load('jv3d_rna1_ff_27_49_9');
	rna1= S.rna1;
    S = load('jv3d_rna2_ff_27_49_9');
	rna2= S.rna2;

	jogadores= {'R2D2' 'Você'
				'Você' 'C3PO'
				'R2D2' 'C3PO'
				'C3PO' 'Você'
				'Você' 'R2D2'
				'C3PO' 'R2D2'};
	BoxX= 90;
    BoxY= 90;
    
    %cria janela
    HFIG = figure('Name','Jogo da Velha 3D - Pinos','Numbertitle','off','Menubar','none',...
        'Color',[0.831373 0.815686 0.784314],'Resize','on','DoubleBuffer','on',...
        'Position',[150,150,400,400],'CloseRequestFcn',@jv3d_sair,...
        'KeyPressFcn',@jv3d_keypressed);
    % cria scores
    score1  = uicontrol('Units','normalized','Position',[.05,.0,.4,.05],...
        'Style','text','HorizontalAlignment','Left','FontWeight','bold',...
        'BackgroundColor',[1,1,1],'ForegroundColor',[0,0,0],'FontSize',12);
    score2  = uicontrol('Units','normalized','Position',[0.55,.0,.4,.05],...
        'Style','text','HorizontalAlignment','Left','FontWeight','bold',...
        'BackgroundColor',[0,0,0],'ForegroundColor',[1,1,1],'FontSize',12);
    %HMODE = uicontrol('Units','normalized','Position',[0.1,0.7,.8,.1],...
    %    'Style','text','FontSize',14,'BackgroundColor',[1,0,0]);
    
    %status do jogo: S - sem jogo, J - jogo em andamento
    status= 'S';
	modo= '0';
    %inicializa o jogo
    jv3d_inicializa;
    jogo= jv3d_config;
    
    function jv3d_keypressed(src,event)
        switch event.Character
            case {'n','N'}
				modo= jv3d_escolhe_modo;
				if modo ~= '0'
	                jv3d_inicializa;
		            status = 'J';
			        jv3d_partida;
				end
			case {'r','R'}
				if modo ~= '0'
	                jv3d_inicializa;
		            status = 'J';
			        jv3d_partida;
				end
            case {'i','I'}
                jv3d_info;
            case {'s','S'}
                jv3d_sair;
            case {'c','C'}
                jv3d_abortar_partida;
        end
    end

    function jv3d_sair(src,evnt)
        drawnow;
        closereq;
    end

    function jv3d_inicializa
        cla;
        jv3d_tabuleiro;
		jv3d_set_score(0,0);
        jogo= jv3d_config;
	end
	
	function jv3d_set_score(p_score1, p_score2)
        jv3d_set_score1(p_score1);
		jv3d_set_score2(p_score2);
	end

	function jv3d_set_score1(p_score1)
		l_score= 'Score:';
		if modo ~= '0'
			l_score= strcat(jogadores(str2double(modo),1), ':');
		end
		set(score1,'String',strcat(l_score, num2str(p_score1)));
	end

	function jv3d_set_score2(p_score2)
		l_score= 'Score:';
		if modo ~= '0'
			l_score= strcat(jogadores(str2double(modo),2), ':');
		end
		set(score2,'String',strcat(l_score, num2str(p_score2)));
	end

    function jv3d_info
        info= {
            'Teclas:'
            'i,I - estas informações'
            'n,N - inicia jogo'
			'r,R - Jogar Novamente'
            's,S - sai do jogo'
            };
		msgbox(info,'Informações');
    end
    
    function jv3d_peca(p_jogador, p_peca)
        peca_cor= (1+(p_jogador*0.57))/2;
        l_posicoes= jv3d_posicoes;
        l_x= l_posicoes.pos2d(p_peca,1);
        l_y= l_posicoes.pos2d(p_peca,2);
        %['peca_',int2str(p_peca)]
        rectangle('Position',[l_x,l_y,10,10],'FaceColor',[peca_cor,peca_cor,peca_cor],'Tag','peca_1');%['peca_',int2str(p_peca)]);
        %uicontrol('Units','normalized','Position',[.0,.0,.3,.3],...
        %'Style','text','HorizontalAlignment','Left','FontWeight','bold',...
        %'BackgroundColor',[peca_cor,peca_cor,peca_cor],'ForegroundColor',[1-peca_cor,1-peca_cor,1-peca_cor],'FontSize',12,'Tag',['peca_',int2str(p_peca)]);
    end

    function jv3d_tabuleiro
        axes('Units','normalized','Position', [.05 .06 .9 .93],'Visible','on',...
            'DrawMode','fast','NextPlot','replace','XLim',[1,BoxX-1],'YLim',[1,BoxY]);
        set(line([1,BoxX-1,BoxX-1,1,1],[1,1,BoxY,BoxY,1]),'Color',[0,0,0]);
        set(line([30 30],[0 90]),'Color',[0,0,0]);
        set(line([60 60],[0 90]),'Color',[0,0,0]);
        set(line([0 90],[30 30]),'Color',[0,0,0]);
        set(line([0 90],[60 60]),'Color',[0,0,0]);
    end

    function jv3d_partida
		jogo.jogador = 1;
        for i = 1:12
			if status == 'S'
				break;
			end

			%vez da rede neural 1 ou 2 jogar como jogador 1----------------
			if modo == '1' || modo == '3' || modo == '4' || modo == '6'
				if modo == '1' || modo == '3'
					l_rna1= rna1;
				else
					l_rna1= rna2;
				end
				retorno= jv3d_rna_joga(l_rna1, jogo.tabuleiro, jogo.max_tentativas, 1);
				if retorno.erro.cod ~= 0
				   retorno.erro
				   jv3d_abortar_partida;
				   msgbox(strcat(jogadores(str2double(modo),1),' entrou em curto'),'Informações');
				   %return;
				end
				%retorno
				jogo.pontuacao.brancas= jogo.pontuacao.brancas + retorno.marca;
				jogo.tabuleiro= retorno.situacao;
				if modo == '1' || modo == '3'
					rna1= retorno.rna;
					save('jv3d_rna1_ff_27_49_9','rna1');
				else
					rna2= retorno.rna;
					save('jv3d_rna2_ff_27_49_9','rna2');
				end
				jv3d_set_score1(jogo.pontuacao.brancas);
				jv3d_peca(1,retorno.pos);
				jogo.jogador = -1;
				drawnow;
			end
			if status == 'S'
				break;
			end
			
			%vez do humano jogar-------------------------------------------
			if modo == '1' || modo == '2' || modo == '4' || modo == '5'
				while ((modo=='1' || modo=='4') && jogo.jogador == -1) || ((modo=='2' || modo=='5') && jogo.jogador == 1)
					if status == 'S'
						break;
					end
					str = {'1 - Um' '2 - Dois' '3 - Três' '4 - Quatro' '5 - Cinco' '6 - Seis' '7 - Sete' '8 - Oito' '9 - Nove'};
					[s,v] = listdlg('PromptString','Escolha uma pino para colocar a peça:',...
					'SelectionMode','single','ListString',str);
					if (v == 1)
						l_retorno= jv3d_classificacao(jogo.tabuleiro,s,jogo.jogador);
						%retorno
						if l_retorno.erro == 0
							if jogo.jogador == -1
								jogo.pontuacao.pretas= jogo.pontuacao.pretas + l_retorno.marca;
								jv3d_set_score2(jogo.pontuacao.pretas);
							else
								jogo.pontuacao.brancas= jogo.pontuacao.brancas + l_retorno.marca;
								jv3d_set_score1(jogo.pontuacao.brancas);
							end
							jogo.tabuleiro= l_retorno.situacao;
							jv3d_peca(jogo.jogador,l_retorno.pos);
							jogo.jogador= jogo.jogador*(-1);
						end
					end
				end
				drawnow;
			end
			if status == 'S'
				break;
			end

			%vez da rede neural 1 ou 2 jogar como jogador 2----------------
			if modo == '2' || modo == '3' || modo == '5' || modo == '6'
				if modo == '2' || modo == '3'
					l_rna2= rna2;
				else
					l_rna2= rna1;
				end
				retorno= jv3d_rna_joga(rna2, jogo.tabuleiro, jogo.max_tentativas, -1);
				if retorno.erro.cod ~= 0
				   retorno.erro
				   jv3d_abortar_partida;
				   msgbox(strcat(jogadores(str2double(modo),2),' entrou em curto'),'Informações');
				   %return;
				end
				%retorno
				jogo.pontuacao.pretas= jogo.pontuacao.pretas + retorno.marca;
				jogo.tabuleiro= retorno.situacao;
				if modo == '2' || modo == '3'
					rna2= retorno.rna;
					save('jv3d_rna2_ff_27_49_9','rna2');
				else
					rna1= retorno.rna;
					save('jv3d_rna1_ff_27_49_9','rna1');
				end
				jv3d_set_score2(jogo.pontuacao.pretas);
				jv3d_peca(-1,retorno.pos);
				jogo.jogador = 1;
				drawnow;
			end
        end
        jogadas.partida= jogo.tabuleiro;
        jogo.pontuacao
		jv3d_abortar_partida;
    end
    function jv3d_abortar_partida
        status = 'S';
	end
	%function jv3d_carrega_rna1
		%load jv3d_rna1_ff_27_49_9;
	%end
	function ret= jv3d_escolhe_modo
		str = {'R2D2 x Você' 'Você x C3PO' 'R2D2 x C3PO'...
			'C3PO x Você' 'Você x R2D2' 'C3PO x R2D2'};
		[s,v] = listdlg('PromptString','Escolha uma opção de jogo:','SelectionMode','single','ListString',str);
		if (v == 1)
			ret= num2str(s);
		else
			ret= '0';
		end
	end
end