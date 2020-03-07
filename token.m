function [out] = token(inString)
%TOKEN Takes a string and removes all spaces, punctuation, converts to
%lowercase, returns a string with processed words delimited by whitespace

% Use ~isstrprop, iterate through the input string removing punctuation,
% generate an array when whitespace is encountered.

% Lowercase

% Remove punctuation
strip = '';% Stripped string
for k = 1:length(inString)
	if isalpha(inString(k)) || isspace(inString(k))
		strip = strip + inString(k);

out = inString;

% Slice string into array of words for Porter algorithm processing

% Recombine into whitespace delimeted string
% NOTE: This output requirement may change based on the implementation
% of the response generation

end

