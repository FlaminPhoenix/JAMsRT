local bricklayer_active = false

SMODS.Joker {
    key = 'bricklayer',
    loc_txt = {
        name = 'Bricklayer',
        text = {
            'Playing cards in your deck',
            'can hold {C:attention}multiple{}',
            '{C:attention}Enhancements{}, {C:attention}Seals{},',
            'and {C:attention}Editions{}.'
        }
    },
    config = { extra = {} },
    atlas = 'placeholders',
    pos = { x = 2, y = 0 },
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,

    add_to_deck = function(self, card, from_debuff)
    if not G.GAME.mod_flags then G.GAME.mod_flags = {} end
    G.GAME.mod_flags.bricklayer_active = true

    if not bricklayer_active then
        bricklayer_active = true
        
        -- 1. Store Original
        local original_set_edition = Card.set_edition
        
        -- 2. Override Set_Edition
        Card.set_edition = function(self_card, edition, immediate, silent, delay)
            if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                if not self_card.ability.editions_list then 
                    self_card.ability.editions_list = {} 
                end
                -- Add to your list
                table.insert(self_card.ability.editions_list, edition)
                
                -- CRITICAL: Also set the base 'edition' var so the game thinks it has one
                -- This prevents the game from rejecting the card or looking broken
                if not self_card.ability.edition then
                    self_card.ability.edition = edition 
                end
                
                if immediate then
                    -- Trigger visual update manually if needed
                    self_card:juice_up()
                end
                return true
            else
                return original_set_edition(self_card, edition, immediate, silent, delay)
            end
        end
    end
end,


calculate = function(self, card, context)
    -- Only run during scoring of a playing card
    if context.individual and context.cardarea == G.play and context.other_card then
        local scored_card = context.other_card
        if scored_card.ability.editions_list and #scored_card.ability.editions_list > 1 then
            local extra_mult = 0
            local extra_chips = 0
            local x_mult = 1
            
            -- Loop through ALL editions in your list
            for i, ed_key in ipairs(scored_card.ability.editions_list) do
                -- Skip the first one (base game handles it) or handle all if you disabled base
                if i > 1 then 
                    if ed_key == 'e_foil' then extra_chips = extra_chips + 50
                    elseif ed_key == 'e_holo' then extra_mult = extra_mult + 10
                    elseif ed_key == 'e_polychrome' then x_mult = x_mult * 1.5
                    end
                end
            end
            
            if extra_chips > 0 or extra_mult > 0 or x_mult > 1 then
                return {
                    message = "Bricklayer!",
                    chips = extra_chips,
                    mult = extra_mult,
                    Xmult = x_mult,
                    colour = G.C.RED
                }
            end
        end
    end
    return {}
end



}