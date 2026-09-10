import os

os.chdir(os.path.dirname(os.path.abspath(__file__)).replace("/Developers","/src/seals"))


Bases=["Gold","Purple","Blue","Red"]
Seals_file='SMODS.Atlas{ key = "seal", path = "Seals.png", px = 71, py = 95 }\n'
# Localize_file = 'return { descriptions = { Other = {\n'

def coords(num):
    num1=0
    num2=0
    while num>3:
        num1+=1
        num-=4
    num2=num
    return ([num1,num2])

def convert(num):
    digit=1
    power=0
    amount=0
    while num>0:
        if num>=digit*2:
            digit*=2
            power+=1
        elif num==1:
            amount+=1
            num-=1
        else:
            num-=digit
            digit=1
            amount+=10**power
            power=0
    amount=str(amount)
    amount="0"*(4-len(amount))+amount
    return amount


file=open("seals.lua","w")
# file2=open("SealsLocalize.lua","w")

for i in range(16):
    current=convert(i)
    if i in [0,1,2,4,8]:
        continue
    Red=Blue=Purple=Gold=False
    if current[3]=="1":
        Red=True
    if current[2]=="1":
        Blue=True
    if current[1]=="1":
        Purple=True
    if current[0]=="1":
        Gold=True

    pos=coords(i)
    selected=[]

    for j,num in enumerate(current):
        if num=="1":
            selected.append(Bases[j])

    num=len(selected)-1
    name=""
    key=""

    while num>=0:
        if key=="":
            key=selected[num].lower()
        else:
            key+="X"
            key+=selected[num].lower()
        name+=selected[num]+" "
        num-=1

    name+="Seal"
    key=key
    print(i,name,key,pos)


    extraconfig = ""
    get_p_dollars = ""
    badge = ""
    draw = ""
    vars_info = ""
    info_queue = ""
    calculate = ""
    text_loc = []
    var_num = 1


    # ============================================================
    # RED
    # ============================================================

    if Red:

        extraconfig += "retriggers = 1, "

        badge = "G.C.RED"

        vars_info += "self.config.extra.retriggers, "
        red_var = var_num
        var_num += 1

        info_queue += "info_queue[#info_queue + 1] = G.P_SEALS.Red\n        "

        calculate += """if context.repetition then
            return {
                repetitions = card.ability.seal.extra.retriggers,
            }
        end
        """

        text_loc.append("{C:attention}Red")


    # ============================================================
    # BLUE
    # ============================================================

    if Blue:

        badge = "G.C.BLUE"

        info_queue += "info_queue[#info_queue + 1] = G.P_SEALS.Blue\n       "

        calculate += """if context.playing_card_end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
        """

        text_loc.append("{C:attention}Blue")


    # ============================================================
    # PURPLE
    # ============================================================

    if Purple:

        badge = "G.C.PURPLE"

        info_queue += "info_queue[#info_queue + 1] = G.P_SEALS.Purple\n     "

        calculate += """if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
        """

        text_loc.append("{C:attention}Purple")


    # ============================================================
    # GOLD
    # ============================================================

    if Gold:

        extraconfig += "money = 3, "

        badge = "G.C.GOLD"

        get_p_dollars = """get_p_dollars = function(self, card)
            return card.ability.seal.extra.money
        end,
        """

        vars_info += "self.config.extra.money, "
        gold_var = var_num
        var_num += 1

        info_queue += "info_queue[#info_queue + 1] = G.P_SEALS.Gold\n       "

        draw = """draw = function(self, card, layer)
            if (layer == 'card' or layer == 'both')
            and card.sprite_facing == 'front' then
                G.shared_seals[card.seal].role.draw_major = card
                G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end,
        """

        text_loc.append("{C:attention}Gold")


    if len(text_loc) == 1:
        text_loc = text_loc[0]
    elif len(text_loc) == 2:
        text_loc = " and ".join(text_loc)
    else:
        text_loc = ", ".join(text_loc[:-1]) + " and " + text_loc[-1]


    Seal = f'''SMODS.Seal {{
    key = "{key}",
    name = "{name}",
    atlas = "seal",
    pos = {{ x = {pos[0]}, y = {pos[1]} }},
    config = {{ extra = {{ {extraconfig} }} }},
    {get_p_dollars}
    badge_colour = {badge},
    {draw}
    in_pool = function(self, args) return false end,

    loc_txt = {{    
        name = "{name}",
        label = "{name.removesuffix(" Seal")}",
        text = {{
            "Has the effects of","{text_loc} seals"
        }}
    }},

    loc_vars = function(self, info_queue, card)
        {info_queue}

        return {{
            vars = {{
                {vars_info}
            }}
        }}
    end,

    calculate = function(self, card, context)
        {calculate}
    end
}}
'''


    Seals_file += Seal


file.write(Seals_file)
file.close()