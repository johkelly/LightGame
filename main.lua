function love.load()
   kuroko = love.graphics.newImage("images/kuroko.png")
   x = 100
   y = 100
end
function love.draw()
   love.graphics.draw(kuroko, x, y)
end
