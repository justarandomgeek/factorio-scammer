local function ReadPosition(signet,secondary,offset)
  if not offset then offset=0.5 end
  if not secondary then
    return {
      x = signet.get_signal({name="signal-X",type="virtual"})+offset,
      y = signet.get_signal({name="signal-Y",type="virtual"})+offset
    }
  else
    return {
      x = signet.get_signal({name="signal-U",type="virtual"})+offset,
      y = signet.get_signal({name="signal-V",type="virtual"})+offset
    }
  end
end

local function ReadBoundingBox(signet)
  -- adjust offests to make *inclusive* selection
  return {ReadPosition(signet,false,0),ReadPosition(signet,true,1)}
end

local function SignalEntities(ents)
  local signals = {}
  local items = {}
  for _,ent in pairs(ents) do
    local entproto = ent.prototype
    --TODO check ent.ghost_prototype when needed

    if ent.minable and entproto.mineable_properties.products then
      for _,product in pairs(entproto.mineable_properties.products) do
        if product.type == "item" then
          local amount = product.amount or product.amount_min --TODO: handle variable mining better
          items[product.name] = (items[product.name] or 0) + amount
        end
      end
    end
  end
  for item,count in pairs(items) do
    signals[#signals+1]={index=#signals+1,count=count,signal={name=item,type="item"}}
  end
  return signals
end

local function ScanPosition(surface,position)
  ents = surface.find_entities_filtered{position=position}
  return SignalEntities(ents)
end

local function ScanArea(surface,area)
  if area[1].x == area[2].x and area[1].y==area[2].y then
    return nil
  end

  ents = surface.find_entities_filtered{area=area}
  return SignalEntities(ents)
end


local function onTickManager(manager)
  -- read cc1 signals. Only uses one wire, red if both connected.
  local signet1 = manager.cc1.get_circuit_network(defines.wire_type.red) or manager.cc1.get_circuit_network(defines.wire_type.green)
  if signet1 and #signet1.signals > 0 then
    if signet1.get_signal({name="signal-P",type="virtual"})==1 then
      manager.cc2.get_or_create_control_behavior().parameters={parameters=ScanPosition(manager.ent.surface,ReadPosition(signet1))}
      return
    elseif signet1.get_signal({name="signal-A",type="virtual"})==1 then
      manager.cc2.get_or_create_control_behavior().parameters={parameters=ScanArea(manager.ent.surface,ReadBoundingBox(signet1))}
      return
    end
  end

  manager.cc2.get_or_create_control_behavior().parameters=nil
end


local function onTick()
  if global.managers then
    for _,manager in pairs(global.managers) do
      if not (manager.ent.valid and manager.cc1.valid and manager.cc2.valid) then
        -- if anything is invalid, tear it all down
        if manager.ent.valid then manager.ent.destroy() end
        if manager.cc1.valid then manager.cc1.destroy() end
        if manager.cc2.valid then manager.cc2.destroy() end
        global.managers[_] = nil
      else
        onTickManager(manager)
      end
    end
  end
end

local function CreateControl(manager,position)
  local ent = manager.surface.create_entity{
      name='scammer-control',
      position = position,
      force = manager.force
    }

  ent.operable=false
  ent.minable=false
  ent.destructible=false

  return ent
end

local function onBuilt(event)
  local ent = event.created_entity
  if ent.name == "scammer" then

    local cc1 = CreateControl(ent, {x=ent.position.x-1,y=ent.position.y+1})
    local cc2 = CreateControl(ent, {x=ent.position.x+1,y=ent.position.y+1})

    if not global.managers then global.managers = {} end
    global.managers[ent.unit_number]={ent=ent, cc1 = cc1, cc2 = cc2}

  end
end

script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_built_entity, onBuilt)
script.on_event(defines.events.on_robot_built_entity, onBuilt)

remote.add_interface('scammer',{
  --TODO: call to register signals for ghost proxies??
})
