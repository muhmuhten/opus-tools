local function encode_int(j)
	local t = {}
	for k=1,4 do
		t[k] = j % 256
		j = (j - t[k]) / 256
	end
	return string.char(unpack(t))
end

local function encode_str(s)
	return encode_int(#s), s
end

return function (e)
	local s, j = {encode_int(#e), e}, 0
	local function append(t)
		if type(t) ~= "string" then
			s[3] = encode_int(j)
			local str = table.concat(s)
			return t[1](encode_int(#str), str, unpack(t, 2))
		end

		s[2*j+4] = encode_int(#t)
		s[2*j+5] = t
		j = j+1
		return append
	end
	return append
end
