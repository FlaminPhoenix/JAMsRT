--#region Atlases

SMODS.Atlas {
    key = 'placeholders',
    path = 'placeholders.png',
    px = 71
    py = 95
}

--#endregion

--#region file loading

local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("jokers_src/" .. file))()
end

--#endregion


-- #region Bricklayer Logic Hooks

-- Helper to check if Bricklayer is active
local function is_bricklayer_active()
    return G.GAME and G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active
end

-- Hook into card creation to initialize multi-property tables
-- This ensures when a card is created, it has the capacity for multiple items
SMODS.Object:register_hook('CardInit', function(self, card, area, key, bypass)
    if not is_bricklayer_active() then return end
    if card.config.card_type ~= 'Standard' then return end -- Only playing cards

    -- Initialize tables if they don't exist, converting single values to lists
    -- Note: This is a simplified example. Full implementation requires 
    -- overriding the 'set_edition', 'set_seal', and 'set_ability' functions 
    -- on the card class to push to these tables instead of overwriting.
    
    if not card.ability.editions_list then card.ability.editions_list = {} end
    if not card.ability.seals_list then card.ability.seals_list = {} end
    if not card.ability.enhancements_list then card.ability.enhancements_list = {} end
end)

-- IMPORTANT: To fully realize "Multiple Editions", you must override the 
-- card:set_edition function. The base game does this: self.ability.extra_edition = edition.
-- You need to change it to: table.insert(self.ability.editions_list, edition).

-- Example Override (Place this in main.lua)
if is_bricklayer_active() then
    local original_set_edition = Card.set_edition
    Card.set_edition = function(self, edition, skip_save)
        if is_bricklayer_active() and self.config.card_type == 'Standard' then
            if not self.ability.editions_list then self.ability.editions_list = {} end
            table.insert(self.ability.editions_list, edition)
            -- You must also manually trigger the visual update logic here
            -- as the base game won't know to render multiple foils.
            return true 
        else
            return original_set_edition(self, edition, skip_save)
        end
    end
end

-- #endregion