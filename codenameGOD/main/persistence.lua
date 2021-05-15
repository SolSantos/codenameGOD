local function exportstring( s )
	return string.format("%q", s)
end

local function file_exists(filename)
	return os.rename(filename, filename) and true or false
end

local function load_table(filename)
	if not file_exists(filename) then
		return nil, "The received file does not exist"
	end

	return dofile(filename), nil
end

local get_table_text
get_table_text = function(tbl, indent)
	local text = {}
	table.insert(text, "{\n")
	for k, v in pairs(tbl) do
		for i=1, indent do
			table.insert(text, "  ")
		end
		
		-- Write key
		if type(k) == "string" then
			table.insert(text, "[")
			table.insert(text, exportstring(k))
			table.insert(text, "]=")
		elseif type(k) == "number" then
			table.insert(text, "[")
			table.insert(text, "tostring(k)")
			table.insert(text, "]=")
		end

		-- Write value
		if type(v) == "table" then
			table.insert(text, get_table_text(v, indent+1))
			table.insert(text, ",\n")
		elseif type(v) == "userdata" then
			table.insert(text, "nil,\n")
		elseif type(v) == "string" then
			table.insert(text, exportstring(v))
			table.insert(text, ",\n")
		elseif type(v) == "number" then
			table.insert(text, tostring(v))
			table.insert(text, ",\n")
		elseif type(v) == "boolean" then
			if v then 
				table.insert(text, "true,\n")
			else 
				table.insert(text, "false,\n")
			end
		end
	end
	for i=1, indent-1 do
		table.insert(text, "  ")
	end
	table.insert(text, "}")
	return table.concat(text, "")
end

-- To make the save_table implementation simpler some restrictions were defined
-- It does not support tables in the keys
-- It ignores userdata in values and writes nil instead
-- Only supports tables that are key/value, not arrays
local function save_table2(filename, tbl)
	local file, err = io.open(filename, "w")
	if err then
		print("Failed saving the table to "..filename)
		return false, err
	end

	file:write("return "..get_table_text(tbl, 1))
	file:close()
	return true, nil
end

return {
	load_table = load_table,
	save_table = save_table2
}