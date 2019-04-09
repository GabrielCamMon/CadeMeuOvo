-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require( "physics" )
physics.start()


display.setStatusBar( display.HiddenStatusBar )

 




--posicao blocos








    
       







    



 
--local vertices = { 0,-35, 27,-35, 43,-35, 43,16, 43,90, 0,90, -65,90, -65,15, -65,-35, -27,-35, }

--  local teste= display.newRect(startDuck.x + 15, startDuck.y-23 , 10,10);
-- teste:setFillColor(0,0,0,0.5)

-- local teste2= display.newRect(startDuck.x + 15, startDuck.y+23 , 10,10);
--  teste2:setFillColor(0,0,0)

-- local teste3= display.newRect(startDuck.x + 60, startDuck.y+23 , 10,10);
-- teste3:setFillColor(0,0,0,0.5)

-- local teste4= display.newRect(startDuck.x + 60, startDuck.y-23, 10,10);
-- teste4:setFillColor(0,0,0,0.5)



local function buttonEventMoviment( event )
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
            seta_frente = display.newImageRect(buttonsCommand, "imgs/seta_frente_semSombra.png",60,60)
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
                        table.remove(tableButtonsCommand, positionButton)
                    end
                     
                end       
            end
     
      
        display.currentStage:setFocus( nil )
    end
    return true
end
















