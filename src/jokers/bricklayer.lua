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
}