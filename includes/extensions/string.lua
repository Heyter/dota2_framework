local string = string
local math = math

--[[---------------------------------------------------------
	Name: string.ToTable( string )
-----------------------------------------------------------]]
function string.ToTable( str )
	local tbl = {}

	for i = 1, string.len( str ) do
		tbl[i] = string.sub( str, i, i )
	end

	return tbl
end

--[[---------------------------------------------------------
	Name: explode(seperator ,string)
	Desc: Takes a string and turns it into a table
	Usage: string.explode( " ", "Seperate this string")
-----------------------------------------------------------]]
local totable = string.ToTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
function string.Explode(separator, str, withpattern)
	if ( separator == "" ) then return totable( str ) end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len( str ) do
		local start_pos, end_pos = string_find( str, separator, current_pos, not withpattern )
		if ( not start_pos ) then break end
		ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = string_sub( str, current_pos )

	return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

function string.EndsWith( String, End )
	return End == "" or string.sub( String, -string.len( End ) ) == End
end