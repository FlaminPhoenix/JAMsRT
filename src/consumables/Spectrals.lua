local seal_order = {
    Red = 1,
    Blue = 2,
    Purple = 3,
    Gold = 4
}

local function get_combined_seal(existing, new_seal)

    local seals = {}

    if existing then

        -- Remove our mod prefix if this is a combined seal
        existing = existing:gsub("^JAMRT_", "")

        for seal in string.gmatch(existing, "[^X]+") do
            seal = seal:gsub("^%l", string.upper)
            seals[seal] = true
        end
    end

    if new_seal then
        seals[new_seal] = true
    end

    if next(seals) == nil then
        return nil
    end

    local ordered = {}

    for seal, _ in pairs(seals) do
        table.insert(ordered, seal)
    end

    table.sort(ordered, function(a, b)
        return seal_order[a] < seal_order[b]
    end)

    if #ordered == 1 then
        return ordered[1]
    end

    local combined = {}

    for _, seal in ipairs(ordered) do
        table.insert(combined, seal:lower())
    end

    return "JAMRT_" .. table.concat(combined, "X")
end


SMODS.Consumable:take_ownership('deja_vu',
    {

        config = {
            extra = {
                seal = "Red",
                max_highlighted = 1
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]

            return {
                vars = {
                    card.ability.extra.max_highlighted
                }
            }
        end,

        use = function(self, card, area, copier)
            local conv_card = G.hand.highlighted[1]

            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,

                func = function()
                    local existing = conv_card.seal
                    local new_seal = card.ability.extra.seal

                    local seal_id

                    if G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
                        seal_id = get_combined_seal(existing, new_seal)
                    else
                        seal_id = new_seal
                    end

                    conv_card:set_seal(seal_id, nil, true)

                    return true
                end
            }))

            delay(0.5)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,

                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,

        can_use = function(self, card)
            return G.hand
                and #G.hand.highlighted > 0
                and #G.hand.highlighted <= card.ability.extra.max_highlighted
        end
    }
)


SMODS.Consumable:take_ownership('trance',
    {
        config = {
            extra = {
                seal = "Blue",
                max_highlighted = 1
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]

            return {
                vars = {
                    card.ability.extra.max_highlighted
                }
            }
        end,

        use = function(self, card, area, copier)
            local conv_card = G.hand.highlighted[1]

            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,

                func = function()
                    local existing = conv_card.seal
                    local new_seal = card.ability.extra.seal

                    local seal_id

                    if G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
                        seal_id = get_combined_seal(existing, new_seal)
                    else
                        seal_id = new_seal
                    end

                    conv_card:set_seal(seal_id, nil, true)

                    return true
                end
            }))

            delay(0.5)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,

                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,

        can_use = function(self, card)
            return G.hand
                and #G.hand.highlighted > 0
                and #G.hand.highlighted <= card.ability.extra.max_highlighted
        end
    }
)


SMODS.Consumable:take_ownership('medium',
    {

        config = {
            extra = {
                seal = "Purple",
                max_highlighted = 1
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]

            return {
                vars = {
                    card.ability.extra.max_highlighted
                }
            }
        end,

        use = function(self, card, area, copier)
            local conv_card = G.hand.highlighted[1]

            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,

                func = function()
                    local existing = conv_card.seal
                    local new_seal = card.ability.extra.seal

                    local seal_id

                    if G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
                        seal_id = get_combined_seal(existing, new_seal)
                    else
                        seal_id = new_seal
                    end

                    conv_card:set_seal(seal_id, nil, true)

                    return true
                end
            }))

            delay(0.5)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,

                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,

        can_use = function(self, card)
            return G.hand
                and #G.hand.highlighted > 0
                and #G.hand.highlighted <= card.ability.extra.max_highlighted
        end
    }
)


SMODS.Consumable:take_ownership('talisman',
    {

        config = {
            extra = {
                seal = "Gold",
                max_highlighted = 1
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]

            return {
                vars = {
                    card.ability.extra.max_highlighted
                }
            }
        end,

        use = function(self, card, area, copier)
            local conv_card = G.hand.highlighted[1]

            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,

                func = function()
                    local existing = conv_card.seal
                    local new_seal = card.ability.extra.seal

                    local seal_id

                    if G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
                        seal_id = get_combined_seal(existing, new_seal)
                    else
                        seal_id = new_seal
                    end

                    conv_card:set_seal(seal_id, nil, true)

                    return true
                end
            }))

            delay(0.5)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,

                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,

        can_use = function(self, card)
            return G.hand
                and #G.hand.highlighted > 0
                and #G.hand.highlighted <= card.ability.extra.max_highlighted
        end
    }
)