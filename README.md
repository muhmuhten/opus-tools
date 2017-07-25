# Opus Audio Tools

This is a modified opus-tools that breaks compatibility with anything isn't
BSD-like (bidirectional popen!), in order to support forking a helper program
to mangle the tags before encoding.

Motivation: I transcode music to opus for playing on mobile devices where
appropriate tagging is important because filesystem access is inconvenient. At
the time of this writing, neither vorbiscomment nor oggz were capable of
correctly retagging opus files, and I didn't really want to figure out how to
decode ogg, I just stuck a bit of code before oggenc writes out the comments.
It Seems to Work.

Interface: if oggenc is passed `--comment-mangler=string`, then after parsing the
input file for comments, oggenc with spawn `sh -c string`, and write to its
standard input a (32-bit) length-prefixed Vorbis comment stream. It will then
read back a length and a Vorbis comment stream of that length, ignoring any
extra output. Short reads should cause oggenc to exit with an error, but
there's no check to ensure that the comments are actually valid. This actually
probably doesn't affect playback, since the *length* of the comments is
guaranteed to be correct, and can just be skipped, but metadata-displaying
programs may react poorly.

Caveat: because pipe buffers are limited, trying to write back to oggenc before
reading all the metadata is likely to cause deadlock if there's a lot of it,
since oggenc won't read until its write completes.
