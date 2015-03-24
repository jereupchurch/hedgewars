## Automatic ##

Configure with `cmake -DBUILD_ENGINE_C=1` and then run `make`.

## Manual run ##

Run from the `tools` folder
```
ghc -e pas2C \"hwengine\"" pas2c.hs
```

You can replace "hwengine" with any other module.

Every pas file will be converted to a .c/.h version in the `hedgewars` folder. In case no output is produced something has gone wrong.

Use `clang` to compile, `gcc` compatibility is not yet achieved. We are curious to hear about `icc` and `msvc` (not that we expect anything...)

## Development ##
There are some special file that you need to know

  * project\_files/hwc/rtl/fpcrtl.h - contains definitions of external functions defined inside custom pascal units (eg SDLh.pas);
  * hedgewars/pas2cSystem.pas - contains definitions of external functions defined outside our own pascal units (eg png and gl units, bundled with freepascal);
  * hedgewars/pas2cRedo.pas - contains definitions of internal fpc units (provided by the 'rtl') which get a fpcrtl_prefix._

If you need to hide portions of code from pas2c just wrap it with `${IFNDEF PAS2C}...{$ENDIF}`