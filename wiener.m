 function filtrada = wiener(imgG,jan,dominio)
%FILTRO_DE_WIENER filtragem pré ou pós reconstrução da imagem
%
%       O primeiro parâmetro é o sinograma das projeções ruidosas, no caso
%   do uso do wiener para pré-reconstrução. Ao abrir um arquivo .mat no
%   Matlab, uma variável 'sinogram' é criada contendo o sinograma das
%   projeções descritas nesse arquivo.
%       Para o caso do uso desse filtro para pós-reconstrução, o primeiro
%   parâmetro é a imagem reconstruída.
%
%       O parâmetro pre_pos indica se o uso do filtro de wiener é para a
%   filtragem pré ou pós reconstrução dos dados de projeção.
%
%       O parâmetro 'dominio' costuma ser 'ansc', pela filtragem ser  no
%   domínio de Anscombe, uma vez que o filtro de Wiener trata de ruído
%   aditivo. Mas essa observação só é válida caso a filtragem seja
%   pré-reconstução dos dados de projeção

%l (linhas) recebe a quantidade (tamanho) de linhas da variável
%'sinogram'. Do mesmo modo para c (colunas).

if nargin > 3 || nargin < 1
    error('Número inválido de argumentos de entrada!');
    pause
elseif nargin == 1
    jan = 5;
    dominio = 'ansc';
else
    dominio = 'ansc';
end

mean_filt = fspecial('average', [1 jan]);
imgF = imfilter(imgG, mean_filt);

alfa = 1; %padrão fora do domínio de anscombe: 0.85

imgG = noise_transform(imgG,'ansc');

[l,c]=size(imgG);
d = floor(jan/2); %d = deslocamento

% % mean_filt = fspecial('average', [1 jan]);
% % imgF = imfilter(imgG, mean_filt);

for k=1 : l
    imgF(k,:) = medida_sinal(imgG(k,:),'media',jan);
end
clear k;

% M = max(imgG(:));
% m = min(imgG(:));
% imgG = ((imgG-m)/(M-m))*255;
%
% M_ = max(imgF(:));
% m_ = min(imgF(:));
% imgF = ((imgF-m_)/(M_-m_))*255;

% M = max(M,M_);
% m = min(m,m_);

%CÁLCULO DAS MÉDIAS POR MEDIDA_SINAL
for k=1 : l
    mf(k,:) = medida_sinal(imgF(k,:),'media',jan);
end
clear k;
for k=1 : l
    mg(k,:) = medida_sinal(imgG(k,:),'media',jan);
end
%FIM DESSE CÁLCULO

vr = 1; %variancia do ruido == 1 para trans ansc
ac_vf = zeros(l,c); %ac_vf = acumulador para a variância da imagem filtrada
ac_gKL = zeros(l,c);

i = 0;
for j = -d : d
    deslocadaF = circshift(imgF, [i j]);
    dif_vf = (deslocadaF - mf).^2;
    ac_vf = ac_vf + dif_vf;
    
    deslocadaG = circshift(imgG, [i j]);
    if (i==0 && j==0)
        continue;
    end
    dif_gKL = (deslocadaG - mg);
    ac_gKL = ac_gKL + dif_gKL;
end

clear i
for i=1 : l
    vf = medida_sinal(imgF(i,:),'variancia',jan); % n = jan*jan (fórmula da variância)
    %Equação 5.13 da tese do Denis:
    filtrada(i,:) = mf(i,:) + (vf./(vf+vr)).*((alfa*(imgG(i,:)-mf(i,:))) + ((1-alfa)*ac_gKL(i,:)));
    % % filtrada = ((filtrada-min(filtrada(:)))/(max(filtrada(:))-min(filtrada(:))))*255;
    % filtrada = filtrada * (M-m)/255 + m;
end
filtrada = noise_transform(filtrada,'ansc_inverse');
end