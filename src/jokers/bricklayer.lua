SMODS.Joker {
    key = 'bricklayer',
    loc_txt = {
        name = 'Bricklayer',
        text = {
            'Playing cards can hold',
            '{C:attention}multiple Enhancements{}.',
            '{C:inactive}Same buff does NOT stack{}.'
        }
    },
    config = { extra = {} },
    atlas = 'placeholders',
    pos = { x = 2, y = 0 },
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,

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
