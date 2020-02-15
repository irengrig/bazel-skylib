def _impl(rctx):
    # todo: yes, this is a hack since rctx.path(Label-in-main-repo) does not work
    dir_path = "../" + rctx.attr.main_workspace + "/" + rctx.attr.path
    entries = rctx.path(dir_path).readdir()
    dirs = []
    for entry in entries:
        rctx.symlink(entry, entry.basename)
        dirs.append(entry.basename)
    rctx.file("BUILD", """
filegroup(
  name = 'srcs',
  visibility = ["//visibility:public"],
  srcs = glob(["**/**"]))
""")
    rctx.file(".bazelignore", "\n".join(dirs))

import_directory = repository_rule(
    implementation = _impl,
    doc = "",
    attrs = {
        "main_workspace": attr.string(),
        "path": attr.string(doc = ""),
        "bazelignore": attr.string(mandatory = False, doc = ""),
    },
)
