local function init_light(node)
    local light = rendering.draw_light {
        sprite = "utility/light_medium",
        target = node,
        surface = node.surface,
        position = node.position,
        intensity = 0
    }
    return light
end



local function update_node(node)
    if not node or not node.valid or not storage.nodes[node] then
        return
    end
    if not storage.nodes[node].light or not storage.nodes[node].light.valid or not storage.nodes[node].surface or not storage.nodes[node].surface.valid then
        storage.nodes[node] = nil
    end
    local radius = settings.global["tbg-search-radius"].value
    local max_per_tile = settings.global["tbg-max-per-tile"].value
    local max_amount = math.pi * radius * radius * max_per_tile

    local green_ores = storage.nodes[node].surface.find_entities_filtered {
        name = "tiberium-ore", position = storage.nodes[node].position, radius = radius
    }
    local blue_ores = storage.nodes[node].surface.find_entities_filtered {
        name = "tiberium-ore-blue", position = storage.nodes[node].position, radius = radius
    }
    local green_amount = 0
    local blue_amount = 0
    for _, value in ipairs(green_ores) do
        green_amount = green_amount + value.amount
    end
    for _, value in ipairs(blue_ores) do
        blue_amount = blue_amount + value.amount
    end

    local green_frac = green_amount / max_amount
    local blue_frac = blue_amount / max_amount

    storage.nodes[node].light.color = { 0, math.sqrt(math.min(1,
        green_frac + (settings.global["tbg-separate-glow"].value and 0 or blue_frac))),
        math.sqrt(math.min(1, blue_frac + (settings.global["tbg-separate-glow"].value and 0 or green_frac))), 1 }
    storage.nodes[node].light.intensity = math.max(0,
        (green_frac + blue_frac) * settings.global["tbg-intensity-mult"].value * 4)
    storage.nodes[node].light.scale = math.max(1e-5,
        (green_frac + blue_frac) * settings.global["tbg-scale-mult"].value * 12)
end



function check_new_node(node)
    if node and node.valid then
        if not storage.nodes[node] or not storage.nodes[node].light or not storage.nodes[node].light.valid then
            local light = init_light(node)
            storage.nodes[node] = { light = light, surface = node.surface, position = node.position }
            update_node(node)
        end
    end
end

--[[
function check_new_laser_node(node)
    if node and node.valid then
        if not storage.lasers[node] or not storage.lasers[node].light or not storage.lasers[node].light.valid then
            local light = rendering.draw_light{
                sprite = "utility/light_medium",
                target = node,
                surface = node.surface,
                position = node.position,
                intensity = 1,
                color = {1, 0, 0, 1}
            }
            storage.lasers[node] = { light = light, surface = node.surface, position = node.position }

        end
    end
end--]]

local function find_nodes()
    local node_names = {
        "tibGrowthNode_infinite", "tibGrowthNode"
    }


    for _, surface in pairs(game.surfaces) do
        if surface.valid then
            local nodes = surface.find_entities_filtered { name = node_names }
            for _, node in ipairs(nodes or {}) do
                check_new_node(node)
            end
        end
    end
end

--[[
local function find_laser_nodes()
    local node_names = {
        "laserfence-post", "laserfence-post-gate"
    }


    for _, surface in pairs(game.surfaces) do
        local nodes = surface.find_entities_filtered { name = node_names }
        for _, node in ipairs(nodes or {}) do
            check_new_laser_node(node)
        end
    end
end--]]


local function startup()
    storage = storage or {}
    --storage.lasers = storage.lasers or {}
    storage.nodes = storage.nodes or {}
    storage.chunk_queue = storage.chunk_queue or {}
    storage.last = storage.last or nil
    find_nodes()
    --find_laser_nodes()
end

script.on_init(startup)
script.on_configuration_changed(startup)

script.on_event(defines.events.script_raised_built, function(event)
    if event.entity and event.entity.name == "tibGrowthNode" then
        check_new_node(event.entity)
    end
end)
script.on_event(defines.events.on_chunk_generated, function(event)
    table.insert(storage.chunk_queue, { area = event.area, surface = event.surface, tick = event.tick + 60 })
end)



script.on_event(defines.events.on_tick, function(event)
    local node_names = {
        "tibGrowthNode_infinite", "tibGrowthNode"
    }

    --check new chunks for nodes
    if #storage.chunk_queue > 0 then
        local value = storage.chunk_queue[1]
        if value.tick < event.tick then
            if value.surface and value.surface.valid then
                local nodes = value.surface.find_entities_filtered { area = value.area, name = node_names }
                for _, node in ipairs(nodes or {}) do
                    check_new_node(node)
                end
            end
            table.remove(storage.chunk_queue, 1)
        end
    end

    local val = {}
    storage.last, val = next(storage.nodes, storage.last)

    update_node(storage.last)
end)
--[[
script.on_event(defines.events.on_built_entity, function (event)
    if event.entity and event.entity.valid then
        if event.entity.name == "laserfence-post" or event.entity.name == "laserfence-post-gate" then
            check_new_laser_node(event.entity)
        end
    end
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
    if event.entity and event.entity.valid then
        if event.entity.name == "laserfence-post" or event.entity.name == "laserfence-post-gate" then
            check_new_laser_node(event.entity)
        end
    end
end)--]]
