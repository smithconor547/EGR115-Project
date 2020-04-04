function [re] = responseGen(inString)

%RESPONSEGEN takes a string and returns a response based on previous
%conversations (MATT EDIT)

%RESPONSEGEN Takes an input string with stemmed words delimited by
%whitespace, ranks keywords, selects an appropriate respose from a
%database, and returns the response as a string
%
% Basic implementation can be expanded through other functions used
% for keyword ranking based on different algorithms, even distribution
% of responses to avoid repetition, and other functions to generally
% enhance the quality of response to an input.

%takes a table, identifies all matching ins, collects responses, and randomizes response
a=readtable('record.txt');

x=a{:,1};
response={};
%Collects all possible responses
for c = 1:length(x)
    temp=x{c};
    if strcmp(temp,inString)
        temp2=a{c,2};
        response{end+1}=temp2;
    end
end
if isempty(response)
    response{end+1}={'error, no response set'};
end
%chooses a response
ran=randi(length(response));
lol=response{ran};
re=lol{1,1};
%response = char(strcat('This is a response to the input', {' '}, inString));

end
