
local scammerent = table.deepcopy(data.raw["radar"]["radar"])
scammerent.name="scammer"
scammerent.minable.result = "scammer"
scammerent.fast_replaceable_group = nil
scammerent.collision_box = {{-1.2, -1.2}, {1.2, 0.8}} -- collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
data:extend{scammerent}

local scammerctrl = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
scammerctrl.name="scammer-control"
scammerctrl.minable= nil
scammerctrl.order="z[lol]-[scammerctrl]"
scammerctrl.item_slot_count = 500
scammerctrl.collision_box = {{-0.4,  0.0}, {0.4, 0.4}}
data:extend{scammerctrl}
