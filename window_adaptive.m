function vet=window_adaptive(y,jan1,jan2)
%calculo do parametro alpha
jan_alpha = 5;
jan_suav  = 5;
var_y = medida_sinal( y,'variancia',jan_alpha );
ys    = medida_sinal( y,'media',    jan_suav  );
var_g = medida_sinal(ys,'variancia',jan_alpha);
alpha = var_g ./ var_y;
alpha  = min(alpha,1);

% cálculo do gradiente
jan_grad = 7;
for i=1:length(y),
    mn = y(i); 
    ms = y(i);
    for j=1:(round(jan_grad/2)-1),
        if (i-j < 1),
            mn = mn + y(i);
        else
            mn = mn + y(i-j);
        end
        if (i+j > length(y)),
            ms = ms + y(i);
        else
            ms = ms + y(i+j);
        end
    end
    m = y(i);
    %r(i) = (abs(mn - m) - abs(ms - m)) / abs(ms - mn);
    r(i) = abs(mn - ms);
end
r = r ./ max(r);

%lim_alpha = 0.3;  lim_grad  = 0.2;
lim_alpha = 0.04; lim_grad  = 0.03;


for i=1:length(y),
    if alpha(i) < lim_alpha,
        vet(i) = jan2;
    else
        if r(i) < lim_grad,
            vet(i) = jan2;
        else
            vet(i) = jan1;
        end
    end
end

end

