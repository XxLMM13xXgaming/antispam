// globals
local table = table

//-----------------------------------------------------------------------------
// Description: This checks if a table exists or not
// Input: table
// Returns: boolean
//-----------------------------------------------------------------------------
function table.Exists(_table)
	if type(_table) == "table" then
		return true
	end
	return false
end

//-----------------------------------------------------------------------------
// Description: This gets the number of keys in a table
// Input: table
// Returns: number
//-----------------------------------------------------------------------------
function table.GetNumKeys(_table)
local NumKeys = 0
	for k,v in pairs(_table) do
		NumKeys = NumKeys + 1
	end
	return tonumber(NumKeys)
end

//-----------------------------------------------------------------------------
// Description: This deletes a table
// Input: table
//-----------------------------------------------------------------------------
function table.Delete(_table)
	_table = nil
end

//-----------------------------------------------------------------------------
// Description: This clears all values and keys in a table
// Input: table
//-----------------------------------------------------------------------------
function table.Clear(_table)
	for k,v in pairs(_table) do
		table.remove(_table,tonumber(k))
	end
end

//-----------------------------------------------------------------------------
// Description: This gets the position (key) of the value
// Input: table,value
//-----------------------------------------------------------------------------
function table.ValueToKey(_table,value)
	for k,v in pairs(_table) do
		if v == value then
			return k
		end
	end
end

//-----------------------------------------------------------------------------
// Description: This returns the value of the position (key) 
// Input: table,key
//-----------------------------------------------------------------------------
function table.KeyToValue(_table,key)
	for k,v in pairs(_table) do
		if k == key then
			return v
		end
	end
end
