# Mini-TD
I have decided to try out a new approach to my mini projects. I will outline goals directly in this repository. With this project I will continue exploring Godot & GDScript, focusing on experimenting with my first tower defense game.

### Plan Description
Mini TD will be a project that I will divide in sections with separate main goals. Starting with section small in scope focusing mostly on just exploring common tower defense mechanics, later sections focusing on expanding it to an actual game. I may or may not complete all sections.

#### Disclaimer: Using Kenneys assets for the art: https://kenney.nl/assets

As an extra I decided to make PRs a requirement just to make sure I keep making descriptions and updating properly.

## Section one: Preparing 
#### Create a simple map
- [X] Create a grid
- [X] Populate grid with simple squared objects

#### Simple path
- [X] Grid includes a path for enemies to follow

#### Basic placing
- [X] Grid cells can be used to place a base placeable object

## Section two: Basic TD Mechanics Part 1
#### Expand path
- [X] Have test objects follow path

#### Enemy Waves
- [X] Can create and configure the enemy spawning waves
- [X] Spawn enemies as per their configuration

#### Enemy
- [X] Enemies are data driven, changing based on defined data
- [X] Enemies have health and can be killed
- [X] Enemies move along path at a defined speed

#### Enemy detection
- [X] Placeable objects can include a component that detects objects in path

#### Attack Component
- [X] Placeable objects can attack given enemy targets

#### Camera Controller
- [X] Basic movement for the camera
- [X] Can select grid cells

#### Selection
- [X] Basic WIP Selection

## Section three: Beautify Project Part 1
#### Animations
- [X] Create support for attack animations
- [X] Create basic bullet animation

#### Bullet Particles
- [X] **Optional** - Add particle effects for bullets

#### Meshes
- [X] Fixed mesh models materials
	- [X] **Update** - Replaced old meshes with different asset pack
- [X] Add path mesh to the grid

#### Cursor
- [X] Add custom cursor to game
- [X] Add basic on hover cursor update

#### Particle Component
- [X] Helps enable and disable the particle effects

## Section four: Prepare Basic Game Loop
#### Basic Economy
- [X] Add autoload for handling economy
	- [X] **TBD** - Killing enemies generates income

#### Players Health
- [X] Add players health AKA losing condition
	- [X] Player's can retry (play again)
- [ ] Add feedback for taking damage
 
#### Tower Targeting
- [X] Towers correctly select their attacking target

#### Basic Game UI
- [x] Add basic game UI
- [x] Add basic tower selection
- [ ] Add basic countdown for wave start
- [X] Add a lose overlay
