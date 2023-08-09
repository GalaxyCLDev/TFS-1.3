local config = {
    actionId = 5900, -- ActionID to use in the lever
    bossName = "Demon",
    bossPosition = Position(3111, 1846, 7), -- Position where the boss will appear
    bossArea = {
        fromPos = Position(3101, 1845, 7), -- Upper left corner of the room
        toPos = Position(3120, 1855, 7), -- Lower right corner of the room
        entrancePos = Position(3119, 1845, 7), -- Position where players will be teleported when they enter
        exitPosition = Position(3118, 1842, 7) -- If the participants take too long they will be kicked from the room to this position
    },
    allowedAnyParticipantsCount = true, -- allow any valid number of participants to enter. example: 1,2,3 or 4
    participantsPos = {
        Position(3117, 1842, 7), -- Player 1, this player should be the one to pull the lever
        Position(3118, 1842, 7), -- Player 2
        Position(3119, 1842, 7), -- Player 3
        Position(3120, 1842, 7) -- Player 4
    },
    attempts = {
        level = 200, -- Level required to enter
        storage = 20000, -- Storage where we keep the waiting time
        seconds = 72000 -- 20 hours
    },
    createTeleportPos = Position(3112, 1845, 7), -- Position where the teleport is created when the boss dies
    teleportToPosition = Position(3122, 1845, 7), -- Position where the teleport created by the boss will take you when you die
    teleportRemoveSeconds = 10, -- seconds
    kickParticipantAfterSeconds = 60 * 15, -- 15 minutes
    leverIds = {1945, 1946} -- Lever animation, on/off
}

local function getSpectators(onlyPlayers)
    if not config.centerPosition then
        config.diffX = math.ceil((config.bossArea.toPos.x - config.bossArea.fromPos.x) / 2)
        config.diffY = math.ceil((config.bossArea.toPos.y - config.bossArea.fromPos.y) / 2)
        config.centerPosition = config.bossArea.fromPos + Position(config.diffX, config.diffY, 0)
    end
    return Game.getSpectators(config.centerPosition, false, onlyPlayers, config.diffX, config.diffX, config.diffY, config.diffY)
end

local action = Action()

function action.onUse(player, item, fromPos, target, toPos, isHotkey)
    local participants = {}
    for index, pos in pairs(config.participantsPos) do
        local tile = Tile(pos)
        if not tile then error("[Warning - Tile not found]") end
        local participant = tile:getTopVisibleCreature(player)
        if participant and participant:isPlayer() then
            if index == 1 and participant ~= player then
                player:sendCancelMessage("Only the first participant can pull the lever.")
                return true
            end

            if participant:getStorageValue(config.attempts.storage) >= os.time() then
                player:sendCancelMessage(string.format("The player %s must wait a while before being able to enter again.", participant:getName()))
            elseif participant:getLevel() < config.attempts.level then
                player:sendCancelMessage(string.format("The player %s is not level %d.", participant:getName(), config.attempts.level))
            else
                participants[#participants +1] = participant
            end
        end
    end

    if #participants == 0 then
        player:sendCancelMessage("You need at least one participant.")
        return true
    elseif not config.allowedAnyParticipantsCount and #participants ~= #config.participantsPos then
        player:sendCancelMessage("You need all participants.")
        return true
    end

    if #getSpectators(true) > 0 then
        player:sendCancelMessage("At this time the room is occupied, please try again later.")
        return true
    end

    stopEvent(config.kickEventId)

    for _, monsterSpectator in pairs(getSpectators()) do
        monsterSpectator:remove()
    end

    local boss = Game.createMonster(config.bossName, config.bossPosition)
    if not boss then
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    boss:registerEvent("bossSystemDeath")

    for index, participant in pairs(participants) do
        participant:getPosition():sendMagicEffect(CONST_ME_POFF)
        participant:teleportTo(config.bossArea.entrancePos, false)
        participant:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
    end

    config.kickEventId = addEvent(function ()
        for _, spectator in pairs(getSpectators()) do
            if spectator:isPlayer() then
                spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                spectator:teleportTo(config.bossArea.exitPosition, false)
                spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It's been a long time and you haven't managed to defeat the boss.")
            else
                spectator:remove()
            end
        end
    end, config.kickParticipantAfterSeconds * 1000)
    item:transform(item:getId() == config.leverIds[1] and config.leverIds[2] or config.leverIds[1])
    return true
end

action:aid(config.actionId)
action:register()

local creatureEvent = CreatureEvent("bossSystemDeath")

function creatureEvent.onDeath()
    stopEvent(config.kickEventId)
    local teleport = Game.createItem(1387, 1, config.createTeleportPos)
    if teleport then
        teleport:setDestination(config.teleportToPosition)
        addEvent(function ()
            local tile = Tile(config.createTeleportPos)
            if tile then
                local teleport = tile:getItemById(1387)
                if teleport then
                    teleport:remove()
                    config.teleportToPosition:sendMagicEffect(CONST_ME_POFF)
                end
            end

            for _, spectator in pairs(getSpectators()) do
                if spectator:isPlayer() then
                    spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                    spectator:teleportTo(config.teleportToPosition, false)
                    spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                else
                    spectator:remove()
                end
            end
        end, config.teleportRemoveSeconds * 1000)
    end
    return true
end

creatureEvent:register()
