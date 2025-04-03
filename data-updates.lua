

local tiberium_green = data.raw["item"]["tiberium-ore"]

tiberium_green.pictures = {
    layers = {
        {
            filename = "__Factorio-Tiberium__/graphics/icons/tiberium-ore.png",
            width = 64,
            height = 64,
            scale = 0.5
        },
        {
            filename = "__Factorio-Tiberium__/graphics/icons/tiberium-ore.png",
            width = 64,
            height = 64,
            scale = 0.5,
            blend_mode = "additive",
            draw_as_light = true,
            tint = { 0.3, 0.3, 0.3, 0.3 }
        },
        {
            filename = "__tiberium-glow__/graphics/glow.png",
            width = 64,
            height = 64,
            scale = 0.5,
            blend_mode = "additive",
            draw_as_glow = true,
            tint = {0.10, 0.4, 0.05, 0.4}
        }
    }
}



local tiberium_blue = data.raw["item"]["tiberium-ore-blue"]

tiberium_blue.pictures = {
    layers = {
        {
            filename = "__Factorio-Tiberium__/graphics/icons/tiberium-ore-blue-20-114-10.png",
            width = 64,
            height = 64,
            scale = 0.5,
        },
        {
            filename = "__Factorio-Tiberium__/graphics/icons/tiberium-ore-blue-20-114-10.png",
            width = 64,
            height = 64,
            scale = 0.5,
            blend_mode = "additive",
            draw_as_light = true,
            tint = { 0.3, 0.3, 0.3, 0.3 }
        },
        {
            filename = "__tiberium-glow__/graphics/glow.png",
            width = 64,
            height = 64,
            scale = 0.5,
            blend_mode = "additive",
            draw_as_glow = true,
            tint = {0.05, 0.1, 0.4, 0.4}
        }
    }
}

