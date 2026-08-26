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
    atlas = 'placeholders', -- Uses your defined atlas
    pos = { x = 3, y = 0 }, -- Adjust X/Y based on your spritesheet layout
    rarity = 3, -- 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 9,
    unlocked = true,
    discovered = true,
    
    -- This function runs when the Joker is added to your run
    add_to_deck = function(self, card, from_debuff)
        -- Set a global flag or deck flag indicating Bricklayer is active
        -- We attach this to the G.playing_cards table or a global mod variable
        if not G.GAME.mod_flags then G.GAME.mod_flags = {} end
        G.GAME.mod_flags.bricklayer_active = true
        
        -- Optional: Immediately upgrade existing cards in deck if desired
        -- This is complex and usually handled by a separate 'update' loop
    end,

    -- This function runs when the Joker is removed (sold/destroyed)
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
            G.GAME.mod_flags.bricklayer_active = false
        end
    end,
    
    calculate = function(self, card, context)
        -- Passive Joker, no calculation needed during scoring usually
        -- Unless you want it to trigger an effect when a multi-sealed card scores
        return {}
    end
}
