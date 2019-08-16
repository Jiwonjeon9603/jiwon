%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Toolbox for Synthetic Neurobiology Group's ExM crew (Beta)
%% Written by YGYOON on 02/11/2016.
%% Updated by XX on XX/XX/2016.
%% Updated by XX on XX/XX/2016.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [inputIMG] = readStackC( inputFile, numColors)


try
    Finfo = imfinfo(inputFile);
    firstSlice = imread([inputFile],'tiff', 1);

    if size(firstSlice,3) == 3,
        fileType=1;
        volumeResolution = [size(firstSlice,1) size(firstSlice,2) numel(Finfo)];
    else
        fileType=2;
        volumeResolution = [size(firstSlice,1) size(firstSlice,2) numel(Finfo)/numColors];
    end


    
    inputIMG = zeros( volumeResolution(1), volumeResolution(2), numColors, volumeResolution(3), 'uint16');
    
    if fileType==1,
        for z=1:volumeResolution(3),
            inputIMG(:,:,:,z) =imread([inputFile],'tiff', z) ;
        end
    else
        c = 1;
        for k=1:numel(Finfo),            
            z = floor( (k-1)/numColors) + 1;
            inputIMG(:,:,c,z) = imread([inputFile],'tiff', k);
            c = mod(c, numColors) + 1;
        end
    end
    
%     for c=1:numColors,
%         IMGlarge(:,:,c) = squeeze(max( squeeze(inputIMG(:,:,c,:)),[],3));
%     end
%     [IMGlarge] = autoAdjustIMG(IMGlarge);
%     figure('Name','MIP'); imshow(IMGlarge);
    
catch
   disp('Check if numColors is correct'); 
   error('Check if numColors is correct'); 
   
end

% IMGsmall = imresize(IMGlarge, [256 256]);
% figure('Name','Thumbnail'); imshow(IMGsmall);

disp(['Volume resolution is ' num2str(volumeResolution)]);