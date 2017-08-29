l = dir('*3s.dat');

filtrosPre = {'AT_BM3D', 'AT_GWF', 'AT_IWF', 'AT_NLM', 'AT_SWF', 'MAP', 'P_NLM', 'PWF_1D'};
filtrosPos = {'NLM', 'BM3D', 'PWF_2D', 'GWF', 'IWF', 'SWF'};

tabelaPSNR = struct('nome','',...
    'AT_BM3D',.0, 'AT_GWF',.0, 'AT_IWF',.0,'AT_NLM',.0,...
    'AT_SWF',.0, 'MAP',.0, 'P_NLM',.0, 'PWF_1D',.0,... //filtrosPre
    ...
    'NLM',.0, 'BM3D',.0, 'PWF_2D',.0, 'GWF',.0, 'IWF',.0,'SWF',.0,... //filtrosPos
    ...
    'AT_BM3D_D_NLM',.0, 'AT_BM3D_D_BM3D',.0, 'AT_BM3D_D_PWF_2D',.0,...
    'AT_BM3D_D_GWF',.0, 'AT_BM3D_D_IWF',.0, 'AT_BM3D_D_SWF',.0,... //AT_BM3D x Pos
    ...
    'AT_GWF_D_NLM',.0, 'AT_GWF_D_BM3D',.0, 'AT_GWF_D_PWF_2D',.0,...
    'AT_GWF_D_GWF',.0, 'AT_GWF_D_IWF',.0, 'AT_GWF_D_SWF',.0,... //AT_GWF x Pos
    ...
    'AT_IWF_D_NLM',.0, 'AT_IWF_D_BM3D',.0, 'AT_IWF_D_PWF_2D',.0,...
    'AT_IWF_D_GWF',.0, 'AT_IWF_D_IWF',.0, 'AT_IWF_D_SWF',.0,... //AT_IWF x Pos
    ...
    'AT_NLM_D_NLM',.0, 'AT_NLM_D_BM3D',.0, 'AT_NLM_D_PWF_2D',.0,...
    'AT_NLM_D_GWF',.0, 'AT_NLM_D_IWF',.0, 'AT_NLM_D_SWF',.0,... //AT_NLM x Pos
    ...
    'AT_SWF_D_NLM',.0, 'AT_SWF_D_BM3D',.0, 'AT_SWF_D_PWF_2D',.0,...
    'AT_SWF_D_GWF',.0, 'AT_SWF_D_IWF',.0, 'AT_SWF_D_SWF',.0,... //AT_SWF x Pos
    ...
    'MAP_D_NLM',.0, 'MAP_D_BM3D',.0, 'MAP_D_PWF_2D',.0,...
    'MAP_D_GWF',.0, 'MAP_D_IWF',.0, 'MAP_D_SWF',.0,... //MAP x Pos
    ...
    'P_NLM_D_NLM',.0, 'P_NLM_D_BM3D',.0, 'P_NLM_D_PWF_2D',.0,... 
    'P_NLM_D_GWF',.0, 'P_NLM_D_IWF',.0, 'P_NLM_D_SWF',.0,... //P_NLM x Pos
    ...
    'PWF_1D_D_NLM',.0, 'PWF_1D_D_BM3D',.0, 'PWF_1D_D_PWF_2D',.0,...
    'PWF_1D_D_GWF',.0, 'PWF_1D_D_IWF',.0, 'PWF_1D_D_SWF',.0... // PWF_1D x Pos
    );

tabelaSSIM = tabelaPSNR;

% Desvio Padrão do ruído da imagem ruidosa
dp = [22.4 , 34.2 , 17 , 16.2, 30, 13.1];
% Variância do ruído da imagem ruidosa
vr = (dp.^2)./255^2;

% Desvio Padrão do ruído da imagem pré-filtrada
dp_ = [19.3, 13, 19, 8.8, 12.3, 20.9;...
    26.5, 14.2, 26.5, 9.6, 11.3, 30.9;...
    20.3, 19.3, 19.5, 16.3, 19.1, 20.1;...
    15, 7.3, 14.1, 5, 10.8, 15.9;...
    21.6, 9, 18.4, 4, 13, 23.8;...
    11.6, 5.3, 10.3, 5.2, 9.3, 13.3;...
    18.9, 34.4, 21.7, 17.4, 26.4, 18.2;...
    19.3, 34.3, 21.6, 17.4, 25.9, 17];
% Variância do ruído da imagem pré-filtrada
vr_ = (dp_.^2)./255^2;

for k=1 : length(l)
    % Abre as projeções e imagens reconstruídas
    tomog = open_file_proj(l(k).name);
    reconstruida = fbp(tomog);
    reconstruida = im2double(reconstruida);
    
    % Coloca os nomes nas tabelas
    aux = strsplit(l(k).name, '.');
    tabelaPSNR(k).nome = aux{1};
    tabelaSSIM(k).nome = aux{1};
    
    imgIdeal = open_file_proj(strrep(l(k).name,'_3s', '_20s'));
    % ao invés de abrir os dados _3s como sendo ideal, abra a _20s
    imgIdeal = fbp(imgIdeal);
    
    cd images/pre
    imwrite(imgIdeal, [aux{1} '_ORIGINAL' '.png']);
    cd ../post
    imwrite(imgIdeal, [aux{1} '_ORIGINAL' '.png']);
    cd ../double
    imwrite(imgIdeal, [aux{1} '_ORIGINAL' '.png']);
    cd ../..
    
    % % %     PRÉ
    [lin,col] = size(reconstruida);
    preFilt = zeros(lin,col,length(filtrosPre));
    
    h = figure;
    linPre = 2;
    colPre = size(filtrosPre,2);
    colPre = ceil((colPre+2)/linPre);
    subplot(linPre,colPre,1);
    imshow(imgIdeal);
    title('Original');
    subplot(linPre,colPre,2);
    imshow(reconstruida);
    title('Ruidosa');
    
    for i=1 : length(filtrosPre)
        imgFiltrada = eval([filtrosPre{i} '(tomog)']);
        imgFiltrada = fbp(imgFiltrada);
        preFilt(:,:,i) = imgFiltrada; %salva a imagem pré filtrada para usar na dupla filtragem
        tabelaPSNR(k).(filtrosPre{i}) = psnr(img_ideal, imgFiltrada);
        tabelaSSIM(k).(filtrosPre{i}) = ssim(img_ideal, imgFiltrada);
        
        subplot(lin_pre,col_pre,i+2);
        imshow(imgFiltrada);
        title(filtrosPre{i}, 'Interpreter', 'none');
        
        cd images/pre
        imwrite(imgFiltrada, [aux{1} '_' filtrosPre{i} '.png']);
        cd ../..
        
        clear imgFiltrada
    end
    cd images/results
    print(h,'-dpng', ['PRE_' aux{1} '.png']);
    cd ../..
    clear i lin_pre col_pre h
end
