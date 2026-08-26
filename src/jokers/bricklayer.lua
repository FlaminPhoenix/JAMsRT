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
        -- Set global flag
        if not G.GAME.mod_flags then G.GAME.mod_flags = {} end
        G.GAME.mod_flags.bricklayer_active = true
        
        -- Apply Override ONLY if not already applied
        if not bricklayer_active then
            bricklayer_active = true
            
            -- Store original function
            local original_set_edition = Card.set_edition
            
            -- Override
            Card.set_edition = function(self_card, edition, skip_save)
                if G.GAME and G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
                    if not self_card.ability.editions_list then 
                        self_card.ability.editions_list = {} 
                    end
                    table.insert(self_card.ability.editions_list, edition)
                    -- You must manually trigger visual updates here if needed
                    return true
                else
                    return original_set_edition(self_card, edition, skip_save)
                end
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- Optional: Disable flag if no other Bricklayers exist
        -- Note: Restoring the original function is difficult here without complex tracking
        if G.GAME.mod_flags then
            G.GAME.mod_flags.bricklayer_active = false
        end
    end,
    
    calculate = function(self, card, context)
        return {}
    end
}