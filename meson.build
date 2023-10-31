project(
  'elsa',
  ['vala', 'c'],
  version : '1.0'
)
# sources
sources = run_command('find', 'src','-type','f',check:true).stdout().strip().split('\n')
# dependencies
deps = [
    'glib-2.0',
    'gio-2.0',
    'gobject-2.0',
]

run_command('bash', './tool/mkctx.sh', check:true)
sources += ['src/ctx.vala']

# debug option
if get_option('debug')
    add_global_arguments('-D','DEBUG',language: 'vala')
endif

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
    dependencies: fdeps,    
    link_args: links,
    install: true
)

# command line interface
executable(
     'elsa',
     'cli/main.vala',
     dependencies: fdeps,    
     link_with: libelsa,
     link_args: links,
)

