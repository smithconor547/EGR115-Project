function stem = porterStem(inString)
% Applies the Porter Stemming algorithm as presented in the following
% paper:
% Porter, 1980, An algorithm for suffix stripping, Program, Vol. 14,
%   no. 3, pp 130-137

% Original code modeled after the C version provided at:
% http://www.tartarus.org/~martin/PorterStemmer/c.txt

% The main part of the stemming algorithm starts here. inString is an array of
% characters, holding the word to be stemmed. The letters are in inString[k0],
% inString[k0+1] ending at inString[k]. In fact k0 = 1 in this demo program (since
% matlab begins indexing by 1 instead of 0). k is readjusted downwards as
% the stemming progresses. Zero termination is not in fact used in the
% algorithm.

% Note that only lower case sequences are stemmed. Forcing to lower case
% should be done before porterStemmer(...) is called.

% To call this function, use the string to be stemmed as the input
% argument.  This function returns the stemmed word as a string.

% Source: https://tartarus.org/martin/PorterStemmer/matlab.txt
global j;
k = length(inString);
k0 = 1;
j = k;



% With this if statement, strings of length 1 or 2 don't go through the
% stemming process. Remove this conditional to match the published
% algorithm.
stem = inString;
if k > 2
    % Output displays per step are commented out.
    %disp(sprintf('Word to stem: %s', inString));
    x = step1ab(inString, k, k0);
    %disp(sprintf('Steps 1A and B yield: %s', x{1}));
    x = step1c(x{1}, x{2}, k0);
    %disp(sprintf('Step 1C yields: %s', x{1}));
    x = step2(x{1}, x{2}, k0);
    %disp(sprintf('Step 2 yields: %s', x{1}));
    x = step3(x{1}, x{2}, k0);
    %disp(sprintf('Step 3 yields: %s', x{1}));
    x = step4(x{1}, x{2}, k0);
    %disp(sprintf('Step 4 yields: %s', x{1}));
    x = step5(x{1}, x{2}, k0);
    %disp(sprintf('Step 5 yields: %s', x{1}));
    stem = x{1};
end

% cons(j) is TRUE <=> inString[j] is a consonant.
function c = cons(i, inString, k0)
c = true;
switch(inString(i))
    case {'a', 'e', 'i', 'o', 'u'}
        c = false;
    case 'y'
        if i == k0
            c = true;
        else
            c = ~cons(i - 1, inString, k0);
        end
end

% mseq() measures the number of consonant sequences between k0 and j.  If
% c is a consonant sequence and v a vowel sequence, and <..> indicates
% arbitrary presence,

%      <c><v>       gives 0
%      <c>vc<v>     gives 1
%      <c>vcvc<v>   gives 2
%      <c>vcvcvc<v> gives 3
%      ....
function n = measure(inString, k0)
global j;
n = 0;
i = k0;
while true
    if i > j
        return
    end
    if ~cons(i, inString, k0)
        break;
    end
    i = i + 1;
end
i = i + 1;
while true
    while true
        if i > j
            return
        end
        if cons(i, inString, k0)
            break;
        end
        i = i + 1;
    end
    i = i + 1;
    n = n + 1;
    while true
        if i > j
            return
        end
        if ~cons(i, inString, k0)
            break;
        end
        i = i + 1;
    end
    i = i + 1;
end


% vowelinstem() is TRUE <=> k0,...j contains a vowel
function vis = vowelinstem(inString, k0)
global j;
for i = k0:j
    if ~cons(i, inString, k0)
        vis = true;
        return
    end
end
vis = false;

%doublec(i) is TRUE <=> i,(i-1) contain a double consonant.
function dc = doublec(i, inString, k0)
if i < k0+1
    dc = false;
    return
end
if inString(i) ~= inString(i-1)
    dc = false;
    return
end
dc = cons(i, inString, k0);


% cvc(j) is TRUE <=> j-2,j-1,j has the form consonant - vowel - consonant
% and also if the second c is not w,x or y. this is used when trying to
% restore an e at the end of a short word. e.g.
%
%      cav(e), lov(e), hop(e), crim(e), but
%      snow, box, tray.

function c1 = cvc(i, inString, k0)
if ((i < (k0+2)) || ~cons(i, inString, k0) || cons(i-1, inString, k0) || ~cons(i-2, inString, k0))
    c1 = false;
else
    if (inString(i) == 'w' || inString(i) == 'x' || inString(i) == 'y')
        c1 = false;
        return
    end
    c1 = true;
end

% ends(s) is TRUE <=> k0,...k ends with the string s.
function s = ends(str, inString, k)
global j;
if (str(length(str)) ~= inString(k))
    s = false;
    return
end % tiny speed-up
if (length(str) > k)
    s = false;
    return
end
if strcmp(inString(k-length(str)+1:k), str)
    s = true;
    j = k - length(str);
    return
else
    s = false;
end

% setto(s) sets (j+1),...k to the characters in the string s, readjusting
% k accordingly.

function so = setto(s, inString, k)
global j;
for i = j+1:(j+length(s))
    inString(i) = s(i-j);
end
if k > j+length(s)
    inString((j+length(s)+1):k) = '';
end
k = length(inString);
so = {inString, k};

% rs(s) is used further down.
% [Note: possible null/value for r if rs is called]
function r = rs(str, inString, k, k0)
r = {inString, k};
if measure(inString, k0) > 0
    r = setto(str, inString, k);
end

% step1ab() gets rid of plurals and -ed or -ing. e.g.

%       caresses  ->  caress
%       ponies    ->  poni
%       ties      ->  ti
%       caress    ->  caress
%       cats      ->  cat

%       feed      ->  feed
%       agreed    ->  agree
%       disabled  ->  disable

%       matting   ->  mat
%       mating    ->  mate
%       meeting   ->  meet
%       milling   ->  mill
%       messing   ->  mess

%       meetings  ->  meet

function s1ab = step1ab(inString, k, k0)
global j;
if inString(k) == 's'
    if ends('sses', inString, k)
        k = k-2;
    elseif ends('ies', inString, k)
        retVal = setto('i', inString, k);
        inString = retVal{1};
        k = retVal{2};
    elseif (inString(k-1) ~= 's')
        k = k-1;
    end
end
if ends('eed', inString, k)
    if measure(inString, k0) > 0
        k = k-1;
    end
elseif (ends('ed', inString, k) || ends('ing', inString, k)) && vowelinstem(inString, k0)
    k = j;
    retVal = {inString, k};
    if ends('at', inString, k)
        retVal = setto('ate', inString(k0:k), k);
    elseif ends('bl', inString, k)
        retVal = setto('ble', inString(k0:k), k);
    elseif ends('iz', inString, k)
        retVal = setto('ize', inString(k0:k), k);
    elseif doublec(k, inString, k0)
        retVal = {inString, k-1};
        if inString(retVal{2}) == 'l' || inString(retVal{2}) == 's' || ...
                inString(retVal{2}) == 'z'
            retVal = {retVal{1}, retVal{2}+1};
        end
    elseif measure(inString, k0) == 1 && cvc(k, inString, k0)
        retVal = setto('e', inString(k0:k), k);
    end
    k = retVal{2};
    inString = retVal{1}(k0:k);
end
j = k;
s1ab = {inString(k0:k), k};

%  step1c() turns terminal y to i when there is another vowel in the stem.
function s1c = step1c(inString, k, k0)
global j;
if ends('y', inString, k) && vowelinstem(inString, k0)
    inString(k) = 'i';
end
j = k;
s1c = {inString, k};

% step2() maps double suffices to single ones. so -ization ( = -ize plus
% -ation) maps to -ize etc. note that the string before the suffix must give
% m() > 0.
function s2 = step2(inString, k, k0)
global j;
s2 = {inString, k};
switch inString(k-1)
    case {'a'}
        if ends('ational', inString, k) s2 = rs('ate', inString, k, k0);
        elseif ends('tional', inString, k) s2 = rs('tion', inString, k, k0); end
    case {'c'}
        if ends('enci', inString, k) s2 = rs('ence', inString, k, k0);
        elseif ends('anci', inString, k) s2 = rs('ance', inString, k, k0); end
    case {'e'}
        if ends('izer', inString, k) s2 = rs('ize', inString, k, k0); end
    case {'l'}
        if ends('bli', inString, k) s2 = rs('ble', inString, k, k0);
        elseif ends('alli', inString, k) s2 = rs('al', inString, k, k0);
        elseif ends('entli', inString, k) s2 = rs('ent', inString, k, k0);
        elseif ends('eli', inString, k) s2 = rs('e', inString, k, k0);
        elseif ends('ousli', inString, k) s2 = rs('ous', inString, k, k0); end
    case {'o'}
        if ends('ization', inString, k) s2 = rs('ize', inString, k, k0);
        elseif ends('ation', inString, k) s2 = rs('ate', inString, k, k0);
        elseif ends('ator', inString, k) s2 = rs('ate', inString, k, k0); end
    case {'s'}
        if ends('alism', inString, k) s2 = rs('al', inString, k, k0);
        elseif ends('iveness', inString, k) s2 = rs('ive', inString, k, k0);
        elseif ends('fulness', inString, k) s2 = rs('ful', inString, k, k0);
        elseif ends('ousness', inString, k) s2 = rs('ous', inString, k, k0); end
    case {'t'}
        if ends('aliti', inString, k) s2 = rs('al', inString, k, k0);
        elseif ends('iviti', inString, k) s2 = rs('ive', inString, k, k0);
        elseif ends('biliti', inString, k) s2 = rs('ble', inString, k, k0); end
    case {'g'}
        if ends('logi', inString, k) s2 = rs('log', inString, k, k0); end
end
j = s2{2};

% step3() deals with -ic-, -full, -ness etc. similar strategy to step2.
function s3 = step3(inString, k, k0)
global j;
s3 = {inString, k};
switch inString(k)
    case {'e'}
        if ends('icate', inString, k) s3 = rs('ic', inString, k, k0);
        elseif ends('ative', inString, k) s3 = rs('', inString, k, k0);
        elseif ends('alize', inString, k) s3 = rs('al', inString, k, k0); end
    case {'i'}
        if ends('iciti', inString, k) s3 = rs('ic', inString, k, k0); end
    case {'l'}
        if ends('ical', inString, k) s3 = rs('ic', inString, k, k0);
        elseif ends('ful', inString, k) s3 = rs('', inString, k, k0); end
    case {'s'}
        if ends('ness', inString, k) s3 = rs('', inString, k, k0); end
end
j = s3{2};

% step4() takes off -ant, -ence etc., in context <c>vcvc<v>.
function s4 = step4(inString, k, k0)
global j;
switch inString(k-1)
    case {'a'}
        if ends('al', inString, k) end;
    case {'c'}
        if ends('ance', inString, k)
        elseif ends('ence', inString, k) end;
    case {'e'}
        if ends('er', inString, k) end;
    case {'i'}
        if ends('ic', inString, k) end;
    case {'l'}
        if ends('able', inString, k)
        elseif ends('ible', inString, k) end;
    case {'n'}
        if ends('ant', inString, k)
        elseif ends('ement', inString, k)
        elseif ends('ment', inString, k)
        elseif ends('ent', inString, k) end;
    case {'o'}
        if ends('ion', inString, k)
            if j == 0
            elseif ~(strcmp(inString(j),'s') || strcmp(inString(j),'t'))
                j = k;
            end
        elseif ends('ou', inString, k) end;
    case {'s'}
        if ends('ism', inString, k) end;
    case {'t'}
        if ends('ate', inString, k)
        elseif ends('iti', inString, k) end;
    case {'u'}
        if ends('ous', inString, k) end;
    case {'v'}
        if ends('ive', inString, k) end;
    case {'z'}
        if ends('ize', inString, k) end;
end
if measure(inString, k0) > 1
    s4 = {inString(k0:j), j};
else
    s4 = {inString(k0:k), k};
end

% step5() removes a final -e if m() > 1, and changes -ll to -l if m() > 1.
function s5 = step5(inString, k, k0)
global j;
j = k;
if inString(k) == 'e'
    a = measure(inString, k0);
    if (a > 1) || ((a == 1) && ~cvc(k-1, inString, k0))
        k = k-1;
    end
end
if (inString(k) == 'l') && doublec(k, inString, k0) && (measure(inString, k0) > 1)
    k = k-1;
end
s5 = {inString(k0:k), k};