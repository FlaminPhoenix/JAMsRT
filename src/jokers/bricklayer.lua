local bricklayer_override_applied = false

SMODS.Joker {
    key = 'bricklayer',
    loc_txt = {
        name = 'Bricklayer',
        text = {
            'Playing cards in your deck',
            'can hold {C:attention}multiple{}',
            '{C:attention}Enhancements{}, {C:attention}Seals{},',
            'and {C:attention}Editions{}.',
            '{C:inactive}(Effects do not stack)'
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
        -- 1. Set Global Flag
        if not G.GAME.mod_flags then G.GAME.mod_flags = {} end
        G.GAME.mod_flags.bricklayer_active = true

        -- 2. Apply Overrides ONLY once per run
        if not bricklayer_override_applied then
            bricklayer_override_applied = true
            
            -- Store Originals
            local original_set_edition = Card.set_edition
            local original_set_seal = Card.set_seal
            local original_set_ability = Card.set_ability

            -- === OVERRIDE 1: EDITIONS ===
            Card.set_edition = function(self_card, edition, immediate, silent, delay)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if not self_card.ability.editions_list then self_card.ability.editions_list = {} end
                    table.insert(self_card.ability.editions_list, edition)
                end
                -- ALWAYS call original to prevent errors
                return original_set_edition(self_card, edition, immediate, silent, delay)
            end

            -- === OVERRIDE 2: SEALS ===
            Card.set_seal = function(self_card, seal, immediate)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if not self_card.ability.seals_list then self_card.ability.seals_list = {} end
                    table.insert(self_card.ability.seals_list, seal)
                end
                -- ALWAYS call original to prevent "no repetitions" error
                return original_set_seal(self_card, seal, immediate)
            end

            -- === OVERRIDE 3: ENHANCEMENTS ===
            Card.set_ability = function(self_card, ability, immediate, silent)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if ability and (ability.name or next(ability)) then
                        if not self_card.ability.enhancements_list then self_card.ability.enhancements_list = {} end
                        table.insert(self_card.ability.enhancements_list, ability)
                    end
                end
                -- ALWAYS call original
                return original_set_ability(self_card, ability, immediate, silent)
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.mod_flags then
            G.GAME.mod_flags.bricklayer_active = false
        end
    end,
    
    calculate = function(self, card, context)
        return {}
    end
}