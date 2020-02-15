def _impl(rctx):
    # todo: yes, this is a hack since rctx.path(Label-in-main-repo) does not work

    dir_path = "../" + rctx.attr.file.workspace_name + "/" + rctx.attr.path
    entries = rctx.path(dir_path).readdir()
    dirs = []
    for entry in entries:
        rctx.symlink(entry, entry.basename)
        dirs.append(entry.basename)
    exclude_str = ""
    if len(rctx.attr.exclude) > 0:
        exclude_str = ", [" + ", ".join(rctx.attr.exclude) + "]"
    text = """
filegroup(
 name = 'srcs',
 visibility = ["//visibility:public"],
 srcs = glob(["**/**" %s ]))
           """ % exclude_str
    print(text)
    rctx.file("BUILD", text)
    rctx.file(".bazelignore", "\n".join(dirs))

import_directory = repository_rule(
    implementation = _impl,
    doc = "",
    attrs = {
        "file": attr.label(allow_single_file = True),
        "path": attr.string(doc = ""),
        "exclude": attr.string_list(mandatory = False),
        "bazelignore": attr.string(mandatory = False, doc = ""),
    },
)
