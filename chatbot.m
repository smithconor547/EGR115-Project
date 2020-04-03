% Main program file for the chatbot
% Handles I/O, everything else is handled through function calls

% Possible addition: GUI menu to set global options before the start (text speed, smooth vs random
% scrolling, personality parameters, etc.)

% Greet user, ask for name (could ask for more stuff), enter main program loop
textScroll('Welcome to the chatbot');
textScroll('Before we begin, what is your name:');
user = input('$ ', 's');
textScroll(strcat(user, ', is it? Nice to meet you.'));
textScroll('Type "exit" at any time to leave.')
textScroll('Is there anything in particular you wanted to talk about?');
while 1
    in = input('$ ', 's');% Standard input prompt
    if strcmp(in, 'exit');
        break;
    end
    textScroll(responseGen(in));
end

textScroll('Thanks for chatting.');
