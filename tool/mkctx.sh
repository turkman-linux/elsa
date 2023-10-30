#!/bin/bash
echo "public void ctx_init(){" > src/ctx.vala
find src/modules/ -type f | while read module; do
    fname=$(basename $module)
    modname=${fname/\.*/}
    echo "    module ${modname} = new module();"
    echo "    ${modname}.name = \"${modname}\";"
    echo "    ${modname}.callback.connect(${modname}_main);"
    echo "    add_module(${modname});"
done >> src/ctx.vala
echo "}" >> src/ctx.vala
