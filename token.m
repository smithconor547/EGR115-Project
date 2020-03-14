function out = token(inString)
%TOKEN Takes a string and removes all spaces, punctuation, converts to
%lowercase, returns a string with processed words delimited by whitespace

% Use ~isstrprop, iterate through the input string removing punctuation,
% generate an array when whitespace is encountered.

% Lowercase
inString = tolower(inString);

% Remove punctuation
strip = "";% Stripped string
l = 1;
for k = 1:length(inString)
	if isalpha(inString(k)) || isspace(inString(k))
		strip(l) = inString(k);
		l = l + 1;
	end
end

disp(strip)

% Slice string into cell array of words for Porter algorithm processing
wordCell = {};
currentWord = 1;
k = 1;
while length(strip) > 0
	if isspace(strip(k))
		wordCell(currentWord) = {strip(1:(k - 1))};
		currentWord = currentWord + 1;
		strip = strip((k + 1):length(strip));
	end
	k = k + 1
end

out = wordCell;

% Recombine into whitespace delimited string
% NOTE: This output requirement may change based on the implementation
% of the response generation

end

