#!/bin/bash

# Nom du dossier racine du datapack
DATAPACK_DIR="CustomRaidBoss"
BOSS_DIR="$DATAPACK_DIR/data/cobblemonraiddens/raid/boss"

# Création de l'arborescence
mkdir -p "$BOSS_DIR"

# Fichier pack.mcmeta requis pour que Minecraft reconnaisse le datapack
cat <<EOF > "$DATAPACK_DIR/pack.mcmeta"
{
  "pack": {
    "pack_format": 15,
    "description": "Custom Raid Bosses pour Cobblemon"
  }
}
EOF

# Liste des boss au format "SuffixeFichier:espece_pokemon"
BOSSES=(
    "RaichuX:raichu"
    "RaichuY:raichu"
    "Clefable:clefable"
    "Victreebel:victreebel"
    "Starmie:starmie"
    "Dragonite:dragonite"
    "Meganium:meganium"
    "Feraligatr:feraligatr"
    "Skarmory:skarmory"
    "Chimecho:chimecho"
    "AbsolZ:absol"
    "Staraptor:staraptor"
    "GarchompZ:garchomp"
    "LucarioZ:lucario"
    "Froslass:froslass"
    "Emboar:emboar"
    "Excadrill:excadrill"
    "Scolipede:scolipede"
    "Scrafty:scrafty"
    "Eleektross:eelektross"
    "Chandelure:chandelure"
    "Golurk:golurk"
    "Chesnaught:chesnaught"
    "Delphox:delphox"
    "Greninja:greninja"
    "Pyroar:pyroar"
    "Meowstic:meowstic"
    "Malamar:malamar"
    "Barbaracle:barbaracle"
    "Dragalge:dragalge"
    "Hawlucha:hawlucha"
    "Crabominable:crabominable"
    "Golisopod:golisopod"
    "Drampa:drampa"
    "Falinks:falinks"
    "Scovillain:scovillain"
    "Glimmora:glimmora"
    "Tatsugiri:tatsugiri"
    "Baxcalibur:baxcalibur"
)

# Génération des fichiers JSON
for BOSS in "${BOSSES[@]}"; do
    FILE_SUFFIX="${BOSS%%:*}"
    SPECIES="${BOSS##*:}"
    FILE_PATH="$BOSS_DIR/6_ferox-${FILE_SUFFIX}.json"

    cat <<EOF > "$FILE_PATH"
{
    "pokemon": {
        "species": "${SPECIES}",
        "gender": "MALE",
        "ability": "drought",
        "nature": "modest",
        "level": 85,
        "moves": [
            "flareblitz",
            "slash",
            "dragonclaw",
            "airslash"
        ]
    },
    "boss": {
        "min_perfect_ivs": 6,
        "level": 100,
        "evs": {
            "atk": 252,
            "spe": 252,
            "spd": 4
        },
        "held_item": "cobblemon:life_orb",
        "aspects": [],
        "form": "",
        "custom_properties": [
            {
                "name": "mega_evolution",
                "value": "mega_y"
            }
        ]
    },
    "raid_tier": "TIER_SIX",
    "raid_type": "ROCK",
    "raid_feature": "MEGA",
    "loot_table": "modid:${SPECIES}",
    "weight": 20.0,
    "den": [
        "cobblemonraiddens:raid_den/basic",
        "#cobblemonraiddens:default"
    ],
    "boss_bar_text": {
        "translate": "cobblemon.species.${SPECIES}.name",
        "type": "translatable"
    },
    "max_players": 8,
    "max_clears": 3,
    "ha_rate": 0.2,
    "max_cheers": 3,
    "raid_party_size": 1,
    "health_multi": 0,
    "multiplayer_health_multi": 1.0,
    "shiny_rate": -1,
    "currency": 100000,
    "max_catches": -1,
    "script": {
        "turn:3": "RESET_BOSS"
    },
    "raid_ai": "RCT",
    "marks": [
        "cobblemon:mark_mightiest"
    ],
    "lives": 1,
    "energy": 25
}
EOF

    echo "Généré : $FILE_PATH"
done

echo "Génération terminée. Dossier créé : $DATAPACK_DIR"
