--#region Atlases
SMODS.Atlas {
    key = 'bricklayer',
    path = 'BrickLayer.png',
    px = 71,
    py = 95
}

SMODS.Atlas { 
    key = "seal", 
    path = "Seals.png", 
    px = 71, 
    py = 95 
}

SMODS.Atlas{ 
    key = "enhancement", 
    path = "Enhancements.png", 
    px = 71, 
    py = 95 
}

SMODS.Atlas {
    key = "consumable",
    path = "Tarots.png",
    px = 71, py = 95,
}

--#endregion

--#region File Loading
local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/" .. file))()
end

local consumables_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/consumables")
for _, file in ipairs(consumables_src) do
    assert(SMODS.load_file("src/consumables/" .. file))()
end

local buffs_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/buffs")
for _, file in ipairs(buffs_src) do
    assert(SMODS.load_file("src/buffs/" .. file))()
end
--#endregion

--#region Assert

assert(SMODS.load_file("src/hooks/hooks.lua"))()

--assert(SMODS.load_file("src/icon.lua"))()

--#endregion