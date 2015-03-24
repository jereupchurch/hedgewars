# Introduction #

I propose we create a library of scripted structures for use in the Hedgewars campaign. This would also allow users to easily create fairly complex levels much faster than is currently possible.

# Details #

Things are still very much in the "idea" phase with regards of how best to implement such a library, and what it should contain. Ideally, I think structures should have an on/off state, so that they could activated and deactivated according to player feedback. Examples of how to turn a given structure might include:

  * If the player has destroyed a power generator to which they are attached
  * If the player is in a designated "box" or "circle" area.
  * If the player pushes some special key representing an "interaction" with the structure (e.g. shift + left/right)

# Structure Ideas #

Below are some example ideas for scripted structures.

### Power Generators ###

Put simply, this structure powers other structures. It could be implemented by having an invisible gtTarget linked to a lua-based structure object. The animation of the power generator could be handled using the vgtStraightShot visual gear which allows the drawing of any sprite in Hedgewars.

Once a power generator is destroyed, whatever structures it is linked to turn off. So, for example, if a power generator is linked to a Material Emancipation Grill, the player could shoot the Power Generator in order to disable/destroy the Grill structure.

### Switch ###

In lieu of a Power Generator, a "switch" visual gear could be drawn on a point of the map. When the hog moves to within close range of a switch structure and interacts with it in someway (e.g. shift + left/right), whatever structure the switch is linked to is toggled on/off.

### Health Recharger ###

When "on" this structure would slowly restore the life of any hedgehogs nearby it.

### Teleporter ###

This structure teleports a hog who is in it's sphere of influence to another point on the map. The animation of the teleporter could be handled by the scripted structure lib and be similar to that of CTF\_Blizzard

### Flamethrower Trap ###

This could be a kind of trap / hazard on campaign maps. If the flamethrower is "on" it periodically fires a wave of flames either up/down/left/right, comparable to the flamethrower in the script Plane Wars.

### Roof Dispenser ###

If "on", the roof dispenser creates one gear (health crate, mine, target, etc) that drops down and then switches "off" until activated again.

### Force Field ###

This is the equivalent of a "locked door". When "on" prevents the player from moving in a particular direction. Could be implemented using input masks.

### Material Emancipation Grills ###

As seen in Portal. When "on" and a hog enters the effected zone, he loses all of his weapons (except the Portal Gun?). This would allow for resetting the player inventory in puzzle based parts of the campaign / scripted maps. Very useful indeedy. Could also be scripted to vaporize foreign gears like gtShells etc that are fired through it, to create protected zones.

### Reflector shields ###

These could be placed around points of interest, such as Power Generators or even enemy hogs. They would deflect any incoming projectiles, meaning the player has to physically move into the zone of the shield in order to attack the target it has been placed around.