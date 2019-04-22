
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()

local sheetOptions =
{
    frames =
    {
        {   -- 1)  frente direita
            x = 0,
            y = 0,
            width = 235, 
            height = 250
        },
        {   -- 2) frente esquerda
           x = 0,
            y = 260,
            width = 235, 
            height = 250
        },
        {   -- 3) costa esquerda
            x = 0,
            y = 530,
            width = 235, 
            height = 270
        },
        {   -- 4) costa direita
            x = 0,
            y = 820,
            width = 235, 
            height = 270
        }
        
    },
}

local objectSheet = graphics.newImageSheet( "imgs/sprite_pato.png", sheetOptions )

local sequenceData = {
    {name = 1,frames ={1}},
    {name = 2,frames ={2}},
    {name = 3,frames ={3}},
    {name = 4,frames ={4}},
}

local RouterX = 0
local RouterY=0
local tableBlocks = {}
local tableButtonsCommand = {}
local tableEggs = {}

local IndexRun = 1
local TableMax = 0
local contEggs = 1


local function nextStage()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function repeatStage()
    composer.removeScene("stage3")
    composer.gotoScene( "restart3"  )  
end


local function moveDuck(duck)
    
    local  removeEggs = function(duck)
        if(contEggs == 0)then
        nextStage()
        else
        moveDuck(duck)
        end
    end
    local  moveDuckstep2 = function(duck) 

        local yStep = tableBlocks[2].y - tableBlocks[1].y

        if(duck.south_east)then
            if(tableBlocks[RouterX+1].hasEgg)then
                tableBlocks[RouterX+1].hasEgg = false
                contEggs = contEggs - 1
                display.remove(tableEggs[RouterX+1])
            end
            transition.to( duck, { x=duck.x + (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y + (yStep + yStep/2),time = 250,onComplete = removeEggs} )
        elseif(duck.south_west)then
            if(RouterX == 3 and RouterY == -1 )then
                contEggs = contEggs - 1
                display.remove(tableEggs[5])
            end
            transition.to( duck, { x=duck.x - (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y + (yStep + yStep/2),time = 250,onComplete = removeEggs} )
        elseif(duck.north_west)then
            transition.to( duck, { x=duck.x - (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y-6.5 + (yStep - yStep/2),time = 250,onComplete = removeEggs} )
        elseif(duck.north_east)then
            contEggs = contEggs - 1
            transition.to( duck, { x=duck.x - (tableBlocks[2].x - tableBlocks[1].x)/2,
             y=duck.y-6.5 + (yStep - yStep/2),
             time = 250,
             onComplete = removeEggs} )
        end

    end

    local moveDuckSimpleJump = function(duck)
        transition.to(duck, {y = duck.y + (tableBlocks[2].y - tableBlocks[1].y)/2, time = 250,onComplete=removeEggs})
    end
    IndexRun = IndexRun +1
   
    if((tableButtonsCommand[IndexRun]== nil)== false)then
        if(tableButtonsCommand[IndexRun].myName == "setafrente")then
            if(duck.south_east) then
                if RouterX+1 <= 3 then
                    RouterX = RouterX + 1
                    transition.to( duck, { x=duck.x + (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y - (tableBlocks[2].y - tableBlocks[1].y)/2,time = 250,onComplete = moveDuckstep2} )
                else
                    transition.to(duck, {y = duck.y - (tableBlocks[2].y - tableBlocks[1].y)/2, time =  250,onComplete= moveDuckSimpleJump})
                end
            elseif(duck.south_west)then
                if RouterX == 3 then
                    RouterY = RouterY - 1
                    transition.to( duck, { x=duck.x - (tableBlocks[2].x - tableBlocks[1].x)/2,  y=duck.y - (tableBlocks[2].y - tableBlocks[1].y)/2,time = 250, onComplete= moveDuckstep2} )
                else
                    transition.to(duck, {y = duck.y - (tableBlocks[2].y - tableBlocks[1].y)/2, time =  250,onComplete= moveDuckSimpleJump})
                end
            elseif(duck.north_west)then
                if RouterX-1 >= 0 then
                    RouterX = RouterX -1
                    transition.to( duck, { x=duck.x - (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y - (tableBlocks[2].y - tableBlocks[1].y),time = 250, onComplete= moveDuckstep2} )
                else
                    transition.to(duck, {y = duck.y - (tableBlocks[2].y - tableBlocks[1].y)/2, time =  250,onComplete= moveDuckSimpleJump})
                end
            else

                transition.to( duck, 
                { 
                x=duck.x - (tableBlocks[2].x - tableBlocks[1].x)/2, 
                y=duck.y - (tableBlocks[2].y - tableBlocks[1].y),
                time = 250, 
                onComplete= moveDuckstep2
            } )
            end
        elseif(tableButtonsCommand[IndexRun].myName == "setagiro")then
            while(true)do
                if(duck.south_east)then
                    duck:setSequence(2) 
                    duck.south_east= false
                    duck.south_west= true
                    break
                elseif(duck.south_west)then
                    duck:setSequence(3)
                    duck.south_west = false
                    duck.north_west= true
                    break
                elseif(duck.north_west)then
                    duck:setSequence(4)
                    duck.north_west = false
                    duck.north_east= true
                    break
                else
                    duck:setSequence(1)
                    duck.north_east = false
                    duck.south_east= true
                    break
                end
            end
            local funcDelay = function() moveDuck(duck) end

            timer.performWithDelay( 500, funcDelay)
        end
    end    
end



local function buttonEventMovimentFrente( event, buttonsCommand, seta_frente )
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
            seta_frente = display.newImageRect(buttonsCommand,"imgs/seta_frente_semSombra.png",60,60)
            seta_frente.x = display.contentCenterX + 300;
            seta_frente.y = display.contentCenterY-100;
            seta_frente.myName = "setafrente"
          

            local funcButton = function(buttonsCommand,seta_frente)
                return function(event)
                    buttonEventMovimentFrente(event,buttonsCommand,seta_frente)
                end
            end

            seta_frente:addEventListener( "touch",funcButton(buttonsCommand,seta_frente))
            
           
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

local function buttonEventMovimentGiro( event, buttonsCommand, seta_giro )
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
        seta_giro = display.newImageRect(buttonsCommand, "imgs/seta_girar_semSobra.png",60,60)
        seta_giro.x = display.contentCenterX + 300;
        seta_giro.y = display.contentCenterY-40;
        seta_giro.myName = "setagiro"
       
            local funcButtonGiro = function(buttonsCommand,seta_giro)
                return function(event)
                    buttonEventMovimentGiro(event,buttonsCommand,seta_giro)
                end
            end

            seta_giro:addEventListener( "touch",funcButtonGiro(buttonsCommand,seta_giro))
            
           
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

    local blockX = 0
    local blockY = 0

    local backGroup = display.newGroup()
    sceneGroup:insert( backGroup )
    
    local eggs = display.newGroup() 
    sceneGroup:insert( eggs )

    local duckGroup = display.newGroup() 
    sceneGroup:insert( duckGroup )
   
  

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
    myCircle.myName = "play"

    local startDuck = display.newImageRect( buttonsCommand, "imgs/patoStartVerde.png", 46, 46 )
    startDuck.x = display.contentCenterX - 295
    startDuck.y = display.contentCenterY + 135


    local seta_frente = display.newImageRect(buttonsCommand, "imgs/seta_frente_semSombra.png",60,60)
    seta_frente.x = display.contentCenterX + 300;
    seta_frente.y = display.contentCenterY-100;
    seta_frente.myName = "setafrente"

    local seta_giro = display.newImageRect(buttonsCommand, "imgs/seta_girar_semSobra.png",60,60)
    seta_giro.x = display.contentCenterX + 300;
    seta_giro.y = display.contentCenterY-40;
    seta_giro.myName = "setagiro"


    local duck = display.newSprite( duckGroup, objectSheet, sequenceData)
    physics.addBody( duck, "static" )
    duck.x = display.contentCenterX - 30
    duck.y = display.contentCenterY - 14
    duck.north_east = false
    duck.north_west = false
    duck.south_east = true
    duck.south_west = false
    duck.myName = "duck"
    duck:scale(0.24,0.18)

 
    
        local newBlocks = display.newImageRect( backGroup, "imgs/bloco.png", 168, 143)
        newBlocks.x = display.contentCenterX + blockX
        newBlocks.y = display.contentCenterY + blockY
        newBlocks.hasEgg = false
        newBlocks.hasDuck = false
        newBlocks:scale(0.4,0.4)
       local egg = display.newImageRect( eggs, "imgs/egg.png", 366/14, 398/14 )
            newBlocks.hasEgg = true
            egg.x = display.contentCenterX + blockX 
            egg.y = display.contentCenterY + blockY - 25
            egg.status = varCreate
            table.insert(tableEggs, egg); 
            table.insert(tableBlocks, newBlocks)

            blockX = blockX - 30        
            blockY = blockY + 13
   
    local newBlocks = display.newImageRect( backGroup, "imgs/bloco.png", 168, 143)
        newBlocks.x = display.contentCenterX + blockX
        newBlocks.y = display.contentCenterY + blockY
        newBlocks.hasEgg = false
        newBlocks.hasDuck = false
        newBlocks:scale(0.4,0.4)
       local egg = display.newImageRect( eggs, "imgs/egg.png", 366/14, 398/14 )
            newBlocks.hasEgg = true
            egg.x = display.contentCenterX + blockX 
            egg.y = display.contentCenterY + blockY - 25
            egg.status = varCreate
            table.insert(tableEggs, egg); 
            table.insert(tableBlocks, newBlocks)
    
            tableBlocks[1].hasDuck = true
            display.remove(tableEggs[2])
    
            



    table.insert(tableButtonsCommand, startDuck)
    
    local funcDuck = function()
        myCircle.fill = { type="image", filename="imgs/stop.png" }
        if(myCircle.myName == "play")then
            myCircle.myName = "stop"
            return moveDuck(duck) 
        else
            return repeatStage()
        end
        
    end


    local funcButtonFrente = function(buttonsCommand,seta_frente)
        return function(event)
            buttonEventMovimentFrente(event,buttonsCommand,seta_frente)
        end
    end

    local funcButtonGiro = function(buttonsCommand,seta_giro)
        return function(event)
            buttonEventMovimentGiro(event,buttonsCommand,seta_giro)
        end
    end
    myCircle:addEventListener( "tap", funcDuck )

    seta_frente:addEventListener( "touch", funcButtonFrente(buttonsCommand,seta_frente))

    seta_giro:addEventListener( "touch", funcButtonGiro(buttonsCommand,seta_giro))
    

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
		composer.removeScene( "stage3" )
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