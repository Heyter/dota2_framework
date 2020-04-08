if not hook then
	hook = {}
end

local Hooks = {}

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function hook.GetTable() return Hooks end


--[[---------------------------------------------------------
    Name: Add
    Args: string hookName, any identifier, function func
    Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function hook.Add( event_name, name, func )
	if ( not isfunction( func ) ) then return end
	if ( not isstring( event_name ) ) then return end

	if (Hooks[ event_name ] == nil) then
		Hooks[ event_name ] = {}
	end

	Hooks[ event_name ][ name ] = func
end


--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function hook.Remove( event_name, name )
	if ( not isstring( event_name ) ) then return end
	if ( not Hooks[ event_name ] ) then return end

	Hooks[ event_name ][ name ] = nil
end

--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function hook.Run( name, ... )
	return hook.Call( name, gamemode and gamemode.Get() or nil, ... )
end

--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function hook.Call( name, gm, ... )

	--
	-- Run hooks
	--
	local HookTable = Hooks[ name ]
	if ( HookTable ~= nil ) then
	
		local a, b, c, d, e, f;

		for k, v in pairs( HookTable ) do 
			
			if ( isstring( k ) ) then
				
				--
				-- If it's a string, it's cool
				--
				a, b, c, d, e, f = v( ... )

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( k ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					a, b, c, d, e, f = v( k, ... )
				else
					--
					-- If the object has become invalid - remove it
					--
					HookTable[ k ] = nil
				end
			end

			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if ( a ~= nil ) then
				return a, b, c, d, e, f
			end
				
		end
	end
	
	--
	-- Call the gamemode function
	--
	if ( not gm ) then return end
	
	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end
			
	return GamemodeFunction( gm, ... )        
	
end