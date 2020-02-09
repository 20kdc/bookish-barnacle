-- Conversion assistant
local file = io.open("to1bit/tmp.bin", "wb")
local fn = 1

while true do
	local idata
	pcall(function ()
		idata = love.image.newImageData("frames/" .. fn .. ".png")
	end)
	if not idata then break end

	local function getBit(x, y)
		local r, g, b = idata:getPixel(x, y)
		local luma = (r + g + b) / 3
		if luma > 0.5 then
			return 1
		end
		return 0
	end
	local function outputByte(startX, startY)
		local a = getBit(startX, startY)
		local b = getBit(startX + 1, startY) * 2
		local c = getBit(startX + 2, startY) * 4
		local d = getBit(startX + 3, startY) * 8
		local e = getBit(startX + 4, startY) * 16
		local f = getBit(startX + 5, startY) * 32
		local g = getBit(startX + 6, startY) * 64
		local h = getBit(startX + 7, startY) * 128
		file:write(string.char(a + b + c + d + e + f + g + h))
	end
	for y = 0, 59 do
		for x = 0, 9 do
			outputByte(x * 8, y)
		end
	end
	fn = fn + 1
end
file:close()
error("THERE IS NO ERROR. THANK YOU.")
