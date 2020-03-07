function [response] = responseGen(inString)
%RESPONSEGEN Takes an input string with stemmed words delimited by
%whitespace, ranks keywords, selects an appropriate respose from a
%database, and returns the response as a string

% Basic implementation can be expanded through other functions used
% for keyword ranking based on different algorithms, even distribution
% of responses to avoid repetition, and other functions to generally
% enhance the quality of response to an input.

response = fprintf('This is a response to the input %s\n', inString);

end;
