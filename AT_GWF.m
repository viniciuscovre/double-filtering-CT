function filtrada = AT_GWF(imgG,jan)
% filtro de wiener generalizado (para projeções no domínio de anscombe)

if nargin < 1
    error('Numero insuficiente de argumentos de entrada');
    pause;
elseif nargin == 1
    jan = 3;
elseif nargin > 2
    error('Excedeu o numero de argumentos de entrada');
    pause;
end

alfa = 0.85; %padrão fora do domínio de anscombe: 0.85

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