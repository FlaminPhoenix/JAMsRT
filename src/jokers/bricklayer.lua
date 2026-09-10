SMODS.Joker {
    key = 'bricklayer',
    loc_txt = {
        name = 'Bricklayer',
        text = {
            'Playing cards can hold',
            '{C:attention}multiple Enhancements/Seals{}.',
            '{C:inactive}Same buff does NOT stack{}.'
        }
    },
    config = { extra = {} },
    atlas = 'bricklayer',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    in_pool = function(self, args)
    if not G.jokers then
        return true
    end

    for _, joker in ipairs(G.jokers.cards) do
        if joker.config.center_key == 'j_JAMRT_bricklayer' then
            return false
        end
    end

    return true
end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.mod_flags = G.GAME.mod_flags or {}
        G.GAME.mod_flags.bricklayer_count = (G.GAME.mod_flags.bricklayer_count or 0) + 1
        G.GAME.mod_flags.bricklayer_active = true
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.mod_flags then
            G.GAME.mod_flags.bricklayer_count = math.max(
                0,
                (G.GAME.mod_flags.bricklayer_count or 1) - 1
            )
            G.GAME.mod_flags.bricklayer_active = G.GAME.mod_flags.bricklayer_count > 0
        end
    end
}




SMODS.Joker:take_ownership('midas_mask',
    {
        calculate = function(self, card, context)
            local enhancements = { "bonus", "mult", "wild", "glass", "steel", "stone", "gold", "lucky" }
            if context.before
            and not context.blueprint
            and G.GAME.mod_flags
            and G.GAME.mod_flags.bricklayer_active then
                local faces = 0
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card:is_face() then
                        faces = faces + 1
                        local card_id = scored_card.config.center_key
                        local variant = "gold"
                        local temp = {}
                        local enh_id = "m_JAMRT_"
                        for _, j in ipairs(enhancements) do
                            if (card_id:find(j) or j == variant) then
                                temp[#temp + 1] = j
                                if enh_id == "m_JAMRT_" then
                                    enh_id = enh_id .. j
                                else
                                    enh_id = enh_id .. "X" .. j
                                end
                            end
                        end
                        if #temp == 1 then
                            enh_id = "m_" .. temp[1]
                        elseif #temp == 0 then
                            enh_id = "c_base"
                        end
                        scored_card:set_ability(enh_id, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
                if faces > 0 then
                    return {
                        message = localize('k_gold'),
                        colour = G.C.MONEY
                    }
                end
            end
        end
    }
)