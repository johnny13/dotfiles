theme = howl.ui.theme

themes = {
  'Corrupt': bundle_file('corrupt.moon'),
}

for name,file in pairs themes
  theme.register(name, file)

unload = ->
  for name in pairs themes
    theme.unregister(name)

{
  info: {
    author: 'Maromaro',
    description: 'Additional theme for Howl',
    license: 'GPL-3.0',
  },
  :unload
}
