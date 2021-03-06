
local composer = require( "composer" )

local statusMusic = require("statusmusic")

local scene = composer.newScene()

local restart = require( "restart" )

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
    {name = "frente_direita",frames ={1}},
    {name = "frente_esquerda",frames ={2}},
    {name = "costa_direita",frames ={3}},
    {name = "costa_direita",frames ={4}},
}

local RouterX = 1
local tableBlocks = {}
local tableButtonsCommand = {}
local tableEggs = {}

local IndexRun = 1
local TableMax = 0
local contEggs = 2

local function gotoMenu()
     composer.removeScene("stage1")
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function nextStage()
     
     composer.removeScene("stage1")
    composer.gotoScene( "stage2", { time=800, effect="crossFade" } )
end


local function repeatStage()

    composer.removeScene("stage1")
    restart:getName("stage1")
    composer.gotoScene( "restart"  )  
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
        display.remove(tableEggs[RouterX])
        local yStep = tableBlocks[2].y - tableBlocks[1].y
        transition.to( duck, { x=duck.x + (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y + (yStep + yStep/2),time = 250,onComplete = removeEggs} )
      
    end
    TableMax = table.maxn(tableButtonsCommand)
    IndexRun = IndexRun +1
    if(IndexRun<=TableMax)then
        if RouterX+1 <= 3 then
            if(tableBlocks[RouterX].hasDuck == true) then
                if(duck.south_east == true) then
                    RouterX = RouterX + 1
                    tableBlocks[RouterX-1].hasDuck = false
                    tableBlocks[RouterX].hasDuck = true 
                    if(tableBlocks[RouterX].hasEgg == true)then
                    
                    tableBlocks[RouterX].hasEgg = false
                    contEggs = contEggs - 1
                    end
                    transition.to( duck, { x=duck.x + (tableBlocks[2].x - tableBlocks[1].x)/2, y=duck.y - (tableBlocks[2].y - tableBlocks[1].y)/2,time = 250,onComplete = moveDuckstep2} )
                    
                end
            end
        end 
    end    
end

local function buttonEventMoviment( event, buttonsCommand, seta_frente )
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
            seta_frente.x = display.contentWidth - 300;
            seta_frente.y = 200;
            seta_frente:scale(3,3)

            local funcButton = function(buttonsCommand,seta_frente)
                return function(event)
                    buttonEventMoviment(event,buttonsCommand,seta_frente)
                end
            end

            seta_frente:addEventListener( "touch",funcButton(buttonsCommand,seta_frente))
            
           
            local centralX = display.contentCenterX
            local centralY = display.contentCenterY
            local buttonTableMax =  table.maxn(tableButtonsCommand)
            local positionButton = table.indexOf(tableButtonsCommand,button)
            
            if ((button.x > (tableButtonsCommand[buttonTableMax].x + 90) and  button.x < (tableButtonsCommand[buttonTableMax].x + 225) and  button.y > (tableButtonsCommand[buttonTableMax].y - 114) and  button.y < (tableButtonsCommand[buttonTableMax].y + 114)) )then
                if(buttonTableMax == 1) then
                    button.x = tableButtonsCommand[buttonTableMax].x + 120
                    button.y = tableButtonsCommand[buttonTableMax].y
                else
                    button.x = tableButtonsCommand[buttonTableMax].x + 138
                    button.y = tableButtonsCommand[buttonTableMax].y
                end
                
                if (table.indexOf( tableButtonsCommand, button ))== nil then
                    table.insert(tableButtonsCommand, button)  
                end
              
            elseif((button.x > (centralX-750) and button.x < (centralX+550) and button.y < (centralY+420) and button.y > (centralY+200)) == false)then
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

   --  display.newRect(display.contentCenterX-750, display.contentCenterY+200,50,50):setFillColor( 0, 0, 0 )
  --   display.newRect(display.contentCenterX+550, display.contentCenterY+200,50,50):setFillColor( 0, 0, 0 )
    -- display.newRect(display.contentCenterX+550, display.contentCenterY+420,50,50):setFillColor( 0, 0, 0 )
    -- display.newRect(display.contentCenterX-750, display.contentCenterY+420,50,50):setFillColor( 0, 0, 0 )
        

	local sceneGroup = self.view
    physics.pause()  

    local blockX = -100
    local blockY = 0

    local backGroup = display.newGroup()
    sceneGroup:insert( backGroup )
    
    local duckGroup = display.newGroup() 
    sceneGroup:insert( duckGroup )
    local eggs = display.newGroup() 
    sceneGroup:insert( eggs )
  

    local positionCommand = display.newGroup();
    sceneGroup:insert( positionCommand )
    local circleCommand = display.newGroup();
    sceneGroup:insert( circleCommand )
    local buttonsCommand = display.newGroup();
    sceneGroup:insert( buttonsCommand )


    local configGroup = display.newGroup()
    sceneGroup:insert( configGroup )

    local iconMenu = display.newImageRect( configGroup, "imgs/home.png",100,100 )
    iconMenu.x = 200
    iconMenu.y =  110

    local iconMusic = display.newRect( configGroup,340,110,90,90 )
    if(statusMusic.myName == "play")then
    iconMusic.fill = { type="image", filename="imgs/note_audio_music.png" }
    else
        iconMusic.fill = { type="image", filename="imgs/note_audio_music_cut.png" }
    end

    local background = display.newImageRect( backGroup, "imgs/background.png",display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local rectCommand = display.newRoundedRect( positionCommand ,display.contentCenterX , display.contentCenterY + 310, 540, 75, 35 )
    rectCommand.strokeWidth = 1.5
    rectCommand:setStrokeColor( 0, 0, 0 )
    rectCommand:scale(3,3)

    local myCircleShadow = display.newCircle( circleCommand, display.contentCenterX+693 , display.contentCenterY+ 312, 42 )
    myCircleShadow:setFillColor( 0, 0, 0, 0.5 )
    myCircleShadow:scale(3,3)

    local myCircle = display.newCircle( circleCommand, display.contentCenterX+695 , display.contentCenterY+ 310, 40  )
    myCircle.fill = { type="image", filename="imgs/play_menu.png" }
    myCircle.myName = "play"
    myCircle:scale(3,3)

    local startDuck = display.newImageRect( buttonsCommand, "imgs/patoStartVerde.png", 46, 46 )
    startDuck.x = display.contentCenterX - 695
    startDuck.y = display.contentCenterY + 310
    startDuck:scale(3,3)

    local seta_frente = display.newImageRect(buttonsCommand, "imgs/seta_frente_semSombra.png",60,60)
    seta_frente.x = display.contentWidth - 300;
    seta_frente.y = 200;
    seta_frente.name = "setafrente"
    seta_frente:scale(3,3)


    local duck = display.newSprite( duckGroup, objectSheet, sequenceData)
    physics.addBody( duck, "static" )
    duck.x = display.contentCenterX - 100
    duck.y = display.contentCenterY  - 200
    duck.north_east = false
    duck.north_west = false
    duck.south_east = true
    duck.south_west = false
    duck.myName = "duck"
    duck:scale(0.90,0.72)

    duck:setSequence("frente_direita")

    for  var = 3 ,1,-1 do
        local newBlocks = display.newImageRect( backGroup, "imgs/bloco.png", 168/2, 143/2)
        newBlocks.x = display.contentCenterX + blockX
        newBlocks.y = display.contentCenterY + blockY - 90
        newBlocks.hasEgg = false
        newBlocks.hasDuck = false
        newBlocks:scale(3,3)
       local egg = display.newImageRect( eggs, "imgs/egg.png", 366/12, 398/12 )
            newBlocks.hasEgg = true
            egg.x = display.contentCenterX + blockX 
            egg.y = display.contentCenterY + blockY - 180
            egg:scale(3,3)
            table.insert(tableEggs, egg); 
            table.insert(tableBlocks, newBlocks)
    
            tableBlocks[1].hasDuck = true
            display.remove(tableEggs[1])
    
            blockX = blockX + 120        
            blockY = blockY + 51
    end


    table.insert(tableButtonsCommand, startDuck)

    local iconFunc = function (event)
        local icon = event.target

        while(true)do
            if(statusMusic.myName == "play")then
                icon.fill = { type="image", filename="imgs/note_audio_music_cut.png" }
                statusMusic.myName = "stop"
                audio.pause( musicTrack )
                break
            elseif(statusMusic.myName == "stop")then
                icon.fill = { type="image", filename="imgs/note_audio_music.png" }
                statusMusic.myName = "play"
                musicTrack = audio.loadStream( "audio/patoMusic.mp3" )
                audio.resume( musicTrack )
                break
            end
        end
    end
    
    local funcDuck = function()
        myCircle.fill = { type="image", filename="imgs/stop.png" }
        if(myCircle.myName == "play")then
            myCircle.myName = "stop"
            return moveDuck(duck) 
        else
            return repeatStage()
        end
        
    end


    local funcButton = function(buttonsCommand,seta_frente)
        return function(event)
            buttonEventMoviment(event,buttonsCommand,seta_frente)
        end
    end
    myCircle:addEventListener( "tap", funcDuck )
    seta_frente:addEventListener( "touch", funcButton(buttonsCommand,seta_frente))

    iconMusic:addEventListener("tap", iconFunc )
    iconMenu:addEventListener("tap", gotoMenu )
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
