
local mesecons_rules = mesecon.rules.flat

function carts:turnoff_detector_rail(pos)

	local node = minetest.get_node(pos)

	if minetest.get_item_group(node.name, "detector_rail") == 1 then

		if node.name == "carts:detectorrail_on" then --has not been dug
			minetest.swap_node(pos, {name = "carts:detectorrail", param2 = node.param2})
		end

		mesecon.receptor_off(pos, mesecons_rules)
	end
end

function carts:signal_detector_rail(pos)

	local node = minetest.get_node(pos)

	if minetest.get_item_group(node.name, "detector_rail") ~= 1 then
		return
	end

	--minetest.log("action", "Signaling detector at " .. minetest.pos_to_string(pos))
	if node.name == "carts:detectorrail" then
		minetest.swap_node(pos, {name = "carts:detectorrail_on", param2 = node.param2})
	end

	mesecon.receptor_on(pos, mesecons_rules)

	minetest.after(0.5, carts.turnoff_detector_rail, carts, pos)
end

minetest.register_node("carts:detectorrail", {
	description = "Detector Rail",
	drawtype = "raillike",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	tiles = {
		"carts_rail_dtc.png", "carts_rail_curved_dtc.png",
		"carts_rail_t_junction_dtc.png", "carts_rail_crossing_dtc.png"
	},
	wield_image = "carts_rail_dtc.png",
	inventory_image = "carts_rail_dtc.png",
	groups = {
		dig_immediate = 2, attached_node = 1, rail = 1, connect_to_raillike = 1,
		detector_rail = 1
	},
	mesecons = {
		receptor = {
			state = "off", rules = mesecons_rules
		}
	},
})

minetest.register_alias("boost_cart:detectorrail", "carts:detectorrail")

--[[
boost_cart:register_rail("boost_cart:detectorrail", {
	description = "Detector rail",
	tiles = {
		"carts_rail_dtc.png", "carts_rail_curved_dtc.png",
		"carts_rail_t_junction_dtc.png", "carts_rail_crossing_dtc.png"
	},
	groups = {
		dig_immediate = 2, attached_node = 1, rail = 1, connect_to_raillike = 1,
		detector_rail = 1,  mesecon_effector_off = 1
	},
	mesecons = {effector = {
		action_on = function (pos, node)
			minetest.swap_node(pos, {name = "boost_cart:detectorrail_on", param2 = node.param2})
		end
	}},
},{})
]]

minetest.register_node("carts:detectorrail_on", {
	description = "Detector Rail ON (you hacker you)",
	drawtype = "raillike",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	tiles = {
		"carts_rail_dtc_on.png", "carts_rail_curved_dtc_on.png",
		"carts_rail_t_junction_dtc_on.png", "carts_rail_crossing_dtc_on.png"
	},
	wield_image = "carts_rail_dtc_on.png",
	inventory_image = "carts_rail_dtc_on.png",
	groups = {
		dig_immediate = 2, attached_node = 1, rail = 1, connect_to_raillike = 1,
		detector_rail = 1, not_in_creative_inventory = 1
	},
	drop = "carts:detectorrail",
	mesecons = {
		receptor = {
			state = "on", rules = mesecons_rules
		}
	},
})
carts.railparams["carts:detectorrail_on"] = {acceleration = 0} -- 0 was 0.5

minetest.register_alias("boost_cart:detectorrail_on", "carts:detectorrail_on")

--[[
boost_cart:register_rail("boost_cart:detectorrail_on", {
	description = "Detector rail ON (you hacker you)",
	tiles = {
		"carts_rail_dtc_on.png", "carts_rail_curved_dtc_on.png",
		"carts_rail_t_junction_dtc_on.png", "carts_rail_crossing_dtc_on.png"
	},
	groups = {
		dig_immediate = 2, attached_node = 1, rail = 1, connect_to_raillike = 1,
		detector_rail = 1, not_in_creative_inventory = 1, mesecon_effector_on = 1
	},
	drop = "boost_cart:detectorrail",
	mesecons = {effector = {
		action_off = function (pos, node)
			minetest.swap_node(pos, {name = "boost_cart:detectorrail", param2 = node.param2})
		end
	}},
}, {acceleration = 0.5})
]]
minetest.register_craft({
	output = "boost_cart:detectorrail 6",
	recipe = {
		{"default:steel_ingot", "mesecons:wire_00000000_off", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "mesecons:wire_00000000_off", "default:steel_ingot"},
	},
})
