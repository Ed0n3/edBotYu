-- Autor: Eduard Weber aka Ed0n3 / No0n3


--todo: Vagabond send challenge, read cardnames: move position of reading after char found
--todo: 


-- Script global vars
dir = scriptPath()
foundDuelists = {}
isDuelling = false
foundDuel = false
swipeTimes = 0

dofile(scriptPath() .. "images.lua")
--dofile("")


setImmersiveMode(true)


function searchForDuelists()
    foundDuelists = listToTable(duelistWorldSmall_1_Region:findAllNoFindException(duelistWorldSmall_1))

    for k,v in ipairs(listToTable(duelistWorldSmall_1_Region:findAllNoFindException(duelistWorldSmall_2))) do
            table.insert(foundDuelists, v)
    end

    for k,v in ipairs(listToTable(duelistWorldMid_1_Region:findAllNoFindException(duelistWorldMid_1))) do
        table.insert(foundDuelists, v)
    end

    for k,v in ipairs(listToTable(duelistWorldBig_1_Region:findAllNoFindException(duelistWorldBig_1))) do
        table.insert(foundDuelists, v)
    end

    if(#foundDuelists == 1 and swipeTimes < 4) then --card trader found
        local removed = false
        for k, v in ipairs(foundDuelists) do
            if(v:getY() >= 1368 and v:getY() <= 1376 and v:getX() >= 566 and v:getX() <= 574) then
                swipe(Location(100, 800), Location(800, 800))
                swipeTimes = swipeTimes + 1
                table.remove(foundDuelists, k)
                removed = true
                break
            end
        end
        if(removed == true) then
            searchForDuelists()
        end
    end


    if(#foundDuelists == 0 and swipeTimes < 4) then
        swipe(Location(100, 800), Location(800, 800))
        swipeTimes = swipeTimes + 1
        searchForDuelists()
    end
    --[[
    if(foundDuelists ~= nil) then
        for k, v in ipairs(foundDuelists) do
            if(v) then
                --print(v)
                v:highlight("!", 2)
            end
        end
    end
    ]]--
end

function startDuel()
    local isDuelist = false

    for k, v in ipairs(foundDuelists) do
        if(v:getY() ~= 1372 and v:getX() ~= 570) then
            click(Location(v:getX()-15, v:getY()+15), 1)
            table.remove(foundDuelists, k)
            break
        end
       -- print(v:getX() .. " - " .. v:getY())
        --if(not cardTrader_Region:exists(cardTrader, 5)) then
    end
    while dialogOpened_Region:existsClick(dialogOpened, 3) == true do
        isDuelist = true
        if (autoDuelStartButton_Region:existsClick(autoDuelStartButton, 3) == true) then
            isDuelling = true
            return 2 --starting duel
        end
    end

    if (itemOkButton_Region:existsClick(itemOkButton, 3) == true) then
        return 3 -- got item
    end


    if(isDuelist == true and autoDuelStartButton_Region:existsClick(autoDuelStartButton, 3) == true) then
        isDuelling = true
        return 2 --starting duel
    end

    return 0 --cant start
end

function waitDuelling()
    local endBattle = true
    local noDuelist = false
    local itemCollected = false
    local dialog = false

    if(isDuelling) then
        while (isDuelling == true) do
           if(logButton_Region:exists(logButton, 2)) then
               click(Location(542, 1759))
               isDuelling = false
               endBattle = true
           end
        end
    end

    while (endBattle == true) do
        if(duelResults_Region:exists(duelResults, 3)) then
            click(Location(542, 1759))
        end

        if(dialogOpened_Region:existsClick(dialogOpened, 3) == true) then
            endBattle = false
        end
    end

    while (dialogOpened_Region:existsClick(dialogOpened, 2) == true) do --nothing
        dialog = true
    end

    if (exists(vagaFriendList, 3)) then
        click(Location(537, 852))
        if(existsClick(setChallengeButton, 3)) then
            swipe(Location(560, 1663),Location(560,1033))
            click(Location(511,1180))
        end
        if(Region(500, 400, 500, 800):existsClick(setChallengeOkButton, 3) == true) then
            while (dialogOpened_Region:existsClick(dialogOpened, 2) == true) do --nothing
                dialog = true
            end
        end

    end



    if(itemOkButton_Region:existsClick(itemOkButton, 3) == true) then
        itemOkButton_Region:existsClick(itemOkButton, 3)
        itemCollected = true
    end

    if(closeBeaconButton_Region:existsClick(closeBeaconButton, 3) == true) then
        noDuelist = true
    end

    if (dialog == true or noDuelist == true or itemCollected == true) then
       return 1
    end

    if (worldScreenSettingsButton_Region:exists(worldScreenSettingsButton, 1)) then
        return 1
    end

    return 0
end

function whereIAM()
    if (worldScreenSettingsButton_Region:exists(worldScreenSettingsButton, 1))then
        return "world"
    elseif(autoDuelStartButton_Region:exists(autoDuelStartButton, 1)) then
        return "dialog"
    elseif(dialogOpened_Region:exists(dialogOpened, 1)) then
        return "dialog"
    elseif (logButton_Region:exists(logButton, 1)) then
        return "endbattle"
    else
        return "unknown"
    end
end


function runBot()
    local iAmAt = whereIAM()
    local startD = 0

    if(iAmAt == "world") then
        searchForDuelists()
        startD = startDuel()
    elseif (iAmAt == "dialog") then
        startD = startDuel()
    elseif(iAmAt == "endbattle") then
        if(waitDuelling() == 1) then
            runBot()
        end
    elseif (iAmAt == "unknown") then
        print("go back to world and start the bot")
    end

    if(startD == 0) then
        print("no duelist / item found")
    elseif (startD == 2) then
        if (waitDuelling() == 1) then
            runBot()
        end
    elseif (startD == 3) then
        runBot()
    elseif (startD == 5) then
        runBot()
    end

end

function getAtkDuel()
    local atk = numberOCRNoFindException(atk_region, "duel_")
    --print("Atk: " .. atk)
    return atk
end

function getAtkDuel()
    local def = numberOCRNoFindException(def_region, "duel_")
    --print("Atk: " .. atk)
    return def
end


function readCardName()
    --local alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z' }
    local alphabet = {'a','c','e','l','u','t'}
    local name = ""
    local found_alphabet = {}

    for i,v in pairs(alphabet) do
        local found = cardName_region:exists("duel_" .. alphabet[i] .. ".png", 0.1)
        if(found) then
            table.insert(found_alphabet, {v, found:getTarget().x})
        --else
          --  cardName_region:exists("duel_" .. string.upper(alphabet[i]) .. ".png", 0.1)
            --if(found) then
              --  table.insert(found_alphabet, {v, found})
            --end
        end
    end

    for j, r in ipairs(found_alphabet) do
        print(r[2])
        for k, s in ipairs(found_alphabet) do
            if(r[2] > s[2] ) then
            --if(found_alphabet[j][2]:getTarget().x > found_alphabet[k][2]:getTarget().x) then
                local swap = found_alphabet[j]
                found_alphabet[j] = found_alphabet[k]
                found_alphabet[j] = swap
            end

        end

    end

    for i,v in ipairs(found_alphabet) do
        name = name .. v[1]
    end


    print(name)

end

--X

function tryDebug()
    --do something
end

--tryDebug()
--readCardName()
runBot()
--getAtkDuel()
