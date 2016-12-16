% The code is below
function ActStruct = normaliseacts(ActStruct,NormType)
% Function to normalise activations/activity in different ways
% This mimics cell population normalisation in response
% to a single input stimulus, and also normalisation in response
% to observing a complete set of stimuli (e.g. as part of a 
% learning process where many stimuli are presented
% ActStruct = normaliseacts(ActStruct,NormType)
if nargin==1
    NormType = 'ColMax';
end

NCells = ActStruct.NCells;
NExamples = ActStruct.NExamples;
Activity = ActStruct.Activity;

switch NormType
    case {'colmax','ColMax'}
        % Each column of cells is normalised so that the column of activity
        % has max activation of 1; and there will be at least one such
        % neuron for each column that is not all zero.
        MA = max(Activity);
        Activity = Activity./repmat(MA,[NCells,1]);
        Activity(Activity==Inf) = 0;
        
    case {'col2norm','Col2Norm','Col2norm'}
        % Each column of cells is normalised so that the column of activity
        % has unit length of activation, unless units are zero.
        L = sqrt(sum(Activity.^2,1));
        Activity = Activity./repmat(L,[NCells,1]);
        Activity(Activity==Inf) = 0;
        
    case {'col1norm','Col1Norm','Col1norm'}
        % Each column of cells is normalised so that the column of activity
        % has unit SUM activation, unless units are zero.
        L = sum(abs(Activity),1);
        Activity = Activity./repmat(L,[NCells,1]);
        Activity(Activity==Inf) = 0;
        
    case {'exp2normmax','Exp2NormMax','Exp2normMax'}
        % Find the max root sum of square Activity over all experiments
        % and normalise by this scalar; this is "signal proc-inspired"
        % This is an energy normalisation - maximum energy of activation
        % in any one image frame will be 1. May want to follow this with a 
        % column rescaling to max.
        L = sqrt(sum(Activity.^2,1));
        MA = max(L);
        if MA>0 
            Activity = Activity/MA;
        else
            Activity = zeros(size(Activity));
        end
        
        
    case {'expcellmax','ExpCellMax'}
        % Find the max for each cell over examples and 
        % normalise each cell by its own maximum over all the examples 
        
        MA = max(Activity,[],2);
        Activity = Activity./repmat(MA,[1,NExamples]);;
        Activity(Activity==Inf) = 0;
        
    case {'expinfnorm','ExpInfNorm'}
        % Find max of all cells over all experiments and normalise by this
        % global max 
        MA = max(Activity(:));
        Activity = Activity/MA;
        
    otherwise
        disp([mfilename,': Unknown normalisation type in switch().']);
        error('Bye...');
end

ActStruct.Activity = Activity;
