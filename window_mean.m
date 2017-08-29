function vet_media=window_mean(vet,janela,num)
    i = num;
    cont = 0; 
    media = 0;
    janela = round(janela/2) -1;
    [lin col] = size(vet);
    for j=-janela:janela,
        if ((i+j) >= 1) && ((i+j)<=col),
            media= media + vet(i+j);
            cont= cont+1;
        end;
    end;
    vet_media =media / cont;
end