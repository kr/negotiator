# New Owner

### This project now lives at <https://github.com/daneharrigan/negotiator>.

# Negotiator

This library does HTTP content negotiation.

This particular library intends to follow the HTTP
specification closely.

You give it an Accept header and a list of content types,
and it'll pick one. In case of a tie, it'll choose the one
that comes first in the provided Hash (as long as you're
using ruby >= 1.9). If none match, it'll return nil.

A missing (nil) header is treated the same as `*/*`, as
required by HTTP.

## Examples

    > header = "text/xml, application/json, text/plain; q=0.8, */*; q=0.5"
    > available = {"text/plain" => 1.0, "application/json" => 1.0, "text/xml" => 1.0}
    > Negotiator.pick(header, available)
    "application/json"

    > header = "audio/*; q=0.5, audio/mp3; q=1.0"
    > available = {"audio/flac" => 1.0, "audio/ogg" => 0.8, "audio/mp3" => 0.7}
    > Negotiator.pick(header, available)
    "audio/mp3"

## Advice

If `Negotiator.pick` returns `nil`, you should send the
HTTP 406 (not acceptable) response.

## Running Tests

    $ turn test

## The End

Bug reports and pull requests are most welcome!

Thank you!

Have fun!
