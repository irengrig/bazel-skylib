load("@skylib1//rules:select_file.bzl", "select_file")
load("@skylib1//rules:diff_test.bzl", "diff_test")

select_file(
    name = "selected",
    srcs = "@imported//:srcs",
    subpath = "inner/b.txt",
)

diff_test(
    name = "test",
    file1 = ":selected",
    file2 = "subdir/inner/b.txt",
)
