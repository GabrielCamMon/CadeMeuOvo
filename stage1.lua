
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()


local RouterX = 1
local tableBlocks = {}
tableButtonsCommand = {}
local tableEggs = {}

local IndexRun = 1
local TableMax = 0






local function endGame()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end



local function moveDuck(duck)

    

    TableMax = table.maxn(tableButtonsCommand)
     IndexRun = IndexRun +1
        if(IndexRun<=TableMax)then
            if RouterX+1 <= 3 then
                if(tableBlocks[RouterX].hasDuck == true) then
                    if(duck.south_east == true) then
                        RouterX = RouterX + 1
                        tableBlocks[RouterX-1].hasDuck = false
                        tableBlocks[RouterX].hasDuck = true 
                        display.remove(tableEggs[RouterX]);
                        transition.to( duck, { x=duck.x + tableBlocks[2].x - tableBlocks[1].x, y=duck.y + tableBlocks[2].y - tableBlocks[1].y,time = 500,onComplete = moveDuck} )
     
                    end
                end
            end 
        end    
end

local function buttonEventMoviment( event, buttonsCommand )
    local button = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus( button )
        button.touchOffsetX = event.x - button.x
        button.touchOffsetY = event.y - button.y
   
    elseif ( "moved" == phase ) then
        if(button.touchOffsetX ~= nil and button.touchOffsetY ~= nil )then
            button.x = event.x - button.touchOffsetX
            button.y = event.y - button.touchOffsetY
        end
    elseif ( "ended" == phase or "cancelled" == phase ) then
            local seta_frente = display.newImageRect(buttonsCommand,"imgs/seta_frente_semSombra.png",60,60)
            seta_frente.x = display.contentCenterX + 300;
            seta_frente.y = display.contentCenterY-100;
            seta_frente:addEventListener( "touch", buttonEventMoviment )
            
           
            local centralX = display.contentCenterX
            local centralY = display.contentCenterY
            local buttonTableMax =  table.maxn(tableButtonsCommand)
            local positionButton = table.indexOf(tableButtonsCommand,button)
            
            if ((button.x > (tableButtonsCommand[buttonTableMax].x + 30) and  button.x < (tableButtonsCommand[buttonTableMax].x + 75) and  button.y > (tableButtonsCommand[buttonTableMax].y - 38) and  button.y < (tableButtonsCommand[buttonTableMax].y + 38)) )then
                if(buttonTableMax == 1) then
                    button.x = tableButtonsCommand[buttonTableMax].x + 40
                    button.y = tableButtonsCommand[buttonTableMax].y
                else
                    button.x = tableButtonsCommand[buttonTableMax].x + 46
                    button.y = tableButtonsCommand[buttonTableMax].y
                end
                
                if (table.indexOf( tableButtonsCommand, button ))== nil then
                    table.insert(tableButtonsCommand, button)  
                end
               
            elseif((button.x > (centralX-300) and button.x < (centralX+140) and button.y < (centralY+173) and button.y > (centralY+100 )) == false)then
                display.remove(button)
                if (table.indexOf( tableButtonsCommand, button )~= nil) then
                    for var = positionButton, buttonTableMax, 1 do
                        table.remove(tableButtonsCommand)
                    end
                     
                end       
            end
     
      
        display.currentStage:setFocus( nil )
    end
    return true
end

function scene:create( event )

	local sceneGroup = self.view
    physics.pause()  

    local blockX = -100
    local blockY = 0

    local backGroup = display.newGroup()
    sceneGroup:insert( backGroup )
    local duck = display.newGroup() 
    sceneGroup:insert( duck )
    local eggs = display.newGroup() 
    local positionCommand = display.newGroup();
    sceneGroup:insert( positionCommand )
    local circleCommand = display.newGroup();
    sceneGroup:insert( circleCommand )
    local buttonsCommand = display.newGroup();
    sceneGroup:insert( buttonsCommand )

    local background = display.newImageRect( backGroup, "imgs/background.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local rectCommand = display.newRoundedRect( positionCommand ,display.contentCenterX - 60, display.contentCenterY + 135, 540, 75, 35 )
    rectCommand.strokeWidth = 1.5
    rectCommand:setStrokeColor( 0, 0, 0 )


    local myCircleShadow = display.newCircle( circleCommand, display.contentCenterX+178 , display.contentCenterY+ 137, 42 )
    myCircleShadow:setFillColor( 0, 0, 0, 0.5 )

    local myCircle = display.newCircle( circleCommand, display.contentCenterX+180 , display.contentCenterY+ 135, 40  )
    myCircle.fill = { type="image", filename="imgs/play.png" }

    local startDuck = display.newImageRect( buttonsCommand, "imgs/patoStartVerde.png", 46, 46 )
    startDuck.x = display.contentCenterX - 295
    startDuck.y = display.contentCenterY + 135


    local seta_frente = display.newImageRect(buttonsCommand, "imgs/seta_frente_semSombra.png",60,60)
    seta_frente.x = display.contentCenterX + 300;
    seta_frente.y = display.contentCenterY-100;
    seta_frente.name = "setafrente"


    local duck = display.newImageRect( duck, "imgs/pato-direita.png", 168/2.5, 143/2.5)
    physics.addBody( duck, "static" )
    duck.x = display.contentCenterX - 90
    duck.y = display.contentCenterY  - 40
    duck.north_east = false
    duck.north_west = false
    duck.south_east = true
    duck.south_west = false
    duck.myName = "duck"

    for  var = 3 ,1,-1 do
        local newBlocks = display.newImageRect( backGroup, "imgs/bloco.png", 168/2, 143/2)
        newBlocks.x = display.contentCenterX + blockX
        newBlocks.y = display.contentCenterY + blockY
        newBlocks.hasEgg = false
        newBlocks.hasDuck = false
       local egg = display.newImageRect( eggs, "imgs/egg.png", 366/12, 398/12 )
            newBlocks.hasEgg = true
            egg.x = display.contentCenterX + blockX 
            egg.y = display.contentCenterY + blockY - 30
            egg.status = varCreate
            table.insert(tableEggs, egg); 
            table.insert(tableBlocks, newBlocks)
    
            tableBlocks[1].hasDuck = true
            display.remove(tableEggs[1])
    
            blockX = blockX + 40        
            blockY = blockY + 17
    end


    table.insert(tableButtonsCommand, startDuck)
    local funcDuck = function()moveDuck(duck) end


    local funcButton = function(buttonsCommand)
        return function(event)
            buttonEventMoviment(event,buttonsCommand)
        end
    end
    myCircle:addEventListener( "tap", funcDuck )
    seta_frente:addEventListener( "touch", funcButton(buttonsCommand))
    

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

    if ( phase == "will" ) then
        
        
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then


	elseif ( phase == "did" ) then

		physics.pause()
		composer.removeScene( "stage1" )
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
