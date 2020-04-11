function isnumber(a)
	return type(a) == 'number'
end

function istable(a)
	return type(a) == 'table'
end

function isstring(a)
	return type(a) == 'string'
end

function isbool(a)
	return type(a) == 'boolean'
end

function isfunction(a)
	return type(a) == 'function'
end

function IsValid(object)
	if not object then return false end
	
	return true
end

--[[---------------------------------------------------------
	Prints a table to the console
-----------------------------------------------------------]]
function PrintTable( t, indent, done )
	if not istable(t) then return end
	
	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) and isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		Msg( string.rep( "\t", indent ) )
		if  ( istable( value ) and not done[ value ] ) then
			done[ value ] = true
			Msg( tostring( key ) .. ":" .. "\n" )
			PrintTable ( value, indent + 2, done )
			done[ value ] = nil
		else
			Msg( tostring( key ) .. "\t=\t" )
			Msg( tostring( value ) .. "\n" )
		end
	end
end

function CurTime()
	return GameRules:GetGameTime()
end

function print_traceback(suppress, ...)
	local trace_text = debug.traceback(...)
	trace_text = trace_text
                 :gsub('stack traceback:\n', '\n')
                 :gsub(': in main chunk', '')
                 :gsub(': in function', ': in')
                 :gsub('\n%s+', '\n')
                 :gsub('^\n', '')

	local pieces = trace_text:Split('\n')
	pieces[1] = '' -- remove the actual call to debug.traceback

	if not suppress then
		for k, v in ipairs(pieces) do
			if v and v ~= '' then
				Msg('    ')
				Warning('from '..v)
				Msg('\n')
			end
		end
	end

	return pieces
end

--- Prints an error using ErrorNoHalt but without character limit.
-- @see[ErrorNoHalt]
function long_error(bError, ...)
	local text = table.concat({...})
	local len = string.len(text)
	local pieces = {}

	if len > 200 then
		for i = 1, len / 200 do
			table.insert(pieces, text:sub((i - 1) * 200 + 1, math.min(i * 200, len)))
		end
	else
		pieces = { text }
	end

	for k, v in ipairs(pieces) do
		if bError then
			error(v)
		else
			Warning(v)
		end
	end

	if text:EndsWith('\n') then
		print ''
	end
end

--- Print an error message followed by a complete stack traceback.
function error_with_traceback(msg, bError)
	long_error(bError, msg..'\n')
	print_traceback()
end