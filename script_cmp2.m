% Script para a comparação de imagens ruidosas com imagens concedidos pela
% EMBRAPA.
% Utilizou-se das medidas PSNR (Peak Signal to Noise Ratio e SSIM
% (Structural SIMilarity)

cd ~/Documents/Vinicius/dados_de_projecao/embrapa

l = dir('*3s.dat');

filtros_pre = {'map_pontual','nlm_pre', 'nlm_PA', 'BM3D_PA', 'wiener', 'wiener_gen_PA',...
    'Wmrf_iso_PA', 'Wmrf_sep_PA'};
filtros_pos = {'nlm_pos', 'BM3D', 'wiener2D', 'wiener_gen', 'Wmrf_iso', 'Wmrf_sep'};

tabela_psnr = struct('nome','', 'map_pontual',.0, 'nlm_pre',.0, 'nlm_PA',.0,...
    'BM3D_PA',.0, 'wiener',.0, 'wiener_gen_PA',.0, 'Wmrf_iso_PA',.0, 'Wmrf_sep_PA',.0,...
    'nlm_pos',.0, 'BM3D',.0, 'wiener2D',.0, 'wiener_gen',.0, 'Wmrf_iso',.0,...
    'Wmrf_sep',.0, 'map_pontual_D_nlm_pos',.0, 'map_pontual_D_BM3D',.0,...
    'map_pontual_D_wiener2D',.0, 'map_pontual_D_wiener_gen',.0, 'map_pontual_D_Wmrf_iso',.0,...
    'map_pontual_D_Wmrf_sep',.0, 'nlm_pre_D_nlm_pos',.0, 'nlm_pre_D_BM3D',.0,...
    'nlm_pre_D_wiener2D',.0, 'nlm_pre_D_wiener_gen',.0, 'nlm_pre_D_Wmrf_iso',.0,...
    'nlm_pre_D_Wmrf_sep',.0, 'nlm_PA_D_nlm_pos',.0, 'nlm_PA_D_BM3D',.0, 'nlm_PA_D_wiener2D',.0,...
    'nlm_PA_D_wiener_gen',.0, 'nlm_PA_D_Wmrf_iso',.0, 'nlm_PA_D_Wmrf_sep',.0,...
    'BM3D_PA_D_nlm_pos',.0, 'BM3D_PA_D_BM3D',.0, 'BM3D_PA_D_wiener2D',.0, 'BM3D_PA_D_wiener_gen',.0,...
    'BM3D_PA_D_Wmrf_iso',.0, 'BM3D_PA_D_Wmrf_sep',.0, 'wiener_D_nlm_pos',.0, 'wiener_D_BM3D',.0,...
    'wiener_D_wiener2D',.0, 'wiener_D_wiener_gen',.0, 'wiener_D_Wmrf_iso',.0,...
    'wiener_D_Wmrf_sep',.0, 'wiener_gen_PA_D_nlm_pos',.0, 'wiener_gen_PA_D_BM3D',.0,...
    'wiener_gen_PA_D_wiener2D',.0, 'wiener_gen_PA_D_wiener_gen',.0, 'wiener_gen_PA_D_Wmrf_iso',.0,...
    'wiener_gen_PA_D_Wmrf_sep',.0, 'Wmrf_iso_PA_D_nlm_pos',.0, 'Wmrf_iso_PA_D_BM3D',.0,...
    'Wmrf_iso_PA_D_wiener2D',.0, 'Wmrf_iso_PA_D_wiener_gen',.0, 'Wmrf_iso_PA_D_Wmrf_iso',.0,...
    'Wmrf_iso_PA_D_Wmrf_sep',.0, 'Wmrf_sep_PA_D_nlm_pos',.0, 'Wmrf_sep_PA_D_BM3D',.0,...
    'Wmrf_sep_PA_D_wiener2D',.0, 'Wmrf_sep_PA_D_wiener_gen',.0, 'Wmrf_sep_PA_D_Wmrf_iso',.0,...
    'Wmrf_sep_PA_D_Wmrf_sep',.0);

tabela_ssim = tabela_psnr;

dp = [22.4 , 34.2 , 17 , 16.2, 30, 13.1]; %Desvio Padrão do ruído da imagem ruidosa
vr = (dp.^2)./255^2; %Variância do ruído da imagem ruidosa

dp_ = [19.3, 13, 19, 8.8, 12.3, 20.9;... %Desvio Padrão do ruído da imagem pré-filtrada
    26.5, 14.2, 26.5, 9.6, 11.3, 30.9;...
    20.3, 19.3, 19.5, 16.3, 19.1, 20.1;...
    15, 7.3, 14.1, 5, 10.8, 15.9;...
    21.6, 9, 18.4, 4, 13, 23.8;...
    11.6, 5.3, 10.3, 5.2, 9.3, 13.3;...
    18.9, 34.4, 21.7, 17.4, 26.4, 18.2;...
    19.3, 34.3, 21.6, 17.4, 25.9, 17];
vr_ = (dp_.^2)./255^2; %Variância do ruído da imagem pré-filtrada

for k=1 : length(l)
    tomog = open_file_proj(l(k).name);
    reconstruida = retroprojecao(tomog);
    reconstruida = im2double(reconstruida);
    
    %tabela_psnr(k).nome = l(k).name;
    aux = strsplit(l(k).name, '.');
    tabela_psnr(k).nome = aux{1};
    tabela_ssim(k).nome = aux{1};
    
    img_ideal = open_file_proj(strrep(l(k).name,'_3s', '_20s'));
    %ao invés de abrir os dados _3s como sendo ideal, abra a _20s
    img_ideal = retroprojecao(img_ideal);
    
    cd ~/Documents/Vinicius/dados_de_projecao/pre
    imwrite(img_ideal, [aux{1} '_ORIGINAL' '.png']);
    cd ~/Documents/Vinicius/dados_de_projecao/pos
    imwrite(img_ideal, [aux{1} '_ORIGINAL' '.png']);
    cd ~/Documents/Vinicius/dados_de_projecao/dupla
    imwrite(img_ideal, [aux{1} '_ORIGINAL' '.png']);
    cd ~/Documents/Vinicius/dados_de_projecao/embrapa
    
    % % %     PRÉ
    [lin,col] = size(reconstruida);
    pre_filt = zeros(lin,col,length(filtros_pre));
    
    h = figure;
    lin_pre = 2;
    col_pre = size(filtros_pre,2);
    col_pre = ceil((col_pre+2)/lin_pre);
    subplot(lin_pre,col_pre,1);
    imshow(img_ideal);
    title('Original');
    subplot(lin_pre,col_pre,2);
    imshow(reconstruida);
    title('Ruidosa');
    
    for i=1 : length(filtros_pre)
        img_filtrada = eval([filtros_pre{i} '(tomog)']);
        img_filtrada = retroprojecao(img_filtrada);
        pre_filt(:,:,i) = img_filtrada; %salva a imagem pré filtrada para usar na dupla filtragem
        tabela_psnr(k).(filtros_pre{i}) = psnr(img_ideal, img_filtrada);
        tabela_ssim(k).(filtros_pre{i}) = ssim(img_ideal, img_filtrada);
        
        subplot(lin_pre,col_pre,i+2);
        imshow(img_filtrada);
        title(filtros_pre{i}, 'Interpreter', 'none');
        
        cd ~/Documents/Vinicius/dados_de_projecao/pre
        imwrite(img_filtrada, [aux{1} '_' filtros_pre{i} '.png']);
        cd ~/Documents/Vinicius/dados_de_projecao/embrapa
        
        clear img_filtrada
    end
    cd ~/Documents/Vinicius/dados_de_projecao/resultados
    print(h,'-dpng', ['PRE_' aux{1} '.png']);
    cd ~/Documents/Vinicius/dados_de_projecao/embrapa
    clear i lin_pre col_pre h
    
    % % %     PÓS
    h = figure;
    lin_pos = 2;
    col_pos = size(filtros_pos,2);
    col_pos = ceil((col_pos+2)/lin_pos);
    subplot(lin_pos,col_pos,1);
    imshow(img_ideal);
    title('Original');
    subplot(lin_pos,col_pos,2);
    imshow(reconstruida);
    title('Ruidosa');
    for j=1 : length(filtros_pos)
        if j == 2 %verifica se é o BM3D
            img_filtrada = eval(['BM3D(' num2str(dp(k)) ',reconstruida)']);
        elseif j == 3 || j == 5 || j == 6
            img_filtrada = eval([filtros_pos{j} '(reconstruida,' num2str(vr(k)) ')']);
        else
            img_filtrada = eval([filtros_pos{j} '(reconstruida)']);
        end
        tabela_psnr(k).(filtros_pos{j}) = psnr(img_ideal, img_filtrada);
        tabela_ssim(k).(filtros_pos{j}) = ssim(img_ideal, img_filtrada);
        
        subplot(lin_pos,col_pos,j+2);
        imshow(img_filtrada);
        title(filtros_pos{j}, 'Interpreter', 'none');
        
        cd ~/Documents/Vinicius/dados_de_projecao/pos
        imwrite(img_filtrada, [aux{1} '_' filtros_pos{j} '.png']);
        cd ~/Documents/Vinicius/dados_de_projecao/embrapa
        
        clear img_filtrada
    end
    cd ~/Documents/Vinicius/dados_de_projecao/resultados
    print(h,'-dpng', ['POS_' aux{1} '.png']);
    cd ~/Documents/Vinicius/dados_de_projecao/embrapa
    clear j lin_pos col_pos h
    
    % % %     DUPLA
    h = figure;
    lin_d = 3;
    col_d = size(filtros_pre,2) * (size(filtros_pos,2)-3);
    col_d = ceil(((col_d+2)/3)/lin_d);
    subplot(lin_d,col_d,1);
    imshow(img_ideal);
    title('Original');
    subplot(lin_d,col_d,2);
    imshow(reconstruida);
    title('Ruidosa');
    cont = 0;
    contif = 0;
    for i=1 : length(filtros_pre)
        for j=1 : length(filtros_pos)
            cont = cont + 1;
            if cont == 8 || cont == 19
                contif = contif + 1;
                cont = -1;
                cd ~/Documents/Vinicius/dados_de_projecao/resultados
                print(h,'-dpng', ['DUPLA_' int2str(contif) '_' aux{1} '.png']);
                cd ~/Documents/Vinicius/dados_de_projecao/embrapa
                h = figure;
            end
            if j == 2 %verifica se é o BM3D
                img_filtrada = eval(['BM3D(' num2str(dp_(i,k)) ',im2double(pre_filt(:,:,i)))']);
            elseif j == 3 || j == 5 || j == 6
                img_filtrada = eval([filtros_pos{j} '(pre_filt(:,:,i),' num2str(vr_(i,k)) ')']);
            else
                img_filtrada = eval([filtros_pos{j} '(pre_filt(:,:,i))']); 
                %uso da imagem pré filtrada salva anteriormente
            end
            string = strcat(filtros_pre{i}, '_D_', filtros_pos{j});
            tabela_psnr(k).(string) = psnr(img_ideal, img_filtrada);
            tabela_ssim(k).(string) = ssim(img_ideal, img_filtrada);
            
            subplot(lin_d,col_d,cont+2);
            imshow(img_filtrada);
            title(string, 'Interpreter', 'none');
            
            cd ~/Documents/Vinicius/dados_de_projecao/dupla
            imwrite(img_filtrada, [aux{1} '_' string '.png']);
            cd ~/Documents/Vinicius/dados_de_projecao/embrapa
            
            clear img_filtrada
        end
    end
    cd ~/Documents/Vinicius/dados_de_projecao/resultados
    print(h,'-dpng', ['DUPLA_3_' aux{1} '.png']);
    cd ~/Documents/Vinicius/dados_de_projecao/embrapa
    clear i j string pre_filt lin_d col_d h cont contif
    
    clear tomog reconstruida img_ideal lin col aux
end
clear filtros_pre filtros_pos l aux k vr vr_ dp dp_