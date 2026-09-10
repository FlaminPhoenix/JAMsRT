SMODS.Atlas{ key = "seal", path = "Seals.png", px = 71, py = 95 }
SMODS.Seal {
    key = "redXblue",
    name = "Red Blue Seal",
    atlas = "seal",
    pos = { x = 0, y = 2 },
    config = { extra = { retriggers = 1,  } },
    
    badge_colour = G.C.BLUE,
    
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Blue Seal",
        label = "Red Blue",
        text = {
            "Has the effects of","{C:attention}Red and {C:attention}Blue seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
       

        return {
            vars = {
                self.config.extra.retriggers, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        
    end
}
SMODS.Seal {
    key = "redXpurple",
    name = "Red Purple Seal",
    atlas = "seal",
    pos = { x = 0, y = 1 },
    config = { extra = { retriggers = 1,  } },
    
    badge_colour = G.C.PURPLE,
    
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Purple Seal",
        label = "Red Purple",
        text = {
            "Has the effects of","{C:attention}Red and {C:attention}Purple seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
     

        return {
            vars = {
                self.config.extra.retriggers, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
SMODS.Seal {
    key = "blueXpurple",
    name = "Blue Purple Seal",
    atlas = "seal",
    pos = { x = 1, y = 1 },
    config = { extra = {  } },
    
    badge_colour = G.C.PURPLE,
    
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Blue Purple Seal",
        label = "Blue Purple",
        text = {
            "Has the effects of","{C:attention}Blue and {C:attention}Purple seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
     

        return {
            vars = {
                
            }
        }
    end,

    calculate = function(self, card, context)
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
SMODS.Seal {
    key = "redXblueXpurple",
    name = "Red Blue Purple Seal",
    atlas = "seal",
    pos = { x = 3, y = 1 },
    config = { extra = { retriggers = 1,  } },
    
    badge_colour = G.C.PURPLE,
    
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Blue Purple Seal",
        label = "Red Blue Purple",
        text = {
            "Has the effects of","{C:attention}Red, {C:attention}Blue and {C:attention}Purple seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
     

        return {
            vars = {
                self.config.extra.retriggers, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
SMODS.Seal {
    key = "redXgold",
    name = "Red Gold Seal",
    atlas = "seal",
    pos = { x = 0, y = 3 },
    config = { extra = { retriggers = 1, money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Gold Seal",
        label = "Red Gold",
        text = {
            "Has the effects of","{C:attention}Red and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.retriggers, self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        
    end
}
SMODS.Seal {
    key = "blueXgold",
    name = "Blue Gold Seal",
    atlas = "seal",
    pos = { x = 1, y = 2 },
    config = { extra = { money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Blue Gold Seal",
        label = "Blue Gold",
        text = {
            "Has the effects of","{C:attention}Blue and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        
    end
}
SMODS.Seal {
    key = "redXblueXgold",
    name = "Red Blue Gold Seal",
    atlas = "seal",
    pos = { x = 2, y = 1 },
    config = { extra = { retriggers = 1, money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Blue Gold Seal",
        label = "Red Blue Gold",
        text = {
            "Has the effects of","{C:attention}Red, {C:attention}Blue and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.retriggers, self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        
    end
}
SMODS.Seal {
    key = "purpleXgold",
    name = "Purple Gold Seal",
    atlas = "seal",
    pos = { x = 1, y = 3 },
    config = { extra = { money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Purple Gold Seal",
        label = "Purple Gold",
        text = {
            "Has the effects of","{C:attention}Purple and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
SMODS.Seal {
    key = "redXpurpleXgold",
    name = "Red Purple Gold Seal",
    atlas = "seal",
    pos = { x = 2, y = 2 },
    config = { extra = { retriggers = 1, money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Purple Gold Seal",
        label = "Red Purple Gold",
        text = {
            "Has the effects of","{C:attention}Red, {C:attention}Purple and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.retriggers, self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
SMODS.Seal {
    key = "blueXpurpleXgold",
    name = "Blue Purple Gold Seal",
    atlas = "seal",
    pos = { x = 3, y = 2 },
    config = { extra = { money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Blue Purple Gold Seal",
        label = "Blue Purple Gold",
        text = {
            "Has the effects of","{C:attention}Blue, {C:attention}Purple and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
SMODS.Seal {
    key = "redXblueXpurpleXgold",
    name = "Red Blue Purple Gold Seal",
    atlas = "seal",
    pos = { x = 2, y = 3 },
    config = { extra = { retriggers = 1, money = 3,  } },
    get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        
    badge_colour = G.C.GOLD,
    draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        
    in_pool = function(self, args) return false end,

    loc_txt = {    
        name = "Red Blue Purple Gold Seal",
        label = "Red Blue Purple Gold",
        text = {
            "Has the effects of","{C:attention}Red, {C:attention}Blue, {C:attention}Purple and {C:attention}Gold seals"
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
       

        return {
            vars = {
                self.config.extra.retriggers, self.config.extra.money, 
            }
        }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    if G.GAME.last_hand_played then
                        local _planet = nil
                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                _planet = planet_center.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end
            }))
            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
        end
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'Tarot' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
        end
        
    end
}
