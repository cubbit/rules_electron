"""Electron rules
"""

load("@build_bazel_rules_nodejs//:providers.bzl", "NpmPackageInfo")

DARWIN = "darwin"
WIN32 = "win32"
LINUX = "linux"

def _electron_binary_impl(context):
    """Electron binary implementation
    """

    platform = LINUX
    electron = None

    for source in context.attr.electron[NpmPackageInfo].sources.to_list():
        if "Electron.app/Contents/MacOS/Electron" in source.path:
            platform = DARWIN
            electron = source

            break
        if "Electron.exe" in source.path:
            platform = WIN32
            electron = source
            break

        # TODO: add linux detection

    runfiles = context.attr.electron[NpmPackageInfo].sources.to_list() + context.attr.entry_point.files.to_list()

    args = context.attr.entry_point.files.to_list()[0].path
    command = "{} {}".format(electron.path, args)

    context.actions.write(
        output = context.outputs.executable,
        content = command,
        is_executable = True,
    )

    return [DefaultInfo(
        runfiles = context.runfiles(files = runfiles),
    )]

electron_binary = rule(
    implementation = _electron_binary_impl,
    executable = True,
    attrs = {
        "entry_point": attr.label(
            mandatory = True,
            allow_single_file = [".js"],
            cfg = "target",
        ),
        "data": attr.label_list(
            allow_files = True,
            cfg = "target",
        ),
        "electron": attr.label(
            cfg = "host",
        ),
    },
)
