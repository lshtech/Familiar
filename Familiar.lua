--- STEAMODDED HEADER
--- MOD_NAME: Familiar
--- MOD_ID: familiar
--- MOD_AUTHOR: [RattlingSnow353]
--- MOD_DESCRIPTION: Adds different variations to everything in-game
--- BADGE_COLOUR: cecf4b
--- DISPLAY_NAME: Familiar
--- VERSION: 1.0.0
--- PREFIX: fam

----------------------------------------------
------------MOD CODE -------------------------

-- You're not supposed to be here
function Card:get_suit()
    if self.ability.effect == 'Stone Card' and not self.vampired then
        return -math.random(100, 1000000)
    end
    return self.base.suit
end

local function is_face(card)
    local id = card:get_id()
    return id == 11 or id == 12 or id == 13
end

function shakecard(self)
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(1, 1)
            return true
        end
    }))
end

local function create_consumable(card_type,tag,messae,extra, thing1, thing2)
    extra=extra or {}
    
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
                local card = create_card(card_type,G.consumeables, nil, nil, thing1, thing2, extra.forced_key or nil, tag)
                card:add_to_deck()
                if extra.edition~=nil then
                    card:set_edition(extra.edition,true,false)
                end
                if extra.eternal~=nil then
                    card.ability.eternal=extra.eternal
                end
                if extra.perishable~=nil then
                    card.ability.perishable = extra.perishable
                    if tag=='v_epilogue' then
                        card.ability.perish_tally=get_voucher('epilogue').config.extra
                    else card.ability.perish_tally = G.GAME.perishable_rounds
                    end
                end
                if extra.extra_ability~=nil then
                    card.ability[extra.extra_ability]=true
                end
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
                if message~=nil then
                    card_eval_status_text(card,'extra',nil,nil,nil,{message=messae})
                end
        return true
    end)}))
end

local function create_joker(card_type,tag,message,extra, rarity)
    extra=extra or {}
    
    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
                local card = create_card(card_type, G.joker, nil, rarity, nil, nil, extra.forced_key or nil, tag)
                card:add_to_deck()
                if extra.edition~=nil then
                    card:set_edition(extra.edition,true,false)
                end
                if extra.eternal~=nil then
                    card.ability.eternal=extra.eternal
                end
                if extra.perishable~=nil then
                    card.ability.perishable = extra.perishable
                    if tag=='v_epilogue' then
                        card.ability.perish_tally=get_voucher('epilogue').config.extra
                    else card.ability.perish_tally = G.GAME.perishable_rounds
                    end
                end
                if extra.extra_ability~=nil then
                    card.ability[extra.extra_ability]=true
                end
                G.jokers:emplace(card)
                G.GAME.joker_buffer = 0
                if message~=nil then
                    card_eval_status_text(card,'extra',nil,nil,nil,{message=message})
                end
        return true
    end)}))
end

SMODS.Atlas { key = 'Joker', path = 'Jokers.png', px = 71, py = 95 }
SMODS.Atlas { key = 'Consumables', path = 'Tarots.png', px = 71, py = 95 }
SMODS.Atlas { key = 'Enhancers', path = 'Enhancers.png', px = 71, py = 95 }
SMODS.Atlas { key = 'SuitEffects', path = 'Double_Suit_Cards.png', px = 71, py = 95 }
SMODS.Atlas { key = 'Booster', path = 'boosters.png', px = 71, py = 95 }


SMODS.ConsumableType { 
    key = 'Familiar_Tarots',
    collection_rows = { 5,6 },
    primary_colour = HEX("2e3530"),
    secondary_colour = HEX("2e3530"),
    loc_txt = {
        collection = 'Fortune',
        name = 'Fortune',
        label = 'Fortune',
        undiscovered = {
			name = "Not Discovered",
			text = {
				"Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
			},
		},
    },
}
SMODS.UndiscoveredSprite {
	key = "Familiar_Tarots",
	atlas = "Consumables",
	pos = {
		x = 6,
		y = 2,
	}
}
SMODS.ConsumableType { 
    key = 'Familiar_Spectrals',
    collection_rows = { 4,5 },
    primary_colour = HEX("e16363"),
    secondary_colour = HEX("e16363"),
    loc_txt = {
        collection = 'Mementos',
        name = 'Mementos',
        label = 'Mementos',
        undiscovered = {
			name = "Not Discovered",
			text = {
				"Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
			},
		},
    },
}
SMODS.UndiscoveredSprite {
	key = "Familiar_Spectrals",
	atlas = "Consumables",
	pos = {
		x = 5,
		y = 2,
	}
}

-- JokersV1
SMODS.Joker {
    key = 'apophenia',
    config = {
        extra = { },
    },
    atlas = 'Joker',
    pos = { x = 6, y = 3 },
    loc_txt = {
        ['en-us'] = {
            name = 'Apophenia',
            text = {
                "No cards",
                "are considered",
                "{C:attention}face{} cards",
            }
        }
    },
    rarity = 3,
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
    end
}
SMODS.Joker {
    key = 'strawberry',
    config = {
        extra = {mult = 20, mult_mod = 1},
    },
    atlas = 'Joker',
    pos = { x = 4, y = 10 },
    loc_txt = {
        ['en-us'] = {
            name = 'Strawberry',
            text = {
                "{C:mult}+#1#{} Mult",
                "{C:mult}-#2#{} Mult for",
                "every hand played",
            }
        }
    },
    rarity = 1,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod} }
    end,
    calculate = function(self, card, context)
        if context.after then
            if card.ability.extra.mult - card.ability.extra.mult_mod <= 0 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_melted_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
                return {
                    message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.mult_mod}},
                    colour = G.C.RED,
                }
                
            end
        end
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult, 
                colour = G.C.RED,
                card = self,
            }
        end
    end
}
SMODS.Joker {
    key = 'rna',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 5, y = 10 },
    loc_txt = {
        ['en-us'] = {
            name = 'RNA',
            text = {
                "If {C:attention}first discard{} of round",
                "has only {C:attention}1{} card, add a",
                "permanent copy to deck",
            }
        }
    },
    rarity = 3,
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if G.GAME.current_round.discards_used <= 0 then
            local eval = function()
                return G.GAME.current_round.discards_used <= 0
            end
            juice_card_until(card, eval, true)
            if context.end_of_round then
                return
            end
        end
        if G.GAME.current_round.discards_used <= 0 and context.discard then
            if #context.full_hand == 1 then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.deck:emplace(_card)
                _card.states.visible = nil

                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:start_materialize()
                        return true
                    end
                })) 
                return {
                    message = localize('k_copied_ex'),
                    colour = G.C.RED,
                    card = self,
                    playing_cards_created = {true}
                }
            end
        end
    end
}
SMODS.Joker {
    key = 'sploosh',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 6, y = 10 },
    loc_txt = {
        ['en-us'] = {
            name = 'Sploosh',
            text = {
                "Every {C:attention}In-hand{} card vaules",
                "counts in scoring",
            }
        }
    },
    rarity = 2,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for i = 1, #G.hand.cards do
                highlight_card(G.hand.cards[i])
            end
        end
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            local id = context.other_card:get_chip_bonus()
            SMODS.eval_this(context.other_card, {chip_mod = id, message = localize{type='variable',key='a_chips',vars={id}}} )
        end
        if context.joker_main then
            for i = 1, #G.hand.cards do
                highlight_card(G.hand.cards[i],(i-0.999)/(#G.hand.cards-0.998),'down')
            end
        end
    end
}
SMODS.Joker {
    key = 'red_jester',
    config = {
        extra = {mult = 1, deckcards = 26},
    },
    atlas = 'Joker',
    pos = { x = 7, y = 10 },
    loc_txt = {
        ['en-us'] = {
            name = 'Red Jester',
            text = {
                "{C:mult}+#1#{} Mult for every two",
                "remaining cards in {C:attention}deck",
                "{C:inactive}(Currently {C:mult}+#2#{} {C:inactive}Mult)",
            }
        }
    },
    rarity = 1,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.deckcards } }
    end,
    calculate = function(self, card, context)
        card.ability.extra.deckcards = card.ability.extra.mult*(#G.deck.cards/2)
        if #G.deck.cards > 0 and context.joker_main then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult * (#G.deck.cards/2)}},
                mult_mod = card.ability.extra.mult * (#G.deck.cards/2), 
                colour = G.C.MULT,
                card = self
            }
        end
    end
}
SMODS.Joker {
    key = 'purple_card',
    config = {
        extra = { chips = 0, chip_mod = 20},
    },
    atlas = 'Joker',
    pos = { x = 7, y = 11 },
    loc_txt = {
        ['en-us'] = {
            name = 'Purple Card',
            text = {
                "This Joker gains",
                "{C:blue}+#2#{} Chips when any",
                "{C:attention}Booster Pack{} is skipped",
                "{C:inactive}(Currently {C:blue}+#1#{} {C:inactive}Chips)",
            }
        }
    },
    rarity = 1,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
    end,
    calculate = function(self, card, context)
        if context.skipping_booster then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chip_mod}},
                        colour = G.C.CHIPS,
                        delay = 0.45, 
                        card = self
                    }) 
                    return true
                end}))
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker {
    key = 'smudged_jester',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 4, y = 6 },
    loc_txt = {
        ['en-us'] = {
            name = 'Smudged Jester',
            text = {
                "{C:attention}3s{} counts as {C:attention}8s{}",
                "{C:attention}6s{} count as {C:attention}9s{}",
                "{C:attention}Kings{} count as {C:attention}Aces{}",
            }
        }
    },
    rarity = 2,
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        
    end
}
SMODS.Joker {
    key = 'con_man',
    config = {
        extra = { money = 10 },
    },
    atlas = 'Joker',
    pos = { x = 6, y = 5 },
    loc_txt = {
        ['en-us'] = {
            name = 'Con Man',
            text = {
                "Spend {C:money}$#1#{} dollars to create",
                "a random duplicate of a {C:attention}Joker",
                "or a {C:tarot}Consumable{} you currently have.",
                "{C:inactive}(Must have room){}"

            }
        }
    },
    rarity = 3,
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            if G.GAME.dollars >= card.ability.extra.money then
                local random = math.random(1,2)
                if #G.consumeables.cards > 0 and random == 1 then
                    local eligibleConsumeables = {}
                    for i = 1, #G.consumeables.cards do
                        if G.consumeables.cards[i].ability.name ~= card.ability.name then
                            eligibleConsumeables[#eligibleConsumeables+1] = G.consumeables.cards[i] 
                        end
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = copy_card(pseudorandom_element(eligibleConsumeables, pseudoseed('fam_con_man')), nil)
                            card:add_to_deck()
                            G.consumeables:emplace(card) 
                            return true
                        end}))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                    ease_dollars(-card.ability.extra.money)
                    card.ability.extra.money = card.ability.extra.money + 2
                end
                if #G.jokers.cards > 0 and random == 2 then
                    local eligibleJokers = {}
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i].ability.name ~= card.ability.name then
                            eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] 
                        end
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = copy_card(pseudorandom_element(eligibleJokers, pseudoseed('fam_con_man')), nil)
                            card:add_to_deck()
                            G.jokers:emplace(card) 
                            return true
                        end}))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                    ease_dollars(-card.ability.extra.money)
                    card.ability.extra.money = card.ability.extra.money + 2
                end
            end
        end
    end
}
SMODS.Joker {
    key = 'crimsonotype',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 0, y = 3 },
    loc_txt = {
        ['en-us'] = {
            name = 'Crimsonotype',
            text = {
                "Copies ability of",
                "{C:attention}Joker{} to the left",
            }
        }
    },
    rarity = 3,
    cost = 10,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        local jokers = G.jokers.cards
        for i = 1, #jokers do
            if jokers[i] == card then
                other_joker = jokers[i-1] 
            end
        end
        if not other_joker then
            return 
        end
        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
        context.blueprint_card = context.blueprint_card or card
        if context.blueprint > #G.jokers.cards + 1 then 
            return 
        end
        local other_joker_ret = other_joker:calculate_joker(context)
        if other_joker_ret then 
            other_joker_ret.card = context.blueprint_card or card
            other_joker_ret.colour = G.C.RED
            return other_joker_ret
        end
    end
}
--SMODS.Joker {
--    key = 'the_twins',
--    config = {
--        extra = {poker_hand = "Pair", xchips = 2},
--    },
--    atlas = 'Joker',
--    pos = { x = 5, y = 4 },
--    loc_txt = {
--        ['en-us'] = {
--            name = 'The Twins',
--            text = {
--                "{C:blue}X2{} Chips if played hand contains a Pair",
--            }
--        }
--    },
--    rarity = 3,
--    cost = 8,
--    loc_vars = function(self, info_queue, card)
--        return { vars = { card.ability.extra.xchips, localize(card.ability.extra.poker_hand, 'poker_hands') } }
--    end,
--    calculate = function(self, card, context)
--        if context.joker_main and context.cardarea == G.jokers and context.scoring_name == card.ability.extra.poker_hand then
--            return {
--                message = localize{type='variable', key='a_chips', vars={card.ability.extra.xchips}},
--                chip_mod = G.GAME.chips,
--                colour = G.C.CHIPS,
--                card = self
--            }
--        end
--    end
--}
SMODS.Joker {
    key = 'thinktank',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 7, y = 7 },
    loc_txt = {
        ['en-us'] = {
            name = 'Thinktank',
            text = {
                "Copies the ability",
                "of rightmost {C:attention}Joker{}",
            }
        }
    },
    rarity = 3,
    cost = 10,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        local jokers = G.jokers.cards
        other_joker = jokers[#jokers] 
        if not other_joker then
            return 
        end
        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
        context.blueprint_card = context.blueprint_card or card
        if context.blueprint > #G.jokers.cards + 1 then 
            return 
        end
        local other_joker_ret = other_joker:calculate_joker(context)
        if other_joker_ret then 
            other_joker_ret.card = context.blueprint_card or card
            other_joker_ret.colour = G.C.RED
            return other_joker_ret
        end
    end
}
SMODS.Joker {
    key = 'astrophysicist',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 7, y = 3 },
    loc_txt = {
        ['en-us'] = {
            name = 'Astrophysicist',
            text = {
                "Create a {C:blue}Planet{} card",
                "when {C:attention}Blind{} is selected",
                "{C:inactive}(Must have room)",
            }
        }
    },
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not self.getting_sliced then
            create_consumable("Planet", nil, {localize('k_plus_tarot'), colour = G.C.blue})
        end
    end
}
SMODS.Joker {
    key = 'taromancer',
    config = {
        extra = {},
    },
    atlas = 'Joker',
    pos = { x = 2, y = 7 },
    loc_txt = {
        ['en-us'] = {
            name = 'Taromancer',
            text = {
                "All {C:tarot}Tarot{} cards and",
                "{C:tarot}Arcana Packs{} in",
                "the shop are {C:attention}free",
            }
        }
    },
    rarity = 2,
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        
    end
}
SMODS.Joker {
    key = 'archibald',
    config = {
        extra = { money = 50},
    },
    atlas = 'Joker',
    pos = { x = 7, y = 8 },
    loc_txt = {
        ['en-us'] = {
            name = 'Archibald',
            text = {
                "Gives {C:money}$50{} for every",
                "{C:attention}2{} consumables in hand.",
            }
        }
    },
    rarity = 4,
    cost = 20,
    soul_pos = {x = 7, y = 9},
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if #G.consumeables.cards % 2 == 0 and #G.consumeables.cards ~= 0 then
                ease_dollars(card.ability.extra.money * (#G.consumeables.cards/2))
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    message = localize('$')..card.ability.extra.money,
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-- JokersV2
SMODS.Joker {
    key = 'neopolitan',
    config = {
        extra = {chips = 50, chip_mod = 10 , mult = 10, mult_mod = 2, money = 5, money_mod = 1},
    },
    atlas = 'Joker',
    pos = { x = 14, y = 10 },
    loc_txt = {
        ['en-us'] = {
            name = 'Neopolitan',
            text = {
                "{C:blue}+#3#{} Chips or {C:mult}+#1#{} Mult or {C:money}+$#5#{}",
                "{C:blue}-#4#{} Chips, {C:mult}-#2#{} Mult, and {C:money}-$#6#{}",
                "for every hand played",
            }
        }
    },
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.money, card.ability.extra.money_mod} }
    end,
    calculate = function(self, card, context)
        if context.after then
            if card.ability.extra.mult - card.ability.extra.mult_mod <= 0 or card.ability.extra.chips - card.ability.extra.chip_mod <= 0 or card.ability.extra.money - card.ability.extra.money_mod <= 0 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_melted_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
                card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                card.ability.extra.money = card.ability.extra.money - card.ability.extra.money_mod
                if 1 == 1 then
                    return {
                        message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.mult_mod}},
                        colour = G.C.RED,
                    }
                end
                if 1 == 1 then
                    return {
                        message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.chip_mod}},
                        colour = G.C.CHIPS,
                    }
                end
                return {
                    message = localize('-$')..card.ability.extra.money_mod,
                    colour = G.C.MONEY
                }
            end
        end
        if context.joker_main then
            if pseudorandom('neopolitan') < G.GAME.probabilities.normal/3 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult, 
                    colour = G.C.RED,
                    card = self,
                }
            elseif pseudorandom('neopolitan') < G.GAME.probabilities.normal/2 then
                ease_dollars(card.ability.extra.money)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    message = localize('$')..card.ability.extra.money,
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            else
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chip_mod = card.ability.extra.chips, 
                    colour = G.C.CHIPS,
                    card = self,
                }
            end
        end
    end
}

-- Familiar Tarots
SMODS.Consumable{
    key = 'the_broken',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 0, y = 0 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Broken",
            text = {
                "Creates a {C:attention}Familiar Consumable",
                "based on the {C:attention}Consumable",
                "you last used",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if (#G.consumeables.cards <= G.consumeables.config.card_limit or self.area == G.consumeables) and G.GAME.last_tarot_planet and G.GAME.last_tarot_planet ~= 'c_fool' then
            return true 
        end
    end,
    use = function(self, card)
        if G.GAME.last_tarot_planet == "c_strength" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_vigor'})
        elseif G.GAME.last_tarot_planet == "c_hanged_man" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_martyr'})
        elseif G.GAME.last_tarot_planet == "c_death" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_demise'})
        elseif G.GAME.last_tarot_planet == "c_judgement" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_verdict'})
        elseif G.GAME.last_tarot_planet == "c_high_priestess" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_harlot'})
        elseif G.GAME.last_tarot_planet == "c_wheel_of_fortune" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_cycle_of_fate'}) 
        elseif G.GAME.last_tarot_planet == "c_devil" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_humanity'}) 
        elseif G.GAME.last_tarot_planet == "c_world" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_landscape'}) 
        elseif G.GAME.last_tarot_planet == "c_moon" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_midnight'}) 
        elseif G.GAME.last_tarot_planet == "c_star" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_galaxy'}) 
        elseif G.GAME.last_tarot_planet == "c_sun" then
            create_consumable("Familiar_Tarots", nil, nil, {forced_key='c_fam_the_daylight'}) 
        end
    end,
}
SMODS.Consumable{
    key = 'the_harlot',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 2, y = 0 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Harlot",
            text = {
                "Creates a {C:attention}planet{} card",
                "of your {C:attention}most{} used poker hand",
                "{C:inactive}(Must have room){}"
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then 
            return true 
        end
    end,
    use = function(self, card)
        local _planet, _hand, _tally = nil, nil, 0
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                _hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if _hand then
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == _hand then
                    _planet = v.key
                end
            end
        end
        create_consumable("Planet",'pl1',nil,{forced_key = _planet}, true, true)
    end,
}
SMODS.Consumable{
    key = 'the_cycle_of_fate',
    set = 'Familiar_Tarots',
    config = { extra = { odds = 4 } },
    atlas = 'Consumables',
    pos = { x = 0, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Cycle of Fate",
            text = {
                "{C:green,E:1,S:1.1}#2# in #1#{} chance to",
                "make a {C:attention}joker{} Negative.",
                "{C:inactive}(Overrides other Editions){}"
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negativeJKJKJKJKJKJKJKJKJ
        return { vars = { card.ability.extra.odds, '' .. (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    can_use = function(self, card, area, copier)
        if #G.jokers.cards > 0 then 
            return true 
        end
    end,
    use = function(self, card)
        if pseudorandom('cycle_of_fate') < G.GAME.probabilities.normal/card.ability.extra.odds then
            local eligibleJokers = {}
            for i = 1, #G.jokers.cards do
                eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] 
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local edition = {negative = true}
                G.jokers.cards[math.random(1,#G.jokers.cards)]:set_edition(edition, true)
                card:juice_up(0.3, 0.5)
            return true end }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.GREY,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
        end
        delay(0.6)
    end,
}
SMODS.Consumable{
    key = 'vigor',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 1, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "Vigor",
            text = {
                "Increases rank of",
                "{C:attention}one{} selected card",
                "by {C:attention}3",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted == 1) and G.hand.highlighted[1] then
            return true 
        end
    end,
    use = function(self, card)
        for i = 1, #G.hand.highlighted do
            for j = 1, 3 do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    local card = G.hand.highlighted[i]
                    local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                    local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                    elseif rank_suffix == 10 then rank_suffix = 'T'
                    elseif rank_suffix == 11 then rank_suffix = 'J'
                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                    elseif rank_suffix == 13 then rank_suffix = 'K'
                    elseif rank_suffix == 14 then rank_suffix = 'A'
                    end
                    card:juice_up(0.3, 0.5)
                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                return true end }))
            end
        end  
    end,
}
SMODS.Consumable{
    key = 'the_martyr',
    set = 'Familiar_Tarots',
    config = { extra = 2 },
    atlas = 'Consumables',
    pos = { x = 2, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Martyr",
            text = {
                "Creates {C:attention}2{} random cards",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier, context)
        if G.hand then
            return true 
        end
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function() 
                local cards = {}
                for i=1, self.config.extra do
                    cards[i] = true
                    local _suit, _rank = nil, nil
                    _rank = pseudorandom_element({'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}, pseudoseed('incantation_create'))
                    _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('incantation_create'))
                    _suit = _suit or 'S'; _rank = _rank or 'A'
                    create_playing_card({front = G.P_CARDS[_suit..'_'.._rank]}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
                end
                playing_card_joker_effects(cards)
        return true end }))
    end,
}
SMODS.Consumable{
    key = 'demise',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 3, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "Demise",
            text = {
                "Select {C:attention}3{} cards,",
                "convert {C:attention}them{} into",
                "a {C:attention}random{} selected card",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted == 3) then
            return true 
        end
    end,
    use = function(self, card)
        local random = G.hand.highlighted[math.random(1, #G.hand.highlighted)]
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                if G.hand.highlighted[i] ~= random then
                    G.hand.highlighted[i]:juice_up(0.3, 0.5)
                    copy_card(random, G.hand.highlighted[i])
                end
            return true end }))
        end  
    end,
}
SMODS.Consumable{
    key = 'humanity',
    set = 'Familiar_Tarots',
    config = { mod_conv = 'm_fam_gilded', max_highlighted = 2 },
    atlas = 'Consumables',
    pos = { x = 5, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "Humanity",
            text = {
                "Enhances {C:attention}2{} selected card",
                "into a {C:attention}Gilded card{}.",
            }
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.m_fam_gilded

        return {vars = {self.config.max_highlighted}}
    end,
}
SMODS.Consumable{
    key = 'the_galaxy',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 7, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Galaxy",
            text = {
                "Adds {C:diamonds}Diamonds{} to up",
                "to {C:attention}3{} selected cards.",
                "{C:inactive}(Does not remove other suit(s))",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted <= 3) and #G.hand.highlighted ~= 0 then
            return true 
        end
    end,
    use = function(self, card)
        for i = 1, #G.hand.highlighted do
            G.hand.highlighted[i].ability.is_diamond = true
            set_sprite_suits(G.hand.highlighted[i], true)
        end
    end,
}
SMODS.Consumable{
    key = 'the_midnight',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 8, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Midnight",
            text = {
                "Adds {C:clubs}Clubs{} to up",
                "to {C:attention}3{} selected cards.",
                "{C:inactive}(Does not remove other suit(s))",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted <= 3) and #G.hand.highlighted ~= 0 then
            return true 
        end
    end,
    use = function(self, card)
        for i = 1, #G.hand.highlighted do
            G.hand.highlighted[i].ability.is_club = true
            set_sprite_suits(G.hand.highlighted[i], true)
        end
    end,
}
SMODS.Consumable{
    key = 'the_daylight',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 9, y = 1 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Daylight",
            text = {
                "Adds {C:hearts}Hearts{} to up",
                "to {C:attention}3{} selected cards.",
                "{C:inactive}(Does not remove other suit(s))",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted <= 3) and #G.hand.highlighted ~= 0 then
            return true 
        end
    end,
    use = function(self, card)
        for i = 1, #G.hand.highlighted do
            G.hand.highlighted[i].ability.is_heart = true
            set_sprite_suits(G.hand.highlighted[i], true)
        end
    end,
}
SMODS.Consumable{
    key = 'verdict',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 0, y = 2 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "Verdict",
            text = {
                "Creates a random",
                "{C:attention}Consumble{} card",

            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then 
            return true 
        end
    end,
    use = function(self, card)
        create_consumable("Consumeables", nil, nil, nil)
    end,
}
SMODS.Consumable{
    key = 'the_landscape',
    set = 'Familiar_Tarots',
    config = { },
    atlas = 'Consumables',
    pos = { x = 1, y = 2 },
    cost = 3,
    loc_txt = {
        ['en-us'] = {
            name = "The Landscape",
            text = {
                "Adds {C:spades}Spades{} to up",
                "to {C:attention}3{} selected cards.",
                "{C:inactive}(Does not remove other suit(s))",
            }
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted <= 3) and #G.hand.highlighted ~= 0 then
            return true 
        end
    end,
    use = function(self, card)
        for i = 1, #G.hand.highlighted do
            G.hand.highlighted[i].ability.is_spade = true
            set_sprite_suits(G.hand.highlighted[i], true)
        end
    end,
}

-- Familiar Spectrals 
SMODS.Consumable{
    key = 'forge',
    set = 'Familiar_Spectrals',
    config = { extra = {mod_conv = "s_fam_gilded_seal"} },
    atlas = 'Consumables',
    pos = { x = 3, y = 4 },
    loc_txt = {
        ['en-us'] = {
            name = "Forge",
            text = {
                "Add a {C:money}Gilded Seal",
                "to 2 {C:attention}selected cards{}",
                "in your hand",
            }
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.s_fam_sapphire_seal
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted <= 2)  then
            return true 
        end
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            for i = 1, #G.hand.highlighted do 
                G.hand.highlighted[i]:set_seal("s_fam_gilded_seal", nil, true)
            end
            return true end }))
        
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end,
}
SMODS.Consumable{
    key = 'shade',
    set = 'Familiar_Spectrals',
    config = { extra = { odds = 4 } },
    atlas = 'Consumables',
    pos = { x = 5, y = 4 },
    loc_txt = {
        ['en-us'] = {
            name = "Shade",
            text = {
                "{C:green,E:1,S:1.1}#3# in #2#{} chance to",
                "create a {C:mult}rare{} joker",
                "{C:green,E:1,S:1.1}#3# in #1#{} chance to",
                "set money to {C:attention}-$10{}",
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.odds, card.ability.extra.odds/2, G.GAME.probabilities.normal } }
    end,
    can_use = function(self, card, area, copier)
        if #G.jokers.cards < G.jokers.config.card_limit then 
            return true 
        end
    end,
    use = function(self, card)
        if pseudorandom('shade1') < G.GAME.probabilities.normal/(card.ability.extra.odds/2) then
            create_joker('Joker', nil, nil, nil, 0.99)
        end
        if pseudorandom('shade2') < G.GAME.probabilities.normal/card.ability.extra.odds then
            if G.GAME.dollars ~= 0 then
                ease_dollars(-(G.GAME.dollars + 10), true)
            end
        end
    end,
}
--SMODS.Consumable{
--    key = 'playback',
--    set = 'Familiar_Spectrals',
--    config = { extra = {mod_conv = "s_fam_gilded_seal"} },
--    atlas = 'Consumables',
--    pos = { x = 1, y = 5 },
--    loc_txt = {
--        ['en-us'] = {
--            name = "Playback",
--            text = {
--                "Add a {C:red}Maroon Seal",
--                "to one {C:attention}selected card{}",
--                "in your hand",
--            }
--        }
--    },
--    loc_vars = function(self, info_queue)
--        info_queue[#info_queue+1] = G.P_CENTERS.s_fam_sapphire_seal
--        return { vars = { } }
--    end,
--    can_use = function(self, card, area, copier)
--        if G.hand and (#G.hand.highlighted == 1) and G.hand.highlighted[1] then
--            return true 
--        end
--    end,
--    use = function(self, card)
--        local conv_card = G.hand.highlighted[1]
--        G.E_MANAGER:add_event(Event({func = function()
--            play_sound('tarot1')
--            card:juice_up(0.3, 0.5)
--            return true end }))
--        
--        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
--            conv_card:set_seal("s_fam_gilded_seal", nil, true)
--            return true end }))
--        
--        delay(0.5)
--        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
--    end,
--}
SMODS.Consumable{
    key = 'mesmer',
    set = 'Familiar_Spectrals',
    config = { extra = {mod_conv = "m_fam_sapphire_seal"} },
    atlas = 'Consumables',
    pos = { x = 3, y = 5 },
    loc_txt = {
        ['en-us'] = {
            name = "Mesmer",
            text = {
                "Add a {C:blue}Sapphire Seal",
                "to one {C:attention}selected card{}",
                "in your hand",
            }
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.s_fam_sapphire_seal
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted == 1) and G.hand.highlighted[1] then
            return true 
        end
    end,
    use = function(self, card)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            conv_card:set_seal("s_fam_sapphire_seal", nil, true)
            return true end }))
        
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end,
}
SMODS.Consumable{
    key = 'oracle',
    set = 'Familiar_Spectrals',
    config = { extra = {mod_conv = "m_fam_familiar_seal"} },
    atlas = 'Consumables',
    pos = { x = 4, y = 5 },
    loc_txt = {
        ['en-us'] = {
            name = "Oracle",
            text = {
                "Add a Familiar Seal",
                "to one {C:attention}selected card{}",
                "in your hand",
            }
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.s_fam_familiar_seal
        return { vars = { } }
    end,
    can_use = function(self, card, area, copier)
        if G.hand and (#G.hand.highlighted == 1) and G.hand.highlighted[1] then
            return true 
        end
    end,
    use = function(self, card)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            conv_card:set_seal("s_fam_familiar_seal", nil, true)
            return true end }))
        
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end,
}

-- Boosters
SMODS.Booster{
	name = "Fortune Pack",
	key = "forture_booster_1",
    group_key = "forture_booster",
	atlas = 'Booster',
	pos = {x = 0, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = "Fortune Booster Pack",
            text = {
                "Choose {C:attention}#1#{} of up to",
				"{C:attention}#2#{} Fortune Cards"
            }
        }
    },
	weight = 0.7 * 4,
	cost = 6,
	config = {draw_hand = true, extra = 4, choose = 1},
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.draw_hand, card.config.center.config.choose, card.ability.extra} }
	end,
	create_card = function(self, card)
		return create_card("Familiar_Tarots", G.pack_cards, nil, nil, true, true, nil, 'fam_forture')
	end,
    update_pack = function(self, dt)
        if G.buttons then self.buttons:remove(); G.buttons = nil end
        if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
            G.CONTROLLER.interrupt.focus = true
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if self.sparkles then
                        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                            timer = self.sparkles.timer or 0.015,
                            scale = self.sparkles.scale or 0.1,
                            initialize = true,
                            lifespan = self.sparkles.lifespan or 3,
                            speed = self.sparkles.speed or 0.2,
                            padding = self.sparkles.padding or -1,
                            attach = G.ROOM_ATTACH,
                            colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                            fill = true
                        })
                    end
                    G.booster_pack = UIBox{
                        definition = self:pack_uibox(),
                        config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                    }
                    G.booster_pack.alignment.offset.y = -2.2
                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                    self:ease_background_colour()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()
        
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end}))
                            return true
                        end
                    }))  
                    return true
                end
            }))  
        end
    end,
}
SMODS.Booster{
	name = "Fortune Tin",
	key = "forture_booster_2",
    group_key = "forture_booster",
	atlas = 'Booster',
	pos = {x = 0, y = 2},
    loc_txt = {
        ['en-us'] = {
            name = "Fortune Booster Tin",
            text = {
                "Choose {C:attention}#1#{} of up to",
				"{C:attention}#2#{} Fortune Cards"
            }
        }
    },
	weight = 0.7 * 2,
	cost = 9,
	config = {draw_hand = true, extra = 5, choose = 1},
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
	create_card = function(self, card)
		return create_card("Familiar_Tarots", G.pack_cards, nil, nil, true, true, nil, 'fam_forture')
	end,
    update_pack = function(self, dt)
        if G.buttons then self.buttons:remove(); G.buttons = nil end
        if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
            G.CONTROLLER.interrupt.focus = true
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if self.sparkles then
                        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                            timer = self.sparkles.timer or 0.015,
                            scale = self.sparkles.scale or 0.1,
                            initialize = true,
                            lifespan = self.sparkles.lifespan or 3,
                            speed = self.sparkles.speed or 0.2,
                            padding = self.sparkles.padding or -1,
                            attach = G.ROOM_ATTACH,
                            colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                            fill = true
                        })
                    end
                    G.booster_pack = UIBox{
                        definition = self:pack_uibox(),
                        config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                    }
                    G.booster_pack.alignment.offset.y = -2.2
                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                    self:ease_background_colour()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()
        
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end}))
                            return true
                        end
                    }))  
                    return true
                end
            }))  
        end
    end,
}
SMODS.Booster{
	name = "Fortune Chest",
	key = "forture_booster_3",
    group_key = "forture_booster",
	atlas = 'Booster',
	pos = {x = 2, y = 2},
    loc_txt = {
        ['en-us'] = {
            name = "Fortune Collector Chest",
            text = {
                "Choose {C:attention}#1#{} of up to",
				"{C:attention}#2#{} Fortune Cards"
            }
        }
    },
	weight = 0.7 * 0.5,
	cost = 12,
	config = {draw_hand = true, extra = 5, choose = 2},
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
	create_card = function(self, card)
		return create_card("Familiar_Tarots", G.pack_cards, nil, nil, true, true, nil, 'fam_forture')
	end,
    update_pack = function(self, dt)
        if G.buttons then self.buttons:remove(); G.buttons = nil end
        if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
            G.CONTROLLER.interrupt.focus = true
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if self.sparkles then
                        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                            timer = self.sparkles.timer or 0.015,
                            scale = self.sparkles.scale or 0.1,
                            initialize = true,
                            lifespan = self.sparkles.lifespan or 3,
                            speed = self.sparkles.speed or 0.2,
                            padding = self.sparkles.padding or -1,
                            attach = G.ROOM_ATTACH,
                            colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                            fill = true
                        })
                    end
                    G.booster_pack = UIBox{
                        definition = self:pack_uibox(),
                        config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                    }
                    G.booster_pack.alignment.offset.y = -2.2
                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                    self:ease_background_colour()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()
        
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end}))
                            return true
                        end
                    }))  
                    return true
                end
            }))  
        end
    end,
}
SMODS.Booster{
	name = "Ethereal Pack",
	key = "ethereal_booster_1",
    group_key = "ethereal_booster",
	atlas = 'Booster',
	pos = {x = 0, y = 4},
    loc_txt = {
        ['en-us'] = {
            name = "Ethereal Booster Pack",
            text = {
                "Choose {C:attention}#1#{} of up to",
				"{C:attention}#2#{} Memento Cards"
            }
        }
    },
	weight = 0.7 * 0.6,
	cost = 6,
	config = {draw_hand = true, extra = 2, choose = 1},
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
	create_card = function(self, card)
		return create_card("Familiar_Spectrals", G.pack_cards, nil, nil, true, true, nil, 'fam_memento')
	end,
    update_pack = function(self, dt)
        if G.buttons then self.buttons:remove(); G.buttons = nil end
        if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
            G.CONTROLLER.interrupt.focus = true
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if self.sparkles then
                        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                            timer = self.sparkles.timer or 0.015,
                            scale = self.sparkles.scale or 0.1,
                            initialize = true,
                            lifespan = self.sparkles.lifespan or 3,
                            speed = self.sparkles.speed or 0.2,
                            padding = self.sparkles.padding or -1,
                            attach = G.ROOM_ATTACH,
                            colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                            fill = true
                        })
                    end
                    G.booster_pack = UIBox{
                        definition = self:pack_uibox(),
                        config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                    }
                    G.booster_pack.alignment.offset.y = -2.2
                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                    self:ease_background_colour()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()
        
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end}))
                            return true
                        end
                    }))  
                    return true
                end
            }))  
        end
    end,
}
SMODS.Booster{
	name = "Ethereal Tin",
	key = "ethereal_booster_2",
    group_key = "ethereal_booster",
	atlas = 'Booster',
	pos = {x = 2, y = 4},
    loc_txt = {
        ['en-us'] = {
            name = "Ethereal Booster Tin",
            text = {
                "Choose {C:attention}#1#{} of up to",
				"{C:attention}#2#{} Memento Cards"
            }
        }
    },
	weight = 0.7 * 0.3,
	cost = 9,
	config = {draw_hand = true, extra = 4, choose = 1},
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
	create_card = function(self, card)
		return create_card("Familiar_Spectrals", G.pack_cards, nil, nil, true, true, nil, 'fam_memento')
	end,
    update_pack = function(self, dt)
        if G.buttons then self.buttons:remove(); G.buttons = nil end
        if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
            G.CONTROLLER.interrupt.focus = true
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if self.sparkles then
                        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                            timer = self.sparkles.timer or 0.015,
                            scale = self.sparkles.scale or 0.1,
                            initialize = true,
                            lifespan = self.sparkles.lifespan or 3,
                            speed = self.sparkles.speed or 0.2,
                            padding = self.sparkles.padding or -1,
                            attach = G.ROOM_ATTACH,
                            colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                            fill = true
                        })
                    end
                    G.booster_pack = UIBox{
                        definition = self:pack_uibox(),
                        config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                    }
                    G.booster_pack.alignment.offset.y = -2.2
                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                    self:ease_background_colour()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()
        
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end}))
                            return true
                        end
                    }))  
                    return true
                end
            }))  
        end
    end,
}
SMODS.Booster{
	name = "Ethereal Chest",
	key = "ethereal_booster_3",
    group_key = "ethereal_booster",
	atlas = 'Booster',
	pos = {x = 3, y = 4},
    loc_txt = {
        ['en-us'] = {
            name = "Ethereal Collector Chest",
            text = {
                "Choose {C:attention}#1#{} of up to",
				"{C:attention}#2#{} Memento Cards"
            }
        }
    },
	weight = 0.7 * 0.07,
	cost = 12,
	config = {draw_hand = true, extra = 4, choose = 2},
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
	create_card = function(self, card)
		return create_card("Familiar_Spectrals", G.pack_cards, nil, nil, true, true, nil, 'fam_memento')
	end,
    update_pack = function(self, dt)
        if G.buttons then self.buttons:remove(); G.buttons = nil end
        if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
        if not G.STATE_COMPLETE then
            G.STATE_COMPLETE = true
            G.CONTROLLER.interrupt.focus = true
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if self.sparkles then
                        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                            timer = self.sparkles.timer or 0.015,
                            scale = self.sparkles.scale or 0.1,
                            initialize = true,
                            lifespan = self.sparkles.lifespan or 3,
                            speed = self.sparkles.speed or 0.2,
                            padding = self.sparkles.padding or -1,
                            attach = G.ROOM_ATTACH,
                            colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                            fill = true
                        })
                    end
                    G.booster_pack = UIBox{
                        definition = self:pack_uibox(),
                        config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                    }
                    G.booster_pack.alignment.offset.y = -2.2
                    G.ROOM.jiggle = G.ROOM.jiggle + 3
                    self:ease_background_colour()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.FUNCS.draw_from_deck_to_hand()
        
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.5,
                                func = function()
                                    G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                    return true
                                end}))
                            return true
                        end
                    }))  
                    return true
                end
            }))  
        end
    end,
}

-- Seals
SMODS.Seal{
    key = 'gilded_seal',
    config = {
        extra = { odds = 4 },
    },
    atlas = 'Enhancers',
    pos = { x = 2, y = 0 },
    badge_colour = HEX("caae80"),
    loc_txt = {
        label = 'Gilded Seal',
        description = {
            name = 'Gilded Seal',
            text = {
                '{C:money}$5{} when played, {C:green,E:1,S:1.1}#2# in #1#{} chance',
                'that it gives {C:money}-$5{} instead.',
            }
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.odds, '' .. (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and not context.repetition and not context.blueprint then
            if pseudorandom('gilded_seal') < G.GAME.probabilities.normal/4 then
                ease_dollars(-5)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - 5
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return
            else
                ease_dollars(5)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 5
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return
            end
        end
    end
}
--SMODS.Seal{
--    key = 'maroon_seal',
--    config = {
--        extra = { },
--    },
--    atlas = 'Enhancers',
--    pos = { x = 5, y = 4 },
--    badge_colour = HEX("8a0a0a"),
--    loc_txt = {
--        label = 'Maroon Seal',
--        description = {
--            name = 'Maroon Seal',
--            text = {
--                'Retrigger cards left and right of this card an additional time',
--            }
--        },
--    },
--    loc_vars = function(self, info_queue, card)
--        return { vars = {  } }
--    end,
--    calculate = function(self, card, context)
--        if context.end_of_round and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
--            create_consumable("Spectral", nil, nil, nil)
--        end
--    end
--}
SMODS.Seal{
    key = 'sapphire_seal',
    config = {
        extra = {},
    },
    atlas = 'Enhancers',
    pos = { x = 6, y = 4 },
    badge_colour = HEX("0d47a0"),
    loc_txt = {
        label = 'Sapphire Seal',
        description = {
            name = 'Sapphire Seal',
            text = {
                'Creates a {C:blue}Spectral{} card',
                'if {C:attention}held in hand{} until',
                'the end of round',
            }
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            create_consumable("Spectral", nil, nil, nil)
        end
    end
}
SMODS.Seal{
    key = 'familiar_seal',
    config = {
        extra = {},
    },
    atlas = 'Enhancers',
    pos = { x = 4, y = 4 },
    badge_colour = HEX("3c423e"),
    loc_txt = {
        label = 'Familiar Seal',
        description = {
            name = 'Familiar Seal',
            text = {
                'Creates a {C:attention}Familiar tarot{} when',
                'card is {C:attention}destoyed',
            }
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.discard and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            create_consumable("Familiar_Tarots")
            card:start_dissolve()
        end
    end
}

-- Enhancements
SMODS.Enhancement {
    key = 'gilded',
    loc_txt = {
        name = 'Gilded',
        text = {
            "{C:money}$#1#{} when held in hand",
            "decreases by {C:money}$#2#{} each use",
            "becomes a {C:attention}steel card",
            "after {C:attention}#1#{} uses.",
        }
    },
    pos = {x = 6, y = 0}, 
    atlas = 'Enhancers', 
    config = { extra = {p_dollars = 5, dollar_mod = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.p_dollars, self.config.extra.dollar_mod} }
    end,
}

card_cal_seal = Card.calculate_seal
function Card:calculate_seal(context)
    local ret = card_cal_seal(self,context)
    if self.debuff then return nil end
    if context.end_of_round then
        if self.config.center == G.P_CENTERS.m_fam_gilded then
            if self.ability.extra.p_dollars <= 0 then
                self.config.center = G.P_CENTERS.m_steel
            else
                ease_dollars(self.ability.extra.p_dollars)
                self.ability.extra.p_dollars = self.ability.extra.p_dollars - self.ability.extra.dollar_mod
            end
        end
    end
    return ret
end

local get_idref = Card.get_id
function Card:get_id()
    get_idref(self)
    local id = self.base.id
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].ability.name == "j_fam_smudged_jester" then
            if id == 3 then
                return 8
            elseif id == 6 then
                return 9
            elseif id == 13 then
                return 14
            end
        end
    end
    return self.base.id
end

local is_suitref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    is_suitref(self)
    if next(find_joker('Smeared Joker')) then
        if (self.base.suit == 'Spades' or self.ability.is_spade == true) or (self.base.suit == 'Clubs' or self.ability.is_club == true) then
            if suit == 'Spades' or suit == 'Clubs' then
                return true
            end
        end
        if (self.base.suit == 'Hearts' or self.ability.is_heart == true) or (self.base.suit == 'Diamonds' or self.ability.is_diamond == true) then
            if suit == 'Hearts' or suit == 'Diamonds' then
                return true
            end
        end
    else
        if self.ability.is_spade == true then
            set_sprite_suits(self, false)
            if suit == 'Spades' then
                return true
            end
        end
        if self.ability.is_heart == true then
            set_sprite_suits(self, false)
            if suit == 'Hearts' then
                return true
            end
        end
        if self.ability.is_club == true then
            set_sprite_suits(self, false)
            if suit == 'Clubs' then
                return true
            end
        end
        if self.ability.is_diamond == true then
            set_sprite_suits(self, false)
            if suit == 'Diamonds' then
                return true
            end
        end
    end
    return self.base.suit == suit
end

local is_faceref = Card.is_face
function Card:is_face(from_boss)
    is_faceref(self)
    if self.debuff and not from_boss then return end
    local id = self:get_id()
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].ability.name == "j_fam_apophenia" then
            return false
        end
    end
    if id == 11 or id == 12 or id == 13 or next(find_joker("Pareidolia")) then
        return true
    end
end

local set_costref = Card.set_cost
function Card:set_cost()
    set_costref(self)
    if (self.ability.set == 'Tarot' or (self.ability.set == 'Booster' and self.ability.name:find('Arcana'))) and #find_joker('j_fam_taromancer') > 0 then
        self.cost = 0
    end
end

function set_sprite_suits(card, juice)
	local id = card:get_id()
    local position = id - 2
    -- Sets Sprites
    if card.base.suit == 'Diamonds' and card.ability.is_diamond == true and card.ability.is_club ~= true and card.ability.is_spade ~= true and card.ability.is_heart ~= true then
        return
    elseif card.base.suit == 'Clubs' and card.ability.is_club == true and card.ability.is_diamond ~= true and card.ability.is_spade ~= true and card.ability.is_heart ~= true then
        return
    elseif card.base.suit == 'Spades' and card.ability.is_spade == true and card.ability.is_diamond ~= true and card.ability.is_club ~= true and card.ability.is_heart ~= true then
        return
    elseif card.base.suit == 'Hearts' and card.ability.is_heart == true and card.ability.is_diamond ~= true and card.ability.is_spade ~= true and card.ability.is_club ~= true then
        return
    end
    card.children.front.atlas = G.ASSET_ATLAS['fam_SuitEffects']
    if (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) and not card.ability.is_club == true and not card.ability.is_diamond == true then -- Hearts & Spades
        card.children.front:set_sprite_pos({x = position, y = 2})
    elseif (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and (card.base.suit == 'Clubs' or card.ability.is_club == true ) and not card.ability.is_spade == true and not card.ability.is_diamond == true then -- Hearts & Clubs
        card.children.front:set_sprite_pos({x = position, y = 0})
    elseif (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) and (card.base.suit == 'Clubs' or card.ability.is_club == true ) and not card.ability.is_diamond == true then -- Hearts, Clubs, & Spades
        card.children.front:set_sprite_pos({x = position, y = 7})
    elseif (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) and (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and not card.ability.is_club == true then -- Hearts, Diamonds, & Spades
        card.children.front:set_sprite_pos({x = position, y = 8})
    elseif (card.base.suit == 'Clubs' or card.ability.is_club == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) and not card.ability.is_heart == true and not card.ability.is_diamond == true then -- Clubs & Spades
        card.children.front:set_sprite_pos({x = position, y = 4})
    elseif (card.base.suit == 'Clubs' or card.ability.is_club == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) and (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and not card.ability.is_heart == true then -- Clubs, Diamonds, & Spades
        card.children.front:set_sprite_pos({x = position, y = 9})
    elseif (card.base.suit == 'Clubs' or card.ability.is_club == true ) and (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and not card.ability.is_spade == true then -- Clubs, Diamonds, & Hearts
        card.children.front:set_sprite_pos({x = position, y = 6})
    elseif (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) and not card.ability.is_club == true and not card.ability.is_heart == true then -- Diamonds & Spades
        card.children.front:set_sprite_pos({x = position, y = 5})
    elseif (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and not card.ability.is_club == true and not card.ability.is_spade == true then -- Diamonds & Hearts
        card.children.front:set_sprite_pos({x = position, y = 1})
    elseif (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and (card.base.suit == 'Clubs' or card.ability.is_club == true ) and not card.ability.is_heart == true and not card.ability.is_spade == true then -- Diamonds & Clubs
        card.children.front:set_sprite_pos({x = position, y = 3})
    elseif (card.base.suit == 'Clubs' or card.ability.is_club == true ) and (card.base.suit == 'Hearts' or card.ability.is_heart == true ) and (card.base.suit == 'Diamonds' or card.ability.is_diamond == true ) and (card.base.suit == 'Spades' or card.ability.is_spade == true ) then -- Clubs, Diamonds, Spades, & Hearts
        card.children.front:set_sprite_pos({x = position, y = 10})
    end
    if juice == true then
        card:juice_up(0.3, 0.5)
    end
end

local card_drawref = Card.draw
function Card:draw(layer)
    local card_drawref = card_drawref(self, layer)
    if self.ability.set == 'Familiar_Spectrals' then
        self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
    end
    return card_drawref
end

----------------------------------------------
------------MOD CODE END---------------------
