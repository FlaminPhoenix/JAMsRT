local bricklayer_override_applied = false

SMODS.Joker {
    key = 'bricklayer',
    loc_txt = {
        name = 'Bricklayer',
        text = {
            'Playing cards can hold',
            '{C:attention}multiple{} Enhancements,',
            '{C:attention}Seals{}, and {C:attention}Editions{}.',
            'All effects {C:attention}stack{}.'
        }
    },
    -- UPDATED VALUES HERE
    config = { extra = {} },
    atlas = 'placeholders',
    pos = { x = 2, y = 0 }, -- Updated X position
    rarity = 3,             -- Updated to Rare
    cost = 9,               -- Updated cost
    unlocked = true,
    discovered = true,
    -- -------------------

    add_to_deck = function(self, card, from_debuff)
        if not G.GAME.mod_flags then G.GAME.mod_flags = {} end
        G.GAME.mod_flags.bricklayer_active = true

        if not bricklayer_override_applied then
            bricklayer_override_applied = true
            
            local original_set_edition = Card.set_edition
            local original_set_seal = Card.set_seal
            local original_set_ability = Card.set_ability

            -- === 1. EDITIONS ===
            Card.set_edition = function(self_card, edition, immediate, silent, delay)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if not self_card.ability.editions_list then self_card.ability.editions_list = {} end
                    table.insert(self_card.ability.editions_list, edition)
                    local old_edition = self_card.ability.edition
                    self_card.ability.edition = edition
                    if immediate then self_card:juice_up() end
                    return true
                end
                return original_set_edition(self_card, edition, immediate, silent, delay)
            end

            -- === 2. SEALS ===
            Card.set_seal = function(self_card, seal, immediate)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if not self_card.ability.seals_list then self_card.ability.seals_list = {} end
                    table.insert(self_card.ability.seals_list, seal)
                    self_card.ability.seal = seal
                    if immediate then self_card:juice_up() end
                    return true
                end
                return original_set_seal(self_card, seal, immediate)
            end

            -- === 3. ENHANCEMENTS ===
            Card.set_ability = function(self_card, ability, immediate, silent)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if ability and (ability.name or next(ability)) then
                        if not self_card.ability.enhancements_list then self_card.ability.enhancements_list = {} end
                        table.insert(self_card.ability.enhancements_list, ability)
                        if not self_card.ability.name then
                            self_card.ability.name = ability.name
                            self_card.ability.extra = ability.extra
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
    
    -- === THE SCORING ENGINE ===
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card then
            local scored_card = context.other_card
            local chips = 0
            local mult = 0
            local x_mult = 1
            local message_parts = {}

            -- 1. Calculate Editions
            if scored_card.ability.editions_list then
                for i, ed in ipairs(scored_card.ability.editions_list) do
                    if ed == 'e_foil' then chips = chips + 50
                    elseif ed == 'e_holo' then mult = mult + 10
                    elseif ed == 'e_polychrome' then x_mult = x_mult * 1.5
                    end
                    table.insert(message_parts, "Edition")
                end
            end

            -- 2. Calculate Seals
            if scored_card.ability.seals_list then
                for i, seal in ipairs(scored_card.ability.seals_list) do
                    if seal == 'Gold' then mult = mult + 4 end
                    table.insert(message_parts, "Seal")
                end
            end

            -- 3. Calculate Enhancements
            if scored_card.ability.enhancements_list then
                for i, enh in ipairs(scored_card.ability.enhancements_list) do
                    local name = enh.name
                    if name == 'bonus' then chips = chips + 30
                    elseif name == 'mult' then mult = mult + 4
                    elseif name == 'lucky' then mult = mult + 5
                    elseif name == 'glass' then x_mult = x_mult * 2
                    elseif name == 'stone' then chips = chips + 50
                    elseif name == 'gold' then mult = mult + 4
                    elseif name == 'steel' then mult = mult + 10
                    end
                    table.insert(message_parts, "Enhance")
                end
            end

            if #message_parts > 0 then
                return {
                    message = "Bricklayer!",
                    chips = chips,
                    mult = mult,
                    Xmult = x_mult,
                    colour = G.C.RED
                }
            end
        end
        return {}
    end
}