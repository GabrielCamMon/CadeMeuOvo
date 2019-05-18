
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "stage1", { time=800, effect="crossFade" } )
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "imgs/background.png", display.contentWidth, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY


  local myCircleShadow = display.newCircle(  sceneGroup, display.contentCenterX+2, display.contentCenterY+100, 230)
    myCircleShadow:setFillColor( 0, 0, 0, 0.5 )
 
    local playButton = display.newImageRect( sceneGroup, "imgs/play_menu.png", 150, 150 )
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY+ 100
	playButton:scale(3,3)

	local displayText = display.newText( sceneGroup,"Duck's Eggs", display.contentCenterX - 120,display.contentCenterY-300, "Breathe/Breathe-Press.ttf", 300 )
	displayText:setTextColor( 0, 0, 0 )

	local egg = display.newImageRect( sceneGroup, "imgs/eggMenu.png", 260, 354 )
	egg.x = display.contentCenterX + 600
	egg.y = display.contentCenterY -300
	

	playButton:addEventListener( "tap", gotoGame )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
