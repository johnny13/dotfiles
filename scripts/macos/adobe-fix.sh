#!/usr/local/bin/bash

launchctl unload -w {,~}/Library/LaunchAgents/com.adobe.*.plist
sudo launchctl unload -w /Library/LaunchDaemons/com.adobe.*.plist
