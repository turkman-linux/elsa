project(
  'elsa',
  ['vala', 'c'],
  version : '1.0'
)
# sources
sources = [
     'src/elsa.vala',
     'src/module.vala',
     'src/debug.vala',
     'src/util.vala',
     'src/config.vala',
     'src/modules/mount.vala'
]

# dependencies
deps = [
    'glib-2.0',
    'gio-2.0',
    'gobject-2.0',
]

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
    vala_gir: 'elsa-'+meson.project_version()+'.gir',
    dependencies: fdeps,    
    link_args: links,
    install: true
)

# gobject-introspection
g_ir_compiler = find_program('g-ir-compiler')
custom_target('typelib',
              command: [
                  g_ir_compiler,
                  '--shared-library', libelsa.full_path(),
                  '--output', '@OUTPUT@',
                  join_paths(meson.current_build_dir(), 'elsa-'+meson.project_version()+'.gir')
              ],
              output: 'elsa-'+meson.project_version()+'.typelib',
              depends: libelsa,
              install: true,
              install_dir: join_paths(get_option('libdir'), 'girepository-1.0'))

# command line interface
executable(
     'elsa',
     'src/cli/main.vala',
     dependencies: fdeps,    
     link_with: libelsa,
     link_args: links,
)

# gtk test stuff. remove later
links += run_command('pkg-config', '--cflags','--libs','gtk+-3.0' ,check:true).stdout().strip().split(' ')
fdeps += dependency('gtk+-3.0')
executable(
     'elsa-test',
     'src/test/gtk.vala',
     dependencies: fdeps,    
     link_with: libelsa,
     link_args: links,
)
