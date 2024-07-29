-- Fonction pour générer le coffre avec des items aléatoires
function airdrop.spawn_airdrop(pos)
   -- Création du coffre
    minetest.set_node({x = pos.x, y = pos.y, z = pos.z}, {name = "mcl_chests:chest"})

    -- Ajout des items au coffre
    local chest_meta = minetest.get_meta({x = pos.x, y = pos.y, z = pos.z})
    local inv = chest_meta:get_inventory()
    local items = get_random_items()

    local slots_filled = {}
    for _, item in ipairs(items) do
        local slot
        repeat
            slot = math.random(0, inv:get_size("main") - 1)
        until not slots_filled[slot]
        slots_filled[slot] = true
        inv:set_stack("main", slot + 1, item.name .. " " .. item.count)
    end
end

-- Commande /airdrop
minetest.register_chatcommand("airdrop", {
    description = "Spawns an airdrop structure with a chest at a random location near (1000, 0, 1000) with items based on their rarity",
    privs = {server=true},
    func = function(name)
        -- Génère une position aléatoire proche de (1000, 0, 1000)
        local pos = {
            x = math.random(-5000, 5000),
            y = math.random(50, 200),
            z = math.random(-5000, 5000)
        }
        while (pos.x > -500 and pos.x < 500) do
                pos.x = math.random(-5000, 5000)
        end
        while (pos.z > -500 and pos.z < 500) do
                pos.z = math.random(-5000, 5000)
        end

        -- Appelle la fonction pour générer l'airdrop
        airdrop.spawn_airdrop(pos)

        -- Informe le joueur
        local message = "-!- AirDrop -!- x: " .. pos.x .. " y: " .. pos.y .. " z: " .. pos.z
        minetest.chat_send_player(name, message)

        return true
    end,
})

-- Enregistre le mod
minetest.log("action", "[Airdrop] Mod loaded.")
