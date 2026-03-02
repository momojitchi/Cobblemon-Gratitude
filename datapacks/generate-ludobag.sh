#!/bin/bash

# Configuration
DP_NAME="ludobags_datapack"
NAMESPACE="ludobag"

# --- CHOIX DU VISUEL ---
# Option 1 (Sûre) : Slime Ball (Pas de bug de clic droit)
VISUAL_ITEM="minecraft:slime_ball"
# Option 2 (Risquée) : Item du mod (Peut bloquer l'ouverture si l'item a déjà un menu)
# VISUAL_ITEM="cobbleloots:loot_ball"

# Nettoyage
rm -rf "$DP_NAME"
mkdir -p "$DP_NAME/data/$NAMESPACE/advancement"
mkdir -p "$DP_NAME/data/$NAMESPACE/function"
mkdir -p "$DP_NAME/data/$NAMESPACE/loot_table"

# pack.mcmeta
cat <<EOF > "$DP_NAME/pack.mcmeta"
{
  "pack": {
    "pack_format": 48,
    "description": "Ludobags v5 - Syntax Fix & Full Loot"
  }
}
EOF

# --- 1. LE WELCOME BAG (Ta liste exacte) ---
create_welcome_bag() {
    local ID="welcome"
    local NAME="Welcome Bag"
    local COLOR="blue"
    local MODEL_ID="10"

    echo "Génération du Welcome Bag..."

    # Loot Table : Un 'entry' par pool pour tout donner d'un coup
    cat <<EOF > "$DP_NAME/data/$NAMESPACE/loot_table/$ID.json"
{
  "pools": [
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "cobblemon:poke_ball", "functions": [ { "function": "minecraft:set_count", "count": 15 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "knowlogy:knowlogy_book", "functions": [ { "function": "minecraft:set_count", "count": 1 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "academy:booster_pack", "functions": [ { "function": "minecraft:set_count", "count": 1 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "academy:card_album", "functions": [ { "function": "minecraft:set_count", "count": 1 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "cobblemon:pokedex_pink", "functions": [ { "function": "minecraft:set_count", "count": 5 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "minecraft:emerald", "functions": [ { "function": "minecraft:set_count", "count": 5 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "fwaystones:waystone", "functions": [ { "function": "minecraft:set_count", "count": 1 } ] } ] },
    { "rolls": 1, "entries": [ { "type": "minecraft:item", "name": "sophisticatedbackpacks:backpack", "functions": [ { "function": "minecraft:set_count", "count": 1 } ] } ] }
  ]
}
EOF
    generate_logic "$ID" "$NAME" "$COLOR" "$MODEL_ID"
}

# --- 2. LES SACS GACHA (Aléatoire) ---
create_gacha_bag() {
    local ID=$1
    local NAME=$2
    local ITEM1=$3
    local ITEM2=$4
    local COLOR=$5
    local MODEL_ID=$6

    echo "Génération Gacha : $NAME..."

    cat <<EOF > "$DP_NAME/data/$NAMESPACE/loot_table/$ID.json"
{
  "pools": [
    {
      "rolls": 1,
      "entries": [
        { "type": "minecraft:item", "name": "$ITEM1", "weight": 50 },
        { "type": "minecraft:item", "name": "$ITEM2", "weight": 50 }
      ]
    }
  ]
}
EOF
    generate_logic "$ID" "$NAME" "$COLOR" "$MODEL_ID"
}

# --- LOGIQUE COMMUNE (Le Fix est ici) ---
generate_logic() {
    local ID=$1
    local NAME=$2
    local COLOR=$3
    local MODEL_ID=$4

    # Advancement : Note l'absence de guillemets autour de la clé ludobag_id
    cat <<EOF > "$DP_NAME/data/$NAMESPACE/advancement/open_$ID.json"
{
  "criteria": {
    "requirement": {
      "trigger": "minecraft:consume_item",
      "conditions": {
        "item": {
          "predicates": {
            "minecraft:custom_data": "{ludobag_id:\"$ID\"}"
          }
        }
      }
    }
  },
  "rewards": { "function": "$NAMESPACE:reward_$ID" }
}
EOF

    # Function
    cat <<EOF > "$DP_NAME/data/$NAMESPACE/function/reward_$ID.mcfunction"
loot give @s loot $NAMESPACE:$ID
playsound minecraft:entity.experience_orb.pickup master @s ~ ~ ~ 1 1
particle minecraft:poof ~ ~1 ~ 0.5 0.5 0.5 0.1 10
advancement revoke @s only $NAMESPACE:open_$ID
EOF

    # Commande Give : FIX MAJEUR ICI
    # custom_data={ludobag_id:"value"} -> Clé sans guillemets, valeur avec guillemets.
    echo "" >> "$DP_NAME/COMMANDES.txt"
    echo "=== $NAME ===" >> "$DP_NAME/COMMANDES.txt"
    echo "/give @p $VISUAL_ITEM[item_name='{\"text\":\"$NAME\",\"color\":\"$COLOR\",\"italic\":false}',custom_model_data=$MODEL_ID,max_stack_size=1,enchantment_glint_override=true,food={nutrition:0,saturation:0,can_always_eat:true,eat_seconds:1.5},custom_data={ludobag_id:\"$ID\"}]" >> "$DP_NAME/COMMANDES.txt"
}

echo "COMMANDES LUDOBAGS (Fix Syntax v5)" > "$DP_NAME/COMMANDES.txt"

# --- GÉNÉRATION ---

create_welcome_bag

# Gachas (Tu peux changer les ID 1,2,3,4 par ce que tu veux pour le Resource Pack)
create_gacha_bag "mega" "Ludobag Mega" "minecraft:diamond" "minecraft:netherite_ingot" "light_purple" 1
create_gacha_bag "gym" "Ludobag Gym" "minecraft:golden_apple" "minecraft:potion" "red" 2
create_gacha_bag "legend" "Ludobag Legend" "minecraft:nether_star" "minecraft:dragon_breath" "gold" 3
create_gacha_bag "evolution" "Ludobag Evolution" "minecraft:magma_cream" "minecraft:echo_shard" "green" 4
create_gacha_bag "template" "Ludobag Template" "minecraft:dirt" "minecraft:stone" "gray" 99

echo "Terminé. Dossier : $DP_NAME"
