function B = randomtrials(A, ntrials)

%The function randomtrials generates a matrix containing the stimulus
%values for the experiment.
%input
%A = template matrix with all combinations of different inputs
%ntrials = the nubmer of times A has to be repeated
%output
%B = the matrix containing the values of stimuli in pseudo-random order
%
%AM did it on 27.02.2012

% a = [500 500 800 800 300 300
%     300 300 300 600 600 600
%     1 1 1 0 0 0];
% A = transpose(a);

A = repmat(A, ntrials, 1);
p = randperm(length(A));
m = min(size(A));
B = A(p, 1:m);