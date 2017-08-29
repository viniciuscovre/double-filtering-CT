function vet_var=window_var(vet,janela,num)
    [lin coln] = size(vet);
    jan2 = round(janela/2) -1;
    i=num;
    media = window_mean(vet,janela,num);
    cont=0; soma=0;
    for j=-jan2:jan2,
       if ((i+j) >= 1) && ((i+j)<=coln),
           soma = soma + ( vet(i+j) - media)^2 ;
           cont=cont+1;
       end;
    end;
    vet_var=soma/(cont -1);
    if vet_var ==0,
        vet_var=0.000001;
    end
    
end
