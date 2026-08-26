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
                    -- Add to list
                    table.insert(self_card.ability.editions_list, edition)
                    
                    -- Set the base edition ONLY if it doesn't have one yet
                    -- This ensures the game uses the FIRST edition for effects/visuals
                    if not self_card.ability.edition then
                        self_card.ability.edition = edition
                    end
                    
                    if immediate then self_card:juice_up() end
                    return true
                else
                    return original_set_edition(self_card, edition, immediate, silent, delay)
                end
            end

            -- === OVERRIDE 2: SEALS ===
            Card.set_seal = function(self_card, seal, immediate)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if not self_card.ability.seals_list then self_card.ability.seals_list = {} end
                    -- Add to list
                    table.insert(self_card.ability.seals_list, seal)

                    -- Set the base seal ONLY if it doesn't have one yet
                    if not self_card.ability.seal then
                        self_card.ability.seal = seal
                    end

                    if immediate then self_card:juice_up() end
                    return true
                else
                    return original_set_seal(self_card, seal, immediate)
                end
            end

            -- === OVERRIDE 3: ENHANCEMENTS ===
            Card.set_ability = function(self_card, ability, immediate, silent)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if ability and (ability.name or next(ability)) then
                        if not self_card.ability.enhancements_list then self_card.ability.enhancements_list = {} end
                        -- Add to list
                        table.insert(self_card.ability.enhancements_list, ability)

                        -- Set the base ability ONLY if it doesn't have one yet
                        if not self_card.ability.name then
                            self_card.ability.name = ability.name
                            self_card.ability.extra = ability.extra
                            -- Trigger visual update for enhancement
                            if self_card.set_ability_sprites then self_card:set_ability_sprites() end
                        end

                        if immediate then self_card:juice_up() end
                        return true
                    end
                end
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
        -- No calculation needed since effects don't stack
        return {}
    end
}