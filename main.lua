-- to simplify things, the data is stored w/ X as pixel ptr, Y as time.
-- this may limit it to ~8192 frames though
local frameSize = 600
local frameData = love.filesystem.read("video.bin")
local maxFrames = math.floor(#frameData / frameSize)
frameTexture = love.graphics.newImage(love.image.newImageData(frameSize / 4, maxFrames, "rgba8", frameData))
frameTexture:setFilter("nearest", "nearest")
frameTexture:setWrap("clamp", "clamp")

local shader = love.graphics.newShader("pixel.glsl")
local audioAndTiming = love.audio.newSource("music.ogg", "static")

function love.update(time)
	if not audioAndTiming:isPlaying() then
		audioAndTiming:seek(0)
		audioAndTiming:play()
	end
end

function love.draw()
	love.graphics.setShader(shader)
	shader:send("musicTime", audioAndTiming:tell())
	love.graphics.draw(frameTexture, love.graphics.newQuad(0, 0, 800, 600, 1, 1))
	love.graphics.setShader()
end

