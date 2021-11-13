function [A_AR_1] = VAR_1_companion(varargin)

%%% This function computes the VAR(1) companion form from any VAR(p) model %%%

% Inputs: All A(i) matrices. Since this number may vary, I have used the 
% varargin input method 

% from this, one can retrieve p
p = nargin;

% getting number of series
K = size(varargin{1},1);

% initlializing output matrix 
A_AR_1 = zeros(K*p,K*p);

% filling the matrix - first row - startng index at 2 in loop 
A_AR_1_first_row = varargin{1};


for i = 2:p
    A_AR_1_first_row = [ A_AR_1_first_row varargin{i}];
end

% giving first row to matrix 
A_AR_1((1:K),:) = A_AR_1_first_row;

% adding identity matrix 
 if p > 1
     A_AR_1(((K+1):K*2),1:K) = eye(K);
 end


end


