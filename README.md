# osrs-items

Command-line utility for Old School RuneScape item ID lookups. Automatically syncs with the [RuneLite](https://github.com/runelite/runelite) item database.

## Features
- Bidirectional lookup: search by ID or item name
- Auto-updates with RuneLite's item database
- Zero configuration required

## Installation

### From Source
```bash
git clone https://github.com/jackinthebox52/osrs-items.git
cd osrs-items
makepkg -si
```
This will update the item database, build the arch package, and install it to your system.

### Arch Linux (AUR)
```bash
yay -S osrs-items (not yet available)
```

### From Source
```bash
git clone https://github.com/jackinthebox52/osrs-items.git
cd osrs-items
makepkg -si
```

## Usage
```bash
# Lookup by ID
osrs-items 4151  # Returns: Item 4151: ABYSSAL_WHIP

# Lookup by name
osrs-items ABYSSAL_WHIP  # Returns: Item 'ABYSSAL_WHIP' has ID: 4151
```

## Development
```bash
# Update item database
./script/update.sh

# Force update database
./script/download-items.sh --force
```

## License
BDS 2-Clause License

## Credits
- Item data sourced from [RuneLite](https://github.com/runelite/runelite)