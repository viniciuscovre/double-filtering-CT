function filtrada = GWF(imgG,jan)
%filtro de wiener generalizado (para imagens pós-construídas)

if nargin < 1
    error('Numero insuficiente de argumentos de entrada');
    pause;
elseif nargin == 1
    jan = 3;
elseif nargin > 2
    error('Excedeu o numero de argumentos de entrada');
    pause;
end

% imgF = nlm_pos(imgG);
alfa = 0.85;

[l,c]=size(imgG);
d = floor(jan/2); %d = deslocamento

%cria a máscara do tamanho [jan jan] para um filtro da média ('average')
mean_filt = fspecial('average', [jan jan]);
imgF = imfilter(imgG, mean_filt);

mf = imfilter(imgF, mean_filt); %media da imagem filtrada
mg = imfilter(imgG, mean_filt); %media da imagem ruidosa
vr = 22.2^2/255^2; %variancia do ruido % == 1 para trans ansc
ac_vf = zeros(l,c); %ac_vf = acumulador para a variância da imagem filtrada
ac_gKL = zeros(l,c);

for i = -d : d
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
end
vf = ac_vf/((jan*jan)-1); % n = jan*jan (fórmula da variância)
%equação 5.13 da tese do Denis:
filtrada = mf + (vf./(vf+vr)).*((alfa*(imgG-mf)) + ((1-alfa)*ac_gKL));
end