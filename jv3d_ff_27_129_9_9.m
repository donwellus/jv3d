function out = jv3d_ff_27_129_9_9()
    %cria um vetor para formatar input
    %são 27 neurônios podendo receber os valores -1 0 ou 1

    entrada = [
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1
        ];
    saida = [
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1;
            -1 1
        ];
    %t = [-1 -1 1 1];
    %cria a rede com 27 entradas 9 saidas uma camada oculta 129
    %27 -> 49 -> 9 conexão plena entre camadas-compet
    net1 = newff(entrada,saida,[129,9],{'tansig','tansig'});
%     net1.IW{1}= ones(49,27);
%     net1.LW{2}= ones(9,49);
%     net1.b{1}= ones(49,1);
%     net1.b{2}= ones(9,1);
    %net1.trainFcn = 'trainr';
    %net1.adaptFcn = 'trains';
    %net1.inputWeights{1,1}.learnFcn = 'learnh';
% 	net1.inputWeights{2,1}.learnFcn = 'learnh';
% 	net1.layerWeights{1,1}.learnFcn = 'learnh';
% 	net1.layerWeights{2,1}.learnFcn = 'learnh';
% 	net1.layerWeights{1,2}.learnFcn = 'learnh';
% 	net1.layerWeights{2,2}.learnFcn = 'learnh';
% 	net1.biases{1}.learnFcn = 'learnh';
% 	net1.biases{2}.learnFcn = 'learnh';
	net1.adaptParam.passes = 30;
    %net1.divideFcn = '';
    net1.trainParam.showWindow = 0;
    %net1.trainParam.show = 50;
    %net1.trainParam.lr = 0.015;
    net1.trainParam.epochs = 1;
    %net1.trainParam.goal = 1e-5;
    %[net1,tr]=train(net1,p,t);
    %a = sim(net1,p);
    %a
    out = net1;