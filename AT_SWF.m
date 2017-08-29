function filtrada = AT_SWF(imgG, jan, dominio)
%WIENER_MRF filtragem pré reconstrução da imagem (filtro Pós no domínio de
% Anscombe)
%
%   DESCRIÇÃO: Um filtro de sinal no domínio da imagem, baseado no famoso
%              filtro de Wiener, mas em Campos Aleatórios Markovianos.
%              Trata-se do filtro de Wiener com MRF Separável. Essa é a
%              versão adaptada para filtragem no domínio das projeções,
%              onde os dados de projeção são alterados pela Transfomrada de
%              Anscombe de modo a obter distribuição gaussiana de ruído.
%   PARÂMETROS:
%               imgG - Imagem ruidosa reconstruída.
%               sigma2v - Variância do ruído da imagem ruidosa.
%               dominio - Domínio da mudança de base dos dados.
%   RETORNO:
%            filtrada - Imagem filtrada pelo filtro de Wiener MRF Separável

if nargin > 3 || nargin < 1
    error('Número inválido de argumentos de entrada!');
    pause
elseif nargin == 1
    jan = 3;
    dominio = 'ansc';
else
    dominio = 'ansc';
end

sigma2v = 1;

% %cria a máscara do tamanho [jan jan] para um filtro da média ('average')
% mean_filt = fspecial('average', [1 jan]);
% imgF = imfilter(imgG, mean_filt);

[l,c]=size(imgG);
pad = floor(jan/2);

for k=1 : l
    imgF(k,:) = medida_sinal(imgG(k,:),'media',jan);
end
clear k;

%CÁLCULO DAS MÉDIAS POR MEDIDA_SINAL
for k=1 : l
    mf(k,:) = medida_sinal(imgF(k,:),'media',jan);
end
clear k;
for k=1 : l
    mg(k,:) = medida_sinal(imgG(k,:),'media',jan);
end
%FIM DESSE CÁLCULO

% M = max(imgG(:));
% m = min(imgG(:));
% imgG = ((imgG-m)/(M-m))*255;
% 
% M_ = max(imgF(:));
% m_ = min(imgF(:));
% imgF = ((imgF-m_)/(M_-m_))*255;
% 
% M = max(M,M_);
% m = min(m,m_);

acumulador = zeros(l,c);

i = 0;
for j = -pad : pad
    deslocada = circshift(imgF, [i j]);
    diferenca = (deslocada - mf).^2;
    acumulador = acumulador + diferenca;
end
vf = acumulador/((jan^2)-1); % n = jan*jan (fórmula da variância)

imgG = padarray(imgG, [pad pad], 'symmetric');
vf = padarray(vf, [pad pad], 'symmetric');
mf = padarray(mf, [pad pad], 'symmetric');

ro = 0.95; % roV = roH

% Cálculo dos pesos para Rgg
pesos_rgg = zeros(jan^2, jan^2);
Ai=0; %Acumulador de linhas
for I = 1 : jan
    for J = 1 : jan
        Ai = Ai + 1;
        Aj = 0;%Acumulador de colunas
        for i = 1 : jan
            for j = 1 : jan
                Aj = Aj+1;
                pesos_rgg(Ai,Aj) = ro^abs(I-i) * ro^abs(J-j);
            end
        end
    end
end

pesos_rff = pesos_rgg(ceil(jan^2/2),:)'; %linha central de Rgg equivale aos pesos de Rff

for i = pad+1 : l+pad
    for j = pad+1 : c+pad
        
        patch = imgG(i-pad : i+pad, j-pad : j+pad) - mf(i-pad : i+pad, j-pad : j+pad); % Define o patch
        
        % Cálculo de Rgg
        Rgg = vf(i,j)*pesos_rgg;
        diag_princ = vf(i,j) * ones(jan^2, 1) + sigma2v; % sigma2v = 1 no domínio de Anscombe
        Rgg = Rgg - diag(diag(Rgg)) + diag(diag_princ); % seta a diagonal principal
        
        % Cálculo de Rff
        Rff = vf(i,j) * pesos_rff;
        
        % Cálculo de 'a'
        a = Rgg\Rff;
        
        filtrada(i-pad, j-pad) = mf(i,j) + sum(patch(:) .* a(:));
    end
end
filtrada(vf == 0) = imgF(vf == 0);
% filtrada = filtrada * (M-m)/255 + m;
filtrada = noise_transform(filtrada, [dominio '_inverse']);
end