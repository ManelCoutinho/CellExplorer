% function [U,stdA] = unity2(A,sd,restrict)
% A is n x m  matrix, and each column is a signal.
% the function gives a unity signal for each column
% i.e. [signal-mean(signal)] / std(signal)


% function [U,stdA] = unity(A,varargin)
% 
% [ sd, restrict ] = DefaultArgs(varargin,{ [],[]});
% 
% 
% if ~isempty(restrict),
% 	meanA = mean(A(restrict));
% 	stdA = std(A(restrict));
% else
% 	meanA = mean(A);
% 	stdA = std(A);
% end
% if ~isempty(sd),
% 	stdA = sd;
% end
% 
% U = (A - meanA)/stdA;



%OLD VERSION
% function U = unity(A) 
% A is n x m  matrix, and each column is a signal.
% the function gives a unity signal for each column
% i.e. [signal-mean(signal)] / std(signal)
function U = unity(A)
meanA = mean(A);
stdA = std(A);
U = (A - repmat(meanA,size(A,1),1))./repmat(stdA,size(A,1),1);
