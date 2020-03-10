function [out] = token(inString)
%TOKEN Takes a string and removes all spaces, punctuation, converts to
%lowercase, returns a string with processed words delimited by whitespace

% Use ~isstrprop, iterate through the input string removing punctuation,
% generate an array when whitespace is encountered.

% Lowercase
inString = tolower(inString);

% Remove punctuation
strip = '';% Stripped string
j = 1;
for k = 1:length(inString)
	if isalpha(inString(k)) || isspace(inString(k))
		strip(j) = inString(k);
		j = j + 1;
	end
end

out = strip;

% Slice string into array of words for Porter algorithm processing
wordArray = 

% Recombine into whitespace delimeted string
% NOTE: This output requirement may change based on the implementation
% of the response generation

end

