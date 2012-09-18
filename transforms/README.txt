Directory Location for transforms

Currently organized in sub-dirs by "type"

Considering the need to differentiate an entity versus link transform - but do not currently have
a good example of a link transform, i.e., automated logic to perform on data stored within a relationship
between two entities.  At present - lets ignore any need for a link transform ... I can always add this code later.

All transforms should return valid transform response XML - even if the transform opts not to do amny action it
can/should return a transform message noting this fact.  Makes debugging easier than having transforms
silently fail all over the place.