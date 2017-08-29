function [img] = fbp(sinogram)
    sinogram = log(  max(max(sinogram))./sinogram  );
    
    [c l] = size(sinogram);
    theta = 180/l ;
    
    ang = linspace(0, 180, l);
    
    [img, H] =iradon(sinogram',ang,'linear','Shepp-Logan',1,l);
 
    img = (img - min(min(img))) / (max(max(img)) - min(min(img)));
    %img = img/max(img(:));
    img = fliplr(img); 
end