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
	
	Hooks[ event_name ][ name ] = {CustomGameEventManager:RegisterListener(event_name, func), func}
	GameRules.custom_hooks = Hooks
end


--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function hook.Remove( event_name, name )
	if ( not isstring( event_name ) ) then return end
	if ( not Hooks[ event_name ] ) then return end
	
	local id = Hooks[ event_name ][ name ]
	Hooks[ event_name ][ name ] = nil
	
	CustomGameEventManager:UnregisterListener(id)
	id = nil
end

--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function hook.Run( name, ... )

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
				a, b, c, d, e, f = v[2]( ... )

			else
				if ( IsValid(k) ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					a, b, c, d, e, f = v[2]( k, ... )
				else
					--
					-- If the object has become invalid - remove it
					--
					HookTable[ k ] = nil
					CustomGameEventManager:UnregisterListener(v[1])
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
end

function hook.RemoveAll()
	if table.IsEmpty(GameRules.custom_hooks) then return end
	
	for k, data in pairs(GameRules.custom_hooks or {}) do
		for k2, v in pairs(data) do
			if v[1] then
				CustomGameEventManager:UnregisterListener(v[1])
			end
		end
	end
	
	GameRules.custom_hooks = nil
end

function hook.Init()
	hook.RemoveAll()
end

if hook.Init then
	hook.Init()
	hook.Init = nil
end