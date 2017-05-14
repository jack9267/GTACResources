local function gsplit(s, sep, plain)--TODO: Look into why I couldn't stick this in "string"--TODO: Move this somewhere shared
	local start = 1
	local done = false
	local function pass(i, j, ...)
		if i then
			local seg = s:sub(start, i - 1)
			start = j + 1
			return seg, ...
		else
			done = true
			return s:sub(start)
		end
	end
	return function()
		if done then return end
		if sep == '' then done = true return s end
		return pass(s:find(sep, start, plain))
	end
end

local function Split(...)--TODO: Look into this--TODO: Move this somewhere shared
	local Result = {}
	for v in gsplit(...) do
		table.insert(Result,v)
	end
	return Result
end

function Engine.HTTP.HTMLSpecialChars(Text)
	local HTML = ""
	for I = 1, #Text do
		local Character = Text:sub(I,I)
		if Character == "&" then
			HTML = HTML.."&amp;"
		elseif Character == "\"" then
			HTML = HTML.."&quot;"
		elseif Character == "<" then
			HTML = HTML.."&lt;"
		elseif Character == ">" then
			HTML = HTML.."&gt;"
		else
			HTML = HTML..Character
		end
	end
	return HTML
end

function Engine.HTTP.QueryDecode(Value)
	return Engine.HTTP.URLDecode(string.gsub(Value,"+"," "))
end

function Engine.HTTP.QueryEncode(Value)
	return string.gsub(Engine.HTTP.URLEncode(Value),"+"," ")
end

function Engine.HTTP.DecodeQuery(QueryString)
	local Query = {}
	if QueryString ~= nil and QueryString ~= "" then
		for Value in gsplit(QueryString,"&") do
			local Data = Split(Value,"=")
			local Value2 = Data[2]
			if Value2 ~= nil then
				Value2 = Engine.HTTP.QueryDecode(Value2)
			else
				Value2 = false
			end
			Query[Engine.HTTP.QueryDecode(Data[1])] = Value2
		end
	end
	return Query
end