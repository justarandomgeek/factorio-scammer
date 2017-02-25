data:extend{
  {
    type = "item",
    name = "scammer",
    icon = "__base__/graphics/icons/roboport.png",
    flags = {"goes-to-quickbar"},
    subgroup = "logistic-network",
    order = "c[signal]-b[scammer]",
    place_result="scammer",
    stack_size = 50,
  },
  {
    type = "item",
    name = "scammer-control",
    icon = "__base__/graphics/icons/roboport.png",
    flags = {"goes-to-quickbar", "hidden"},
    subgroup = "logistic-network",
    order = "c[signal]-b[scammer-control]",
    place_result="scammer-control",
    stack_size = 50,
  },
  }
