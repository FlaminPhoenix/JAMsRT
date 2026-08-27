function SMODS.has_enhancement(playing_card, enhancement, ...)
    if playing_card.config.center_key:find(enhancement:gsub("m_","")) then
        return true
    else
        return false
    end
end
