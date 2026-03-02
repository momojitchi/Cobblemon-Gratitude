#!/bin/bash

# Liste de tous les types, y compris le normal
TYPES=("normal" "fire" "water" "grass" "electric" "ice" "fighting" "poison" "ground" "flying" "psychic" "bug" "rock" "ghost" "dragon" "dark" "steel" "fairy")

# Chemins de destination
BOSS_DIR="data/cobblemonraiddens/raid/boss"
LOOT_DIR="data/cobblemonraiddens/loot_table/raid/boss"

# Création des répertoires
mkdir -p "$BOSS_DIR"
mkdir -p "$LOOT_DIR"

for TYPE in "${TYPES[@]}"; do
    # Convertir le type en majuscules pour "raid_type"
    TYPE_UPPER=$(echo "$TYPE" | tr '[:lower:]' '[:upper:]')

    # 1. Génération du fichier boss
    BOSS_FILE="$BOSS_DIR/3_gymkey-Klefki-${TYPE}.json"
    cat <<EOF > "$BOSS_FILE"
{
    "pokemon": {
        "species": "klefki",
        "ability": "prankster",
        "nature": "bold",
        "level": 35,
        "moves": [
            "terablast",
            "foulplay",
            "lightscreen",
            "reflect"
        ]
    },
    "boss": {
        "min_perfect_ivs": 6,
        "level": 35,
        "evs": {
            "hp": 252,
            "def": 252,
            "spd": 4
        },

        "aspects": [],
        "form": "",
        "custom_properties": []
    },
    "raid_tier": "TIER_THREE",
    "raid_type": "${TYPE_UPPER}",
    "raid_feature": "TERA",
    "loot_table": "cobblemonraiddens:raid/boss/klefki_gymkey_${TYPE}",
    "weight": 20.0,
    "den": [
        "cobblemonraiddens:raid_den/radical"
    ],
    "boss_bar_text": {
        "translate": "cobblemon.species.klefki.name",
        "type": "translatable"
    },
    "max_players": 8,
    "max_clears": 3,
    "shiny_rate": 2096,
    "currency": 5000,
    "max_catches": -1,
    "raid_ai": "STRONG",
    "marks": [
        "cobblemon:mark_personality_smiley"
    ],
    "lives": 1,
    "energy": 10
}
EOF

    # 2. Génération du fichier loot
    LOOT_FILE="$LOOT_DIR/klefki_gymkey_${TYPE}.json"
    cat <<EOF > "$LOOT_FILE"
{
    "type": "minecraft:chest",
    "pools": [
        {
            "rolls": 1,
            "entries": [
                {
                    "type": "minecraft:item",
                    "name": "cobblemon:${TYPE}_gem"
                }
            ]
        },
        {
            "rolls": 1,
            "entries": [
                {
                    "type": "minecraft:item",
                    "name": "mega_showdown:${TYPE}_tera_shard",
                    "functions": [
                        {
                            "function": "minecraft:set_count",
                            "count": 10
                        }
                    ]
                }
            ]
        },
        {
            "rolls": 1,
            "entries": [
                {
                    "type": "minecraft:item",
                    "name": "rad-gyms:gym_key",
                    "functions": [
                        {
                            "function": "minecraft:set_components",
                            "components": {
                                "rad-gyms:gym_type_component": "${TYPE}"
                            }
                        }
                    ]
                }
            ]
        }
    ]
}
EOF

    echo "Généré : $BOSS_FILE et $LOOT_FILE"
done

echo "Terminé."
