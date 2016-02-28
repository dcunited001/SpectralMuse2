## SpectraMuse

### Building

I had a few problems getting `libMuse.a` to build and be 
included in the bridging header with `Muse.h`.  

#### Bitcode

One issue is that
the libMuse.a is not built with bitcode, so that makes it difficult to
include other libs.  I'm pulling down a few libs with carthage and I've 

#### OSX

I tried getting the lib running with OSX, but it has ``