import PackageDescription

let package = Package(
    name: "MainecoonVapor",
    targets: [
        Target(name: "MainecoonVaporExample", dependencies: ["MainecoonVapor"]),
        Target(name: "MainecoonVapor"),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/OpenKitten/Mainecoon.git", "1.0.0-alpha"),
    ]
)
