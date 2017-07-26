local function decode_int(s, i)
	local by0, by1, by2, by3 = s:byte(i, i+3)
	return by0 + 0x100*by1 + 0x10000*by2 + 0x1000000*by3, i+4
end

local function decode_str(s, i)
	local len, j = decode_int(s, i)
	return s:sub(j, j+len-1), j+len
end

local function decode_ary(s, i)
	local len, j = decode_int(s, i)
	local t = {}
	for k=1,len do
		t[k], j = decode_str(s, j)
	end
	return t, j
end

local function decode(s)
	assert(decode_int(s, 1) == #s-4)
	local e, i = decode_str(s, 5)
	local t, j = decode_ary(s, i)
	assert(j == #s+1)
	return e, t
end


local function encode_int(j)
	local t = {}
	for k=1,4 do
		t[k] = j % 256
		j = (j - t[k]) / 256
	end
	return string.char(unpack(t))
end

local e, t = decode(io.read "*a")
print "require 'vcenc'"
for k=0,#t do
	print(string.format("%q", t[k] or e))
end
print "{io.write}"
