#!/bin/bash
if [ "$(ibus engine)" = "xkb:us::eng" ]; then
    ibus engine xkb:ru::rus
elif [ "$(ibus engine)" = "anthy" ]; then
    ibus engine xkb:us::eng
elif [ "$(ibus engine)" = "xkb:ru::rus" ]; then
    ibus engine anthy
else
    ibus engine xkb:us::eng
fi
