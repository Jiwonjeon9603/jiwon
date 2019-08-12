%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1%%
clear all; 
close all; 
clc;

warning('off');
addpath('./Util/');
eqtol = 1e-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filenamePSF1 = './PSF/PSFA.tif';
PSFstack1 = squeeze(single(readStackC(filenamePSF1, 1)));
PSFresolution1 = size(PSFstack1);
PSFstackT1 = flip(imrotate(PSFstack1,180),3);

filenamePSF2 = './PSF/PSFB.tif';
PSFstack2 = squeeze(single(readStackC(filenamePSF2, 1)));
PSFresolution2 = size(PSFstack2);
PSFstackT2 = flip(imrotate(PSFstack2,180),3);

filenamePSF3 = './PSF/PSFC.tif';
PSFstack3 = squeeze(single(readStackC(filenamePSF3, 1)));
PSFresolution3 = size(PSFstack3);
PSFstackT3 = flip(imrotate(PSFstack3,180),3);

filenamePSF4 = './PSF/PSFD.tif';
PSFstack4 = squeeze(single(readStackC(filenamePSF4, 1)));
PSFresolution4 = size(PSFstack4);
PSFstackT4 = flip(imrotate(PSFstack4,180),3);

% % figure; imshow3Dc(PSFstack);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filenameIMG = './Data/190716_Thunder_20x_Pollen_bin2x.tif';
zStack = squeeze(single(readStackC(filenameIMG, 1)));
zStack = zStack - min(zStack(:));
%Why just using 6th slide to 27slide?
zStack = zStack(:,:,(1+5:end-5));
volumeResolution = size(zStack);
Xguess = zStack;
% % figure; imshow3Dc(zStack);
zpart1 = zStack(1:512, 1:512, :);
zpart2 = zStack(513:1024, 1:512, :);
zpart3 = zStack(1:512, 513:1024, :);
zpart4 = zStack(513:1024, 513:1024, :);

% data = imread('./Data/zebrafish_Crop.tif');
figure(1); currentMIP = imshowMIPorth(1*zpart1/max(zpart1(:)), 5/0.65, 255, 15); title('raw image_1st quarter.  (Maximum Intensity Projection)'); drawnow;
figure(2); currentMIP = imshowMIPorth(1*zpart2/max(zpart2(:)), 5/0.65, 255, 15); title('raw image_2nd quarter.  (Maximum Intensity Projection)'); drawnow;
figure(3); currentMIP = imshowMIPorth(1*zpart3/max(zpart1(:)), 5/0.65, 255, 15); title('raw image_3rd quarter.  (Maximum Intensity Projection)'); drawnow;
figure(4); currentMIP = imshowMIPorth(1*zpart4/max(zpart2(:)), 5/0.65, 255, 15); title('raw image_4th quarter.  (Maximum Intensity Projection)'); drawnow;
figure(5); currentMIP = imshowMIPorth(1*zStack/max(zStack(:)), 5/0.65, 255, 15); title('raw image.  (Maximum Intensity Projection)'); drawnow;

Xguess1 = zpart1;
Xguess2 = zpart2;
Xguess3 = zpart3;
Xguess4 = zpart4;


disp('Start deconvolution...');
numIter = 40;
figure;
for i=1:numIter,
    tic;       
%     %% CPU version
%     HXguess = convn( Xguess, PSFstack, 'same');
%     error = zStack./HXguess;
%     errorBack = convn( error, PSFstackT, 'same');
%     Xguess = Xguess.*errorBack;
    
    %% GPU version
    HXguess1 = convn( gpuArray(Xguess1), gpuArray(PSFstack1), 'same');
    %Hope error would be 1
    error1 = zpart1./HXguess1;
    errorBack1 = convn( error1, gpuArray(PSFstackT1), 'same');
    Xguess1 = gather(Xguess1.*errorBack1);
    figure(6); currentMIP = imshowMIPorth(1*Xguess1/max(Xguess1(:)), 5/0.65, 255, 15); title(['deconvolved 1st quarter image after ' num2str(i) 'th iteration. (Maximum Intensity Projection)']); drawnow;
    
    HXguess2 = convn( gpuArray(Xguess2), gpuArray(PSFstack2), 'same');
    %Hope error would be 1
    error2 = zpart2./HXguess2;
    errorBack2 = convn( error2, gpuArray(PSFstackT2), 'same');
    Xguess2 = gather(Xguess2.*errorBack2);
 
    figure(7); currentMIP = imshowMIPorth(1*Xguess2/max(Xguess2(:)), 5/0.65, 255, 15); title(['deconvolved 2nd quarter image after ' num2str(i) 'th iteration. (Maximum Intensity Projection)']); drawnow;
    
    HXguess3 = convn( gpuArray(Xguess3), gpuArray(PSFstack3), 'same');
    %Hope error would be 1
    error3 = zpart3./HXguess3;
    errorBack3 = convn( error3, gpuArray(PSFstackT3), 'same');
    Xguess3 = gather(Xguess3.*errorBack3);
    
    figure(8); currentMIP = imshowMIPorth(1*Xguess3/max(Xguess3(:)), 5/0.65, 255, 15); title(['deconvolved 3rd quarter image after ' num2str(i) 'th iteration. (Maximum Intensity Projection)']); drawnow;
    
    HXguess4 = convn( gpuArray(Xguess4), gpuArray(PSFstack4), 'same');
    %Hope error would be 1
    error4 = zpart4./HXguess4;
    errorBack4 = convn( error4, gpuArray(PSFstackT4), 'same');
    Xguess4 = gather(Xguess4.*errorBack4);
    
    ttime=toc;
    figure(9); currentMIP = imshowMIPorth(1*Xguess4/max(Xguess4(:)), 5/0.65, 255, 15); title(['deconvolved 4th quarter image after ' num2str(i) 'th iteration. (Maximum Intensity Projection)']); drawnow;
    
    resultTotal = [Xguess1(:,:,:), Xguess3(:,:,:); Xguess2(:,:,:), Xguess4(:,:,:)];

    figure(10); currentMIP = imshowMIPorth(1*resultTotal/max(resultTotal(:)), 5/0.65, 255, 15); title(['deconvolved total image after ' num2str(i) 'th iteration. (Maximum Intensity Projection)']); drawnow;
    
    disp(['  iter ' num2str(i) ' | ' num2str(numIter) ', took ' num2str(ttime) ' secs']);
end

disp('Deconvolution completed...converting result');