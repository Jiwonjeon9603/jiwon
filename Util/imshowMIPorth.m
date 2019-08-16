function currentMIP = imshowMIPorth(singleFrame, zExpansionFactor, gapVal, gapMIP)
% gapMIP = 25;


if size(singleFrame,4)==1, %% mono  
    volumeResolutionRender = [size(singleFrame,1), size(singleFrame,2), round(zExpansionFactor*size(singleFrame,3))];
%     singleFrameRend = uint8(round(1*singleFrame));
    singleFrameRend = ((1*singleFrame));
    
    singleFrameMIP1 = squeeze(max(singleFrameRend,[],3));
    singleFrameMIP2 = imresize( squeeze(max(singleFrameRend,[],1)), [volumeResolutionRender(2) volumeResolutionRender(3) ]);
    singleFrameMIP3 = imresize( squeeze(max(singleFrameRend,[],2)), [volumeResolutionRender(1) volumeResolutionRender(3) ]);    
    currentMIP = combineMIPs(singleFrameMIP1, singleFrameMIP2, singleFrameMIP3, volumeResolutionRender(2), volumeResolutionRender(1), volumeResolutionRender(3), gapVal, gapMIP );    
    imshow(currentMIP);
%     imagesc(currentMIP); colormap('hot')
else    
    for c=1:3,
        volumeResolutionRender = [size(singleFrame,1), size(singleFrame,2), round(zExpansionFactor*size(singleFrame,4))];
%         currentColor = uint8(round(squeeze(singleFrame(:,:,c,:))));
        currentColor = ((squeeze(singleFrame(:,:,c,:))));
        currentColorMIP1 = squeeze(max(currentColor,[],3));
        currentColorMIP2 = imresize( squeeze(max(currentColor,[],1)), [volumeResolutionRender(2) volumeResolutionRender(3) ]);
        currentColorMIP3 = imresize( squeeze(max(currentColor,[],2)), [volumeResolutionRender(1) volumeResolutionRender(3) ]);
        currentMIP(:,:,c)  = combineMIPs(currentColorMIP1, currentColorMIP2, currentColorMIP3, volumeResolutionRender(2), volumeResolutionRender(1), volumeResolutionRender(3), gapVal, gapMIP );            
    end        
    imshow(currentMIP);
%     imagesc(currentMIP); colormap('hot')
end