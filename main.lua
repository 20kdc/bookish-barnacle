local video = love.filesystem.read("video.txt"):gsub("[\x01-\x1F]", "")

-- to simplify things, the data is stored w/ X as pixel ptr, Y as time.
-- this may limit it to ~8192 frames though
local frameSize = 600

local frameTexture

pcall(function()
	frameTexture = love.graphics.newImage("videos/" .. video .. "/video.png")
end)

if not frameTexture then
	local frameData = love.filesystem.read("videos/" .. video .. "/video.bin")
	local data = love.image.newImageData(frameSize / 4, math.floor(#frameData / frameSize), "rgba8", frameData)
	-- useful for frying
	local tmp = io.open("videos/" .. video .. "/video.png", "wb")
	if tmp then
		tmp:write(data:encode("png"):getString())
		tmp:close()
	end
	frameTexture = love.graphics.newImage(data)
end

frameTexture:setFilter("nearest", "nearest")
frameTexture:setWrap("clamp", "clamp")

local maxFrames = frameTexture:getHeight()

local fps = love.filesystem.read("videos/" .. video .. "/fps.txt"):gsub("[\x01-\x1F]", "")
fps = tonumber(fps)

local shader = love.graphics.newShader("pixel.glsl")
local audioAndTiming = love.audio.newSource("videos/" .. video .. "/music.ogg", "static")

function love.update(time)
	if not audioAndTiming:isPlaying() then
		audioAndTiming:seek(0)
		audioAndTiming:play()
	end
end

function love.draw()
	love.graphics.setShader(shader)
	shader:send("musicTime", ((audioAndTiming:tell() * fps) + 0.5) / maxFrames)
	love.graphics.draw(frameTexture, love.graphics.newQuad(0, 0, 800, 600, 1, 1))
	love.graphics.setShader()
end

