-- Configuration table
local Config = {}
Config.debugmode = false -- Set to true to enable debug mode for visual and textual output

--- Draws a debug line in the game world for visualization.
-- @param startCoords table: Starting coordinates (vector3 format)
-- @param endCoords table: Ending coordinates (vector3 format)
-- @param r number: Red color value (default: 255)
-- @param g number: Green color value (default: 255)
-- @param b number: Blue color value (default: 0)
-- @param a number: Alpha value (transparency, default: 255)
function DrawDebugLine(startCoords, endCoords, r, g, b, a)
    r = r or 255
    g = g or 255
    b = b or 0
    a = a or 255

    -- Draw the line in the game world
    DrawLine(
        startCoords.x, startCoords.y, startCoords.z,
        endCoords.x, endCoords.y, endCoords.z,
        r, g, b, a
    )
end

--- Draws text on the screen.
-- @param text string: Text to display
-- @param xPos number: X position on the screen
-- @param yPos number: Y position on the screen
function DrawTextOnScreen(text, xPos, yPos)
    SetTextScale(0.35, 0.35) -- Sets the text size
    SetTextColor(255, 255, 255, 255) -- White color
    SetTextDropshadow(3, 0, 0, 0, 255) -- Adds a shadow to the text
    -- Display the text
    BgDisplayText(
        text, 
        xPos, 
        yPos
    )
end

--- Calculates the sun's position based on the in-game time.
-- @return table: A vector3-like table representing the sun's direction relative to the player
function CalculateSunPosition()
    local currentTime = GetClockHours() + (GetClockMinutes() / 60.0) -- Calculates the fractional hour
    local isDaytime = currentTime >= 6.0 and currentTime <= 20.0 -- Daytime is between 6 AM and 8 PM

    local progress
    if isDaytime then
        progress = (currentTime - 6.0) / 14.0 -- Progress of the sun during the day
    else
        if currentTime < 6.0 then
            progress = (currentTime + 4.0) / 10.0 -- Nighttime progression (before midnight)
        else
            progress = (currentTime - 20.0) / 10.0 -- Nighttime progression (after midnight)
        end
    end

    local z = (46.5 * math.sin(progress * math.pi)) -- Vertical position of the sun
    return {
        x = 60.0 * math.cos(progress * math.pi),
        y = -60.0 * math.sin(progress * math.pi) * 0.53,
        z = isDaytime and z or -math.abs(z) -- Negative Z for the moon
    }
end

--- Main loop to check for shadow status using raycasting.
function ShadowAndSunBuildingsHitChecker()
    while true do
        Wait(0) -- Prevents the game from freezing due to infinite loop

        local playerPos = GetEntityCoords(PlayerPedId()) -- Gets the player's current position
        local sunPos = CalculateSunPosition() -- Calculates the sun's relative position

        local adjustedPlayerPos = vector3(playerPos.x, playerPos.y, playerPos.z + 0.8) -- Adjusts player position for head height

        -- Calculate the absolute position of the sun in the world
        local absoluteSunPos = {
            x = adjustedPlayerPos.x + sunPos.x,
            y = adjustedPlayerPos.y + sunPos.y,
            z = adjustedPlayerPos.z + sunPos.z
        }

        -- Perform a raycast to check for obstructions
        local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(
            adjustedPlayerPos.x, adjustedPlayerPos.y, adjustedPlayerPos.z,
            absoluteSunPos.x, absoluteSunPos.y, absoluteSunPos.z,
            -1, -- Trace everything
            PlayerPedId(), -- Ignore the player's entity
            4
        )

        local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(rayHandle)

        

        -- Debug mode
        if Config.debugmode then
            print(string.format(
                "Debug mode: ON,\r\n RayHandle: %s,\r\n Player pos: %s,\r\n Sun pos: %s",
                rayHandle, adjustedPlayerPos, absoluteSunPos
            ))
            print("RayHandle Status", retval, hit, endCoords, surfaceNormal, entity)

            -- Draw the raycast line
            DrawDebugLine(
                adjustedPlayerPos,
                absoluteSunPos,
                255, -- R
                255, -- G
                0,   -- B
                255  -- A
            )

            -- Display debug information on-screen
            DrawTextOnScreen(
                ('SUN STATUS: \n' ..
                'Sun Direction: %s\n' ..
                'retval: %s,\n' ..
                'hit: %s,\n' ..
                'endCoords: %s,\n' ..
                'surfaceNormal: %s,\n' ..
                'entity: %s,\n' ..
                'rayHandle %s'):format(
                    vector3(absoluteSunPos.x, absoluteSunPos.y, absoluteSunPos.z),
                    retval,
                    hit,
                    endCoords,
                    surfaceNormal,
                    entity,
                    rayHandle
                ),
                0.05, 0.45
            )
        end
    end
end

-- Start the shadow checker loop
ShadowAndSunBuildingsHitChecker()
