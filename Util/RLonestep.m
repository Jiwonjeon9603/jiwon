function Xguess = RLonestep(Xguess, Htf, PSFstack, CompMeasure)

volumeResolution = size(Xguess);

HXguess = forwardProjectWFvolume( PSFstack, Xguess );
HXguessBack = forwardProjectWFvolume( PSFstack, HXguess );
errorBack = Htf./HXguessBack;
Xguess = Xguess.*errorBack;

Xguess = Xguess.*CompMeasure;
Xguess(find(isnan(Xguess))) = 0;

