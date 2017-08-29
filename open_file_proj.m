function tomog = open_file_proj(path)

    if path ~= 0;
        arq = path;
    else
        
        [nome,path]=uigetfile('*.dat','Abrir arquivo de projeções *.dat');
        arq = strcat(path,nome);
    end

    FP=fopen(arq,'r');
    
    LINE=fgets(FP);
    proj = 0;
    while LINE~=-1, 
       if LINE(1)~='#',
          x=str2num(LINE);
          if proj == 0
             proj = x;
          else
             proj=[proj;x];
          end
       end
       LINE=fgets(FP);
    end 
    
    fclose(FP);
    tomog= double(proj);
   
   
end
