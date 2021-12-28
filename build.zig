const std = @import("std");
const zlib = @import("zlib.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const lib = zlib.create(b, target, mode);
    lib.install();

    const tests = b.addTest("src/main.zig");
    tests.addIncludeDir(zlib.include_dir);
    tests.linkLibrary(lib);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests.step);
}
