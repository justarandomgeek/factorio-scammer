
local scammerent = table.deepcopy(data.raw["radar"]["radar"])
scammerent.name="scammer"
scammerent.minable.result = "scammer"
scammerent.fast_replaceable_group = nil
data:extend{scammerent}

local scammerctrl = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
scammerctrl.name="scammer-control"
scammerctrl.minable= nil
scammerctrl.order="z[lol]-[scammerctrl]"
scammerctrl.item_slot_count = 500
data:extend{scammerctrl}
