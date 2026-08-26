
local function init_multi_data(card)
    if not card.multi_mods then
        card.multi_mods = {
            editions = {},
            seals = {},
            enhancements = {}
        }
    end
end



SMODS.joker {
    key = 'bricklayer',
    atlas = 'placeholders',
    pos = {
        x = 2,
        y = 0
    },
    config = {
        extra = {
            chips = 0
        }
    },
    rarity = 3,
    cost = 9,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips}
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.play then
            for _, played_card in ipairs(context.scoring_hand) do
                init_multi_data(played_card)
                played_card.allow_multi_mods = true
            end
        end
    end
}

local original_set_edition = Card.set_edition
Card.set_edition = function(self, edition, immediate, silent, delay)
    if self.allow_multi_mods and self.multi_mods then
        if edition == nil then
            self.multi_mods.editions = {}
            self.edition = nil
            return
        end

        local key = type(edition) == "table" and edition.key or edition
        if not G.P_EDITIONS[key] then 
            return original_set_edition(self, edition, immediate, silent, delay) 
        end

        local exists = false
        for _, ed in ipairs(self.multi_mods.editions) do
            if ed == key then exists = true; break end
        end
        
        if not exists then
            table.insert(self.multi_mods.editions, key)
            if not silent then self:juice_up(0.3, 0.5) end
            return
        end
        return
    end

    return original_set_edition(self, edition, immediate, silent, delay)
end

local original_set_seal = Card.set_seal
Card.set_seal = function(self, seal, skip_check)
    if self.allow_multi_mods and self.multi_mods then
        if seal == nil then
            self.multi_mods.seals = {}
            self.seal = nil
            return
        end
        
        local key = type(seal) == "table" and seal.key or seal
        if not G.P_SEALS[key] then 
            return original_set_seal(self, seal, skip_check) 
        end
        
        local exists = false
        for _, s in ipairs(self.multi_mods.seals) do
            if s == key then exists = true; break end
        end
        
        if not exists then
            table.insert(self.multi_mods.seals, key)
            self:juice_up(0.3, 0.5)
            return
        end
        return
    end
    return original_set_seal(self, seal, skip_check)
end

local original_set_ability = Card.set_ability
Card.set_ability = function(self, center, initial, delay_sprites)
    if self.allow_multi_mods and self.multi_mods then
        if center == nil then
            self.multi_mods.enhancements = {}
            self.ability = nil
            return
        end
        
        local key = type(center) == "table" and center.key or center
        if not G.P_CENTERS[key] then 
            return original_set_ability(self, center, initial, delay_sprites) 
        end
        
        local exists = false
        for _, e in ipairs(self.multi_mods.enhancements) do
            if e == key then exists = true; break end
        end
        
        if not exists then
            table.insert(self.multi_mods.enhancements, key)
            self:juice_up(0.3, 0.5)
            return
        end
        return
    end
    return original_set_ability(self, center, initial, delay_sprites)
end

local original_draw = Card.draw
Card.draw = function(self, layer, opacity)
    original_draw(self, layer, opacity)

    if self.allow_multi_mods and self.multi_mods then

        if #self.multi_mods.editions > 0 then
            for _, ed_key in ipairs(self.multi_mods.editions) do
                local ed_config = G.P_EDITIONS[ed_key]
                if ed_config and ed_config.draw then
                    ed_config.draw(self, layer, opacity)
                end
            end
        end

        if #self.multi_mods.seals > 0 then
            for _, seal_key in ipairs(self.multi_mods.seals) do
                local seal_config = G.P_SEALS[seal_key]
                if seal_config and seal_config.draw then
                    seal_config.draw(self, layer, opacity)
                end
            end
        end
    end
end