function vet = medida_sinal(sinal,tipo,jan)

    if length(jan) > 1,
        janela = window_adaptive(sinal,jan(1),jan(2));
    else
        janela(1:length(sinal)) = jan;
    end
    for i=1:length(sinal),    
        switch tipo,
            case 'media', vet(i) = window_mean(sinal,janela(i),i);
            case 'variancia', vet(i) = window_var(sinal,janela(i),i);
        end
    end

end

