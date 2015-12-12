function filtrada = wiener2D(imgG, vr, jan)
% filtro de wiener para imagens pós-reconstrução

if nargin < 1
    error('Numero insuficiente de argumentos de entrada');
    pause;
elseif nargin == 1
    vr = 22.2;
    jan = 3;
elseif nargin == 2
    jan = 3;
elseif nargin > 3
    error('Excedeu o numero de argumentos de entrada');
    pause;
end

imgF = nlm_pos(imgG);

[l,c]=size(imgG);
d = floor(jan/2); %d = deslocamento

%cria a máscara do tamanho [jan jan] para um filtro da média ('average')
mean_filt = fspecial('average', [jan jan]);

mf = imfilter(imgF, mean_filt); %media da imagem filtrada
mg = imfilter(imgG, mean_filt); %media da imagem ruidosa
%vr = vr/255^2; %variancia do ruido % vr = 22.2/255^2;
acumulador = zeros(l,c);

for i = -d : d
    for j = -d : d
        deslocada = circshift(imgF, [i j]);
        diferenca = (deslocada - mf).^2;
        acumulador = acumulador + diferenca;
    end
end
vf = acumulador/((jan*jan)-1); % n = jan*jan (fórmula da variância)
filtrada = mf+ (vf./(vf+vr)).*(imgG-mf); %equação 5.3 da tese do Denis
end