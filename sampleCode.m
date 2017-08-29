% Sample code of Double-Filtering approach in CT images
% Applying in noisy image (projections): pre-filter -> FPB -> post-filter

% Noisy Image: Shepp Logan
% Measurements: PSNR & SSIM

cd ~/Desktop/sample-code
imageSet = dir('*3s.dat'); % only one image for sampleCode.m

% Array List with the algorithms (filters) to be executed
pre_filters = {'MAP','P_NLM', 'AT_NLM', 'PWF_1D', 'AT_GWF', ...
    'AT_IWF', 'AT_SWF'};
post_filters = {'NLM', 'BM3D', 'PWF_2D', 'GWF', 'IWF', 'SWF'};

% Quantitative Results Table (QRT)
% Structs to show the results of the quantitative measures PSNR and SSIM
table_PSNR = struct('name','', 'MAP',.0, 'P_NLM',.0, 'AT_NLM',.0, ...
    'PWF_1D',.0, 'AT_GWF',.0, 'AT_IWF',.0, 'AT_SWF',.0, ...
    'NLM',.0, 'BM3D',.0, 'PWF_2D',.0, 'GWF',.0, 'IWF',.0,'SWF',.0, ...
    'MAP_D_NLM',.0, 'MAP_D_BM3D',.0, 'MAP_D_PWF_2D',.0, 'MAP_D_GWF',.0, ...
    'MAP_D_IWF',.0, 'MAP_D_SWF',.0, 'P_NLM_D_NLM',.0, 'P_NLM_D_BM3D',.0,...
    'P_NLM_D_PWF_2D',.0, 'P_NLM_D_GWF',.0, 'P_NLM_D_IWF',.0, ...
    'P_NLM_D_SWF',.0, 'AT_NLM_D_NLM',.0, 'AT_NLM_D_BM3D',.0, ...
    'AT_NLM_D_PWF_2D',.0, 'AT_NLM_D_GWF',.0, 'AT_NLM_D_IWF',.0, ...
    'AT_NLM_D_SWF',.0,'PWF_1D_D_NLM',.0, 'PWF_1D_D_BM3D',.0, ...
    'PWF_1D_D_PWF_2D',.0, 'PWF_1D_D_GWF',.0, 'PWF_1D_D_IWF',.0, ...
    'PWF_1D_D_SWF',.0, 'AT_GWF_D_NLM',.0, 'AT_GWF_D_BM3D',.0, ...
    'AT_GWF_D_PWF_2D',.0, 'AT_GWF_D_GWF',.0, 'AT_GWF_D_IWF',.0, ...
    'AT_GWF_D_SWF',.0, 'AT_IWF_D_NLM',.0, 'AT_IWF_D_BM3D',.0, ...
    'AT_IWF_D_PWF_2D',.0, 'AT_IWF_D_GWF',.0, 'AT_IWF_D_IWF',.0, ...
    'AT_IWF_D_SWF',.0, 'AT_SWF_D_NLM',.0, 'AT_SWF_D_BM3D',.0, ...
    'AT_SWF_D_PWF_2D',.0, 'AT_SWF_D_GWF',.0, 'AT_SWF_D_IWF',.0, ...
    'AT_SWF_D_SWF',.0);

table_SSIM = table_PSNR;

% Noise Standard Deviation and Variance in the noisy images
stdDeviation = 30;
variance = (stdDeviation.^2)./255^2;

% Noise Standard Deviation and Variance in the pre-filtered images
preFilteredStdDeviation = [18.9, 34.4, 21.7, 17.4, 26.4, 18.2];
preFilteredVariance = (preFilteredStdDeviation.^2)./255^2;

% PS: Standard Deviations were manually gotten

for i=1 : length(imageSet)
    
    % Getting noisy projections and noisy reconstrcted image(s)
    projections = open_file_proj(imageSet(i).name);
    reconstructedImage = fbp(projections);
    reconstructedImage = im2double(reconstructedImage);
    
    % Getting Image(s) name(s) and inserting in QRT
    imageName = strsplit(imageSet(i).name, '_');
    table_PSNR(i).name = imageName{1};
    table_SSIM(i).name = imageName{1};
    
    % Getting ideal projections and ideal reconstructed image(s)
    idealImage = open_file_proj(strrep(imageSet(i).name,'_3s', '_20s'));
    idealImage = fbp(idealImage);
    
    % Saving ideal image(s) in directory
    cd ~/Desktop/sample-code/images/pre
    imwrite(idealImage, [imageName{1} '_IDEAL' '.png']);
    cd ~/Desktop/sample-code/images/post
    imwrite(idealImage, [imageName{1} '_IDEAL' '.png']);
    cd ~/Desktop/sample-code/images/double
    imwrite(idealImage, [imageName{1} '_IDEAL' '.png']);
    cd ~/Desktop/sample-code
    
    %%% PRE-FILTERING STEP
    
    [row,col] = size(reconstructedImage);
    structpreFilteredImages = zeros(row,col,length(pre_filters));
    
%     % Showing results of pre-filtering
%     h = figure;
%     rowPre = 2;
%     colPre = size(pre_filters,2);
%     colPre = ceil((colPre+2)/rowPre);
%     subplot(rowPre,colPre,1);
%     imshow(idealImage);
%     title('Original');
%     subplot(rowPre,colPre,2);
%     imshow(reconstructedImage);
%     title('Ruidosa');
    
    for j=1 : length(pre_filters)
        preFilteredImage = eval([pre_filters{j} '(projections)']);
        preFilteredImage = fbp(preFilteredImage);
        structpreFilteredImages(:,:,j) = preFilteredImage; %salva a imagem pré filtrada para usar na dupla filtragem
        table_PSNR(i).(pre_filters{j}) = psnr(preFilteredImage, preFilteredImage);
        table_SSIM(i).(pre_filters{j}) = ssim(preFilteredImage, preFilteredImage);
        
%         subplot(rowPre,colPre,j+2);
%         imshow(preFilteredImage);
%         title(pre_filters{j}, 'Interpreter', 'none');
        
        cd ~/Desktop/sample-code/images/pre
        imwrite(preFilteredImage, [imageName{1} '_' pre_filters{j} '.png']);
        cd ~/Desktop/sample-code
        
        clear preFilteredImage
    end
    
%     % Saving unified results
%     cd ~/Desktop/sample-code/images/results
%     print(h,'-dpng', ['PRE_' imageName{1} '.png']);
%     cd ~/Desktop/sample-code/
    
    clear j h rowPre colPre
    
    clear projections idealImage reconstructedImage imageName idealImage
    
end

