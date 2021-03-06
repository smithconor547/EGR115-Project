function out = token(inString)
%TOKEN Takes a string and removes all spaces, punctuation, converts to
%lowercase, returns a string with processed words delimited by whitespace

% Use ~isstrprop, iterate through the input string removing punctuation,
% generate an array when whitespace is encountered.

% Lowercase
inString = lower(inString);

% Remove punctuation
strip = '';% Stripped string
l = 1;
for k = 1:length(inString)
	if isstrprop(inString(k), 'alpha') || isspace(inString(k))
		strip(l) = inString(k);
		l = l + 1;
	end
end

% Hack to make the cell include the last word
strip = append(strip, ' #');

% Slice string into cell array of words for Porter algorithm processing
wordCell = {};
currentWord = 1;
k = 1;
while k < length(strip)
	if isspace(strip(k))
		wordCell(currentWord) = {strip(1:(k - 1))};
		currentWord = currentWord + 1;
		strip = strip((k + 1):length(strip));
		k = 0;
	end
	k = k + 1;
end

% Call Porter algorithm on each cell
for k = 1:length(wordCell)
	wordCell(k) = {porterStem(char(wordCell(k)))};
end

% Recombine into whitespace delimited string
% NOTE: This output requirement may change based on the implementation
% of the response generation
temp = '';
for k = 1:length(wordCell)
	temp = append(temp, ' ', char(wordCell(k)));
end
temp(1) = '';% Fix the extra space at the start
out = temp;

end
