function TOTALprojection = forwardProjectWFvolume( Hwf, inVolume )
global zeroImageEx;
global exsize

zPSF = size(Hwf,3);
zPSFcenter = round((zPSF-1)/2);
zVolume = size(inVolume,3);

TOTALprojection = gpuArray.zeros(size(inVolume), 'single');

HwfGPU = gpuArray(Hwf);

for z=1:size(inVolume,3),
    inSlice = gpuArray(inVolume(:,:,z));
            
    for zz=-zPSFcenter:1:+zPSFcenter,
        
        if (z+zz)<1 || (z+zz)>zVolume,
            ;
        else
            projection = gather(conv2FFT(inSlice, HwfGPU(:,:,zz + zPSFcenter + 1)  ));
%             projection = conv2(inSlice, Hwf(:,:,zz + zPSFcenter + 1), 'same');
            TOTALprojection(:,:, z+zz) = TOTALprojection(:,:, z+zz) + projection;
        end
    end    
end

TOTALprojection = gather(TOTALprojection);

% TOTALprojection = gpuArray.zeros(  size(realspace,1),   size(realspace,2), 'single');
% 
% for cc=1:size(realspace,3),    
% 	Hs = gpuArray(squeeze(Hwf( :,:,cc)));    
%     tempspace = gpuArray(realspace(:,:,cc));
%     projection = conv2FFT(tempspace, Hs);
% %     projection = conv2(tempspace, Hs,'same');
%     TOTALprojection = TOTALprojection + projection;            
% end



