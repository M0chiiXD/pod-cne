#!/usr/bin/env sh
cd "$(dirname "$0")/.."
haxe -cp commandline -D analyzer-optimize -nocffi --run Main $@