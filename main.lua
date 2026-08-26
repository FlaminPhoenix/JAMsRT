--#region Atlases
SMODS.Atlas {
    key = 'placeholders',
    path = 'placeholders.png',
    px = 71,
    py = 95
}
--#endregion

--#region File Loading
local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/" .. file))()
end
--#endregion

--#region Engine Hooks (FIXED)
-- Do NOT use SMODS.Object:register_hook. Use SMODS.register_hook instead.

-- We delay the override until the game state is ready
SMODS.register_hook('GameStart', function()
    -- Safety check: Ensure Card class exists
    if Card and Card.set_edition then
        local original_set_edition = Card.set_edition
        
        Card.set_edition = function(self, edition, skip_save)
            -- Check if Bricklayer is active
            if G.GAME and G.GAME.mod_flags and G.GAME.mod_flags.bricklayer_active then
                if not self.ability.editions_list then 
                    self.ability.editions_list = {} 
                end
                table.insert(self.ability.editions_list, edition)
                -- Note: You still need to handle visual rendering manually
                return true
            else
                return original_set_edition(self, edition, skip_save)
            end
        end
    end
end)
--#endregion