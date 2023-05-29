project(
  'elsa',
  ['vala', 'c'],
  version : '1.0'
)
# sources
sources = [
     'src/elsa.vala',
     'src/module.vala',
     'src/config.vala',
]

# dependencies
deps = [
    'glib-2.0',
    'gobject-2.0',
]

# calculate links
links = []
fdeps = []
foreach dep : deps
    links += [
         run_command('pkg-config', '--cflags','--libs',dep ,check:true).stdout().strip().split(' '),
    ]
    fdeps += dependency(dep)
endforeach

# library
libelsa = library(
    meson.project_name(),
    sources,
    vala_gir: 'elsa-'+meson.project_version()+'.gir',
    dependencies: fdeps,    
    link_args: links,
    install: true
)

run_command('pkg-config', '--cflags','--libs','gtk+-3.0' ,check:true).stdout().strip().split(' ')
fdeps += dependency('gtk+-3.0')
executable(
     'elsa',
     'src/cli/main.vala',
     dependencies: fdeps,    
     link_with: libelsa,
     link_args: links,
)