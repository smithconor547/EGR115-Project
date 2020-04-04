function textScroll(inString)
%TEXTSCROLL Takes a string and "types" the output randomly to the command line,
%adds a bit of a human element to the chatbot.

%k = 8;% Divider for typing speed tweak (higher numbers = faster)
k=sqrt(length(inString))*2;%scalar for longer strings
for i = 1:length(inString)
    fprintf(inString(i));
    pause(rand / k);
end

pause(.1);
%pause(0.2 + rand);% Longer delay after each line
fprintf('\n');

end
