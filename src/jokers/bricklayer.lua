local bricklayer_override_applied = false
local bricklayer_card_counter = 0

-- Helper: check if a value already exists in a list
local function list_contains(list, value)
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end

SMODS.Joker {
    key = 'bricklayer',
    loc_txt = {
        name = 'Bricklayer',
        text = {
            'Each playing card is assigned',
            'a {C:attention}number{}.',
            'Seals, Editions, and Enhancements',
            'are {C:attention}stored{} on that card.',
            'Duplicates {C:inactive}do nothing{}.'
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

        if not bricklayer_override_applied then
            bricklayer_override_applied = true

            local original_set_edition = Card.set_edition
            local original_set_seal = Card.set_seal
            local original_set_ability = Card.set_ability

            -- Assign an integer ID to a card if it doesn't have one
            local function ensure_card_id(self_card)
                if not self_card.ability.bricklayer_id then
                    bricklayer_card_counter = bricklayer_card_counter + 1
                    self_card.ability.bricklayer_id = bricklayer_card_counter
                    self_card.ability.bricklayer_modifiers = {
                        editions = {},
                        seals = {},
                        enhancements = {}
                    }
                end
                return self_card.ability.bricklayer_modifiers
            end

            -- === 1. EDITIONS ===
            Card.set_edition = function(self_card, edition, immediate, silent, delay)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    local mods = ensure_card_id(self_card)
                    -- Only add if not already stored (no duplicates)
                    if not list_contains(mods.editions, edition) then
                        table.insert(mods.editions, edition)
                    end
                end
                return original_set_edition(self_card, edition, immediate, silent, delay)
            end

            -- === 2. SEALS ===
            Card.set_seal = function(self_card, seal, immediate)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    local mods = ensure_card_id(self_card)
                    if not list_contains(mods.seals, seal) then
                        table.insert(mods.seals, seal)
                    end
                end
                return original_set_seal(self_card, seal, immediate)
            end

            -- === 3. ENHANCEMENTS ===
            Card.set_ability = function(self_card, ability, immediate, silent)
                if G.GAME.mod_flags.bricklayer_active and self_card.config.card_type == 'Standard' then
                    if ability and ability.name then
                        local mods = ensure_card_id(self_card)
                        if not list_contains(mods.enhancements, ability.name) then
                            table.insert(mods.enhancements, ability.name)
                        end
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

    -- Trigger effects from the stored list when the card is scored
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card then
            local scored_card = context.other_card
            local mods = scored_card.ability.bricklayer_modifiers
            if not mods then return {} end

            local chips = 0
            local mult = 0
            local x_mult = 1
            local has_effect = false

            -- Editions
            for _, ed in ipairs(mods.editions) do
                if ed == 'e_foil' then chips = chips + 50; has_effect = true
                elseif ed == 'e_holo' then mult = mult + 10; has_effect = true
                elseif ed == 'e_polychrome' then x_mult = x_mult * 1.5; has_effect = true
                end
            end

            -- Seals
            for _, seal in ipairs(mods.seals) do
                if seal == 'Gold' then
                    has_effect = true
                    G.GAME.dollars = (G.GAME.dollars or 0) + 3
                elseif seal == 'Red' then
                    has_effect = true
                    -- Red Seal retrigger is handled by the base game via card.ability.seal
                end
            end

            -- Enhancements
            for _, enh in ipairs(mods.enhancements) do
                if enh == 'bonus' then chips = chips + 30; has_effect = true
                elseif enh == 'mult' then mult = mult + 4; has_effect = true
                elseif enh == 'stone' then chips = chips + 50; has_effect = true
                elseif enh == 'glass' then x_mult = x_mult * 2; has_effect = true
                elseif enh == 'steel' then x_mult = x_mult * 1.5; has_effect = true
                elseif enh == 'gold' then
                    has_effect = true
                    G.GAME.dollars = (G.GAME.dollars or 0) + 3
                elseif enh == 'lucky' then
                    has_effect = true
                    -- Lucky: 1/5 chance +20 mult, 1/15 chance +$20
                    if math.random() <= 0.2 then mult = mult + 20 end
                    if math.random() <= 1/15 then G.GAME.dollars = (G.GAME.dollars or 0) + 20 end
                end
            end

            if has_effect then
                local result = {
                    message = "Bricklayer #" .. tostring(scored_card.ability.bricklayer_id),
                    colour = G.C.RED
                }
                if chips > 0 then result.chips = chips end
                if mult > 0 then result.mult = mult end
                if x_mult > 1 then result.xmult = x_mult end
                return result
            end
        end
        return {}
    end
}