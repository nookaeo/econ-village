# Econ Village

A small Godot-based economic simulation that models a village of agents, buildings, resources and time. Designed to be opened and run in the Godot editor for exploration, experimentation, and educational demonstrations of emergent economic behavior.

<img width="1240" height="695" alt="Screenshot_20260812_073150" src="https://github.com/user-attachments/assets/54d22d8c-846a-49ac-b2a0-444ad1a6ee9b" />


<img width="1267" height="707" alt="Screenshot_20260812_070247" src="https://github.com/user-attachments/assets/09824748-0802-4721-95e8-96d2c1785cc8" />


## Features
- Tile-based world with resource nodes and buildings
- Agent-based simulation (villagers) with basic decision/brain logic
- Time manager and configurable simulation speed
- Spawners and managers for resources, buildings, and agents
- Integrated easy_charts addon for visualization

## Requirements
- Godot Engine 4.x (project lists 4.x in `project.godot`)
- No other external runtimes. The included `addons/easy_charts` provides charting features.

## Quick start (open and run)
1. Clone the repo:
   git clone https://github.com/nookaeo/econ-village.git
   cd econ-village

2. Open the project in Godot (recommended):
   - Start Godot, choose "Open", and select the repo folder (or open `project.godot`).
   - Ensure the plugin `addons/easy_charts` is enabled in Project -> Project Settings -> Plugins if you want charts.

3. Run the main scene:
   - The project’s main scene is set in `project.godot` (autostart); when you press Play in the editor the simulation should start (the primary scene is `scenes/core/world.tscn`).
   - Alternatively, run from CLI (adjust for your godot binary):
     godot --path .           # run the project
     godot -e --path .        # open the editor for the project

Notes:
- Exports: Use Godot's Export system to build executables for platforms; no export presets are provided in the repo.
- If the game window is borderless by default (see `project.godot`), change display settings in Project -> Project Settings -> Display if needed.

## Project structure (high level)
- project.godot              — Godot project file (main scene, autoloads, editor settings)
- scenes/
  - core/                    — runtime managers and main world scene (world.tscn, time_manager.tscn, tiles_data_manager.tscn, resources_spawner.tscn)
  - entities/                — agent, building and resource scenes (agents, brain, buildings, natural_resources)
  - ui/                      — UI scenes
- addons/easy_charts/        — included charting plugin
- assets/                    — art, audio, fonts, themes
- scripts/                   — (project scripts, if present)
- resources/                 — additional resource files
- LICENSE                    — project license

## Where to change common settings
- Simulation time & pacing: scenes/core/time_manager.tscn (and its attached script).
- Tile and resource data: scenes/core/tiles_data_manager.tscn and scenes/core/tile_map_base.tscn.
- Spawn rates & agent spawn points: scenes/core/resources_spawner.tscn and scenes/core/agent_spawn_handler.tscn.
- Global singletons / constants: check autoloads defined in `project.godot` (e.g., CoreConstant, ItemData, TilesManager, NatResourceManager).

## Development & debugging tips
- Open `scenes/core/world.tscn` to inspect the main composition of managers and spawners.
- Use the built-in Godot debugger and remote inspector to watch nodes and signals during runtime.
- Enable the `easy_charts` plugin via Project Settings -> Plugins to visualize statistics in-editor or at runtime (if scenes expose chart hooks).

## Contributing
1. Fork -> create a feature branch -> open a PR.
2. Keep changes small and focused (e.g., a single behavior tweak or a new resource type per PR).
3. If adding editor plugins or large assets, document usage and any authoring tools in this README or a new docs/ file.

## Roadmap / ideas
- Expand agent decision trees and introduce needs/preferences
- Add persistence (save/load world state)
- Parameterize more settings for experiments (CSV or JSON config)
- More visualization dashboards via easy_charts

