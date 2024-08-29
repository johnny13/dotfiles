#!/usr/bin/env bash

apt-get -y --ignore-missing install $(< install.list)
cp $(which batcat) /usr/local/bin/bat

apt-get -y --ignore-missing install $(< packages.list)

apt-get -y --ignore-missing install $(< dev.list)