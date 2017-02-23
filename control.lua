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


local function onTickManager(manager)
  -- read cc1 signals. Only uses one wire, red if both connected.
  local signet1 = manager.cc1.get_circuit_network(defines.wire_type.red) or manager.cc1.get_circuit_network(defines.wire_type.green)
  if signet1 and #signet1.signals > 0 then
    local signet2 = manager.cc2.get_circuit_network(defines.wire_type.red) or manager.cc2.get_circuit_network(defines.wire_type.green)


  end
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
