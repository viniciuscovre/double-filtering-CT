function sinogram_g = MAP(sinogram, densidade, jan)
%MAP_PONTUAL calcula o estimador MAP com determinada densidade.
%Pré-filtragem de projeções.
%
%   O primeiro parâmetro é o sinograma das projeções ruidosas. Ao abrir um
%   arquivo .mat no Matlab, uma variável 'sinogram' é criada contendo o
%   sinograma das projeções descritas nesse arquivo.
%
%   O parâmetro "densidade" serve para identificar a densidade desejada
%   para se realizar a estimativa MAP
%
%   jan é a janela, que por padrão é 5
%

if nargin < 1
    error('Numero insuficiente de argumentos de entrada');
    pause
elseif nargin == 1
    denisdade = 'gaussiana';
    jan = 5;
elseif nargin == 2
    jan = 5;
    if strcmp(densidade,'gaussiana') ~= 1
        error('Densidade indisponível. Adotando densidade Gaussiana...');
        denisdade = 'gaussiana';
    end
elseif nargin > 3
    error('Excedeu o numero de argumentos de entrada');
    pause
end

%   l (linhas) recebe a quantidade (tamanho) de linhas da variável
%   'sinogram'. Do mesmo modo para c (colunas).
[l,c]=size(sinogram);
for i=1 : l % i começa 1 e vai até o a qtd de linhas
    
    y = sinogram(i,:);
    
    m = medida_sinal(y,'media',jan); %média
    v = medida_sinal(y,'variancia',jan); %variância
    
    g = (m - v + sqrt((v-m).^2 + 4 .* v .* y))/2; %estimador MAP gaussiano
    
    sinogram_g(i,:) = g;
end
end
