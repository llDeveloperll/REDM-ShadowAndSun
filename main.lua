--[[
    Enhanced Sun and Shadow Detection Script
    Version: 2.0.0
    Author: Original code enhanced by Vilão.dev
    License: MIT
    
    This script provides advanced sun position calculation and shadow detection
    with extensive debugging capabilities and performance optimizations.
]]

local Config, Debug, VisualDebug, SunCalculator, ShadowDetector;

-- Configuration and constants
Config = {
    debugMode = true,           -- Enable visual debugging and logging
    checkInterval = 1,        -- How often to check shadow status (ms)
    dayTimeStart = 6.0,         -- When day begins (24hr format)
    dayTimeEnd = 20.0,          -- When day ends (24hr format)
    sunDistance = 60.0,         -- Distance multiplier for sun position
    debugTextScale = 0.35,      -- Scale of debug text
    debugColors = {
        inShadow = {255, 0, 0, 255},    -- Red
        inSunlight = {0, 255, 0, 255},  -- Green
        text = {255, 255, 255, 255}     -- White
    }
}

-- Debug utilities
Debug = {
    ---Logs a message if debug mode is enabled
    ---@param message string The message to log
    ---@param ... any Additional values to print
    log = function(message, ...)
        if Config.debugMode then
            print(string.format("[SunShadow] " .. message, ...))
        end
    end,

    ---Creates a formatted string of a vector3-like table
    ---@param vec table Table with x, y, z components
    ---@return string
    formatVector = function(vec)
        return string.format("(%.2f, %.2f, %.2f)", vec.x, vec.y, vec.z)
    end
}

-- Visual debugging utilities
VisualDebug = {
    ---Draws a debug line in the game world
    ---@param startCoords table Starting coordinates (vector3 format)
    ---@param endCoords table Ending coordinates (vector3 format)
    ---@param color table Table containing {r, g, b, a} values
    drawLine = function(startCoords, endCoords, color)
        DrawLine(
            startCoords.x, startCoords.y, startCoords.z,
            endCoords.x, endCoords.y, endCoords.z,
            color[1], color[2], color[3], color[4]
        )
    end,

    ---Draws text on the screen with enhanced visibility
    ---@param text string Text to display
    ---@param position table Table containing x, y screen coordinates
    ---@param color table Table containing {r, g, b, a} values
    drawText = function(text, position, color)
        SetTextScale(Config.debugTextScale, Config.debugTextScale)
        SetTextColor(color[1], color[2], color[3], color[4])
        SetTextDropshadow(3, 0, 0, 0, 255)
        BgDisplayText(text, position.x, position.y)
    end,

    ---Displays comprehensive debug information
    ---@param data table Debug data to display
    displayDebugInfo = function(data)
        local debugText = string.format([[
            Sun Status:
            Position: %s
            Player Pos: %s
            Hit: %s
            Entity: %s
            Time: %02d:%02d
        ]], 
            Debug.formatVector(data.sunPos),
            Debug.formatVector(data.playerPos),
            tostring(data.hit),
            tostring(data.entity),
            data.gameHours,
            data.gameMinutes
        )

        VisualDebug.drawText(
            debugText,
            {x = 0.05, y = 0.45},
            Config.debugColors.text
        )
    end
}

-- Core functionality
SunCalculator = {
    ---Calculates the current game time as fractional hours
    ---@return number hours, number minutes
    getCurrentTime = function()
        local hours = GetClockHours()
        local minutes = GetClockMinutes()
        return hours, minutes, hours + (minutes / 60.0)
    end,

    ---Determines if it's currently daytime
    ---@param currentTime number The current time in fractional hours
    ---@return boolean
    isDaytime = function(currentTime)
        return currentTime >= Config.dayTimeStart and currentTime <= Config.dayTimeEnd
    end,

    ---Calculates sun position based on game time
    ---@return table Vector3-like table representing sun direction
    calculateSunPosition = function()
        local hours, minutes, currentTime = SunCalculator.getCurrentTime()
        local isDaytime = SunCalculator.isDaytime(currentTime)
        
        -- Calculate progress through day/night cycle
        local progress
        if isDaytime then
            progress = (currentTime - Config.dayTimeStart) / (Config.dayTimeEnd - Config.dayTimeStart)
        else
            if currentTime < Config.dayTimeStart then
                progress = (currentTime + (24 - Config.dayTimeEnd)) / (24 - (Config.dayTimeEnd - Config.dayTimeStart))
            else
                progress = (currentTime - Config.dayTimeEnd) / (24 - (Config.dayTimeEnd - Config.dayTimeStart))
            end
        end

        -- Calculate vertical position
        local verticalPosition = 46.5 * math.sin(progress * math.pi)
        
        return {
            x = Config.sunDistance * math.cos(progress * math.pi),
            y = -Config.sunDistance * math.sin(progress * math.pi) * 0.53,
            z = isDaytime and verticalPosition or -math.abs(verticalPosition)
        }
    end
}

ShadowDetector = {
    ---Gets adjusted coordinates for sun position relative to an entity
    ---@param entity number Entity ID
    ---@param sunCoords table Relative sun position
    ---@return table absoluteSunPos, table entityPos
    getEntitySunLineOfSight = function(entity, sunCoords)
        local entityPos = GetEntityCoords(entity)
        
        local adjustedEntityPos = {
            x = entityPos.x,
            y = entityPos.y,
            z = entityPos.z + GetEntityHeight(entity, entityPos.x, entityPos.y, entityPos.z, true)
        }
        
        local absoluteSunPos = {
            x = adjustedEntityPos.x + sunCoords.x,
            y = adjustedEntityPos.y + sunCoords.y,
            z = adjustedEntityPos.z + sunCoords.z
        }
        
        return absoluteSunPos, adjustedEntityPos
    end,

    ---Checks if an entity has clear line of sight to the sun
    ---@param entity number Entity ID
    ---@param sunPos table Absolute sun position
    ---@return boolean
    checkEntitySunlight = function(entity, sunPos)
        return HasEntityClearLosToCoord(
            entity,
            sunPos.x,
            sunPos.y,
            sunPos.z,
            1
        ) == 1 and true or false
    end
}

-- Main loop
local function MainLoop()
    local lastCheck = 0
    
    while true do
        local currentTime = GetGameTimer()
        
        -- Only check at specified intervals
        if currentTime - lastCheck >= Config.checkInterval then
            lastCheck = currentTime
            
            local sunPos = SunCalculator.calculateSunPosition()
            local playerPed = PlayerPedId()
            local absoluteSunPos, playerPos = ShadowDetector.getEntitySunLineOfSight(playerPed, sunPos)
            
            local isInSunlight = ShadowDetector.checkEntitySunlight(playerPed, absoluteSunPos)
            
            -- Debug visualization and logging
            if Config.debugMode then
                local hours, minutes = SunCalculator.getCurrentTime()
                
                local debugData = {
                    sunPos = absoluteSunPos,
                    playerPos = playerPos,
                    hit = not isInSunlight,
                    entity = playerPed,
                    gameHours = hours,
                    gameMinutes = minutes,
                }
                
                -- Visual debugging
                VisualDebug.drawLine(
                    playerPos,
                    absoluteSunPos,
                    isInSunlight and Config.debugColors.inSunlight or Config.debugColors.inShadow
                )
                
                VisualDebug.displayDebugInfo(debugData)
                
                Debug.log("Shadow State: %s", isInSunlight and "In Sunlight" or "In Shadow")
            end
            
            -- Add your gameplay logic here based on isInSunlight
            -- Example: TriggerEvent('sunShadow:statusChanged', isInSunlight)
        end
        
        Wait(0)
    end
end

-- Start the main loop
Citizen.CreateThread(MainLoop)

-- Export functions for external use
exports('getSunPosition', SunCalculator.calculateSunPosition)
exports('isInSunlight', function(entity)
    local sunPos = SunCalculator.calculateSunPosition()
    local absoluteSunPos = ShadowDetector.getEntitySunLineOfSight(entity or PlayerPedId(), sunPos)
    return ShadowDetector.checkEntitySunlight(entity or PlayerPedId(), absoluteSunPos)
end)