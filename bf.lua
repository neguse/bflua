
local VM = {}
VM.__index = VM

function VM.new(input, output)
	local self = setmetatable({}, VM)
	self.pointer = 0
	self.array = {}
	for i = 0, 30000 do
		self.array[i] = 0
	end
	self.input = input
	self.output = output
	return self
end

function VM.run(self, insn)
	for i, node in ipairs(insn) do
		if type(node) == "table" then
			while self.array[self.pointer] ~= 0 do
				self:run(node)
			end
		else
			if node == '>' then
				self.pointer = self.pointer + 1
			elseif node == '<' then
				self.pointer = self.pointer - 1
			elseif node == '+' then
				self.array[self.pointer] = self.array[self.pointer] + 1
			elseif node == '-' then
				self.array[self.pointer] = self.array[self.pointer] - 1
			elseif node == '.' then
				self.output:write(string.char(self.array[self.pointer]))
			elseif node == ',' then
				ch = self.input:read(1)
				if ch == nil then
					self.array[self.pointer] = 0
				else
					self.array[self.pointer] = string.byte(ch)
				end
			end
		end
	end
end

-- return true if c is member of list
function include(c, list)
	for i, m in ipairs(list) do
		if c == m then
			return true
		end
	end
	return false
end

function parse(input, level)
	local tree={}
	while true do
		local ch = input:read(1)
		if ch == nil then
			break
		elseif include(ch, {'>', '<', '+', '-', '.', ','}) then
			table.insert(tree, ch)
		elseif ch == '[' then
			inner = parse(input, level + 1)
			table.insert(tree, inner)
		elseif ch == ']' then
			assert(0 < level, "close bracket mismatch.")
			break
		end
	end
	return tree
end

function dumptree(output, tree, level)
	for i, node in ipairs(tree) do
		local tnode = type(node)
		if tnode == 'table' then
			io.write(string.rep(' ', level))
			io.write("[\n")
			dumptree(output, node, level + 1)
			io.write(string.rep(' ', level))
			io.write("]\n")
		else
			io.write(string.rep(' ', level))
			io.write(node)
			io.write("\n")
		end
	end
end

function compiletree(output, tree, level)
	if level == 0 then
		output:write([[
local pointer = 0
local array = {}
for i = 0, 30000 do
array[i] = 0
end
]])
	end
	for i, node in ipairs(tree) do
		if type(node) == "table" then
			output:write("while array[pointer]~=0 do\n")
			compiletree(output, node, level + 1)
			output:write("end\n")
		else
			if node == '>' then
				output:write("pointer = pointer + 1\n")
			elseif node == '<' then
				output:write("pointer = pointer - 1\n")
			elseif node == '+' then
				output:write("array[pointer] = array[pointer] + 1\n")
			elseif node == '-' then
				output:write("array[pointer] = array[pointer] - 1\n")
			elseif node == '.' then
				output:write("io.output():write(string.char(array[pointer]))\n")
			elseif node == ',' then
				output:write("array[pointer] = string.byte(io.input():read(1))\n")
			end
		end
	end
end

function compiletree_c(output, tree, level)
	if level == 0 then
		output:write([[
#include <stdio.h>
int main(void) {
int pointer = 0;
int array[30000] = {0};
]])
	end
	for i, node in ipairs(tree) do
		if type(node) == "table" then
			output:write("while (array[pointer]!=0) {\n")
			compiletree_c(output, node, level + 1)
			output:write("}\n")
		else
			if node == '>' then
				output:write("pointer++;\n")
			elseif node == '<' then
				output:write("pointer--;\n")
			elseif node == '+' then
				output:write("array[pointer]++;\n")
			elseif node == '-' then
				output:write("array[pointer]--;\n")
			elseif node == '.' then
				output:write("putchar(array[pointer]);\n")
			elseif node == ',' then
				output:write("array[pointer] = getchar();\n")
			end
		end
	end
	if level == 0 then
		output:write([[
return 0;
}
]])
	end
end

mode = arg[1]
lang = arg[2]

local tree = parse(io.input(), 0)

if mode == nil or mode == "-e" then
	vm = VM.new(io.input(), io.output())
	vm:run(tree)
elseif mode == "-p" then
	dumptree(io.output(), tree, 0)
elseif mode == "-c" then
	if lang == nil or lang == "lua" then
		compiletree(io.output(), tree, 0)
	elseif lang == "c" then
		compiletree_c(io.output(), tree, 0)
	end

end

