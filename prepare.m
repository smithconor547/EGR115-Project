function [s]=prepare(str)
%Shifts all letters to lowercase and removes all punctuation
s=lower(str);
s=strrep(s,'!','');
s=strrep(s,'.','');
s=strrep(s,'''','');
s=strrep(s,'?','');
s=strrep(s,',','');
s=strrep(s,'"','');
s=strrep(s,'(','');
s=strrep(s,')','');
s=strrep(s,':','');
s=strrep(s,';','');
s=strrep(s,'/','');
s=strrep(s,'@','');
s=strrep(s,'*','');
s=strrep(s,'$','');