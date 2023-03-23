% Fletcher-32
function hash = FletcherHash(data)
    n = length(data);
    s1 = 0;
    s2 = 0;
    for i = 1:n
        s1 = mod(s1 + data(i), 65535);
        s2 = mod(s2 + s1, 65535);
    end
    hash = dec2hex(bitor(bitshift(s2, 16), s1));
end