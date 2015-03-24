# Flags #
![http://www.hedgewars.org/images/flags.png](http://www.hedgewars.org/images/flags.png)
## Explanation of flags ##
Flags are little rectangular images shown in the team bar as a team’s symbol.

## Creating flags ##
To create a flag, draw a PNG image of size 22×15 pixels.

To install a flag, put it into `Data/Graphics/Flags` of the Hedgewars data directory.

The file name must have “.png” at the end, the file suffix will not be shown in Hedgewars. Depending on the name, the flag will be displayed in different ways in Hedgewars:

  * Default flag: The flag “`hedgewars.png`” (shows a hedgehog), flag of new teams.
  * Computer flag: The flag “`cpu.png`”. It is shown for computer-controlled teams in place of the selected flag in the team editor, together with an overlay of 1 to 5 bars designating the strength of the team. This flag is not shown in the team editor.
  * The flag “`cpu_plain.png`”. It is currently unused by Hedgewars and is not shown in the team editor.
  * Community flags: The flags whose file name starts with “`cm_`” are listed as “community flags” in Hedgewars (the prefix is removed)
  * National flags: All other flags

Please note that the flags “`hedgewars.png`”, “`cpu.png`”, “`cpu_plain.png`”, a couple of community flags and national flags come pre-installed with Hedgewars. If you use a flag of an identical name in your Hedgewars user data directory, Hedgewars will show that one instead of the system-wide installed flag. That way, you can customize the default flag, for example.

## Limits ##
Please note that flags are _not_ automatically shared when you play online. Unless the other players have your flag, too, they will only see the default flag for your team instead. The only flags you can be sure are also seen online are the ones supplied by the Hedgewars installation.

If you have changed or overwritten any of the pre-installed flags, this change is also only visible on your Hedgewars installation. The change won’t be visible for other players over the net.