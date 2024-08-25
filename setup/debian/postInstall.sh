#!/usr/bin/env bash

apt-get -y --ignore-missing install $(< install.list)

apt-get -y --ignore-missing install $(< packages.list)