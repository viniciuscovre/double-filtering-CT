function [h,p] = C2G(img)
img = ((img - min(img(:)))/(max(img(:))-min(img(:))))*100;
m = mean(img(:));
s = std(img(:));
E = normpdf((0:100), m, s);
[counts, ~] = hist(img, 101);
O= counts / sum (counts);
[h,p] = chi2gof(0:100,'expected',E, 'frequency', O);
end