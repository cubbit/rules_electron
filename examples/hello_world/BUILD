load("//:index.bzl", "electron_binary")

package(default_visibility = ["//visibility:public"])

electron_binary(
    name = "hello_world",
    data = [
        ":index.html",
    ],
    electron = "@npm//electron",
    entry_point = ":main.js",
)
