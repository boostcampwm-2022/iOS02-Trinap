import ProjectDescription
import ProjectDescriptionHelpers

/*
 +-------------+
 |             |
 |     App     | Contains MyApp App target and MyApp unit-test target
 |             |
 +------+-------------+-------+
 |         depends on         |
 |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+
 */

// MARK: - Project Factory
protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }
    
    func generateTarget() -> [Target]
    func generateConfigurations() -> Settings
}

// MARK: - Base Project Factory
class BaseProjectFactory: ProjectFactory {
    let projectName: String = "Trinap"
    
    let dependencies: [TargetDependency] = [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxRelay"),
        .external(name: "RxGesture"),
        .external(name: "Lottie"),
        .external(name: "Realm"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseDatabase"),
    ]
    
    func generateConfigurations() -> Settings {
//        Settings.settings(configurations: [
//            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectName)/Sources/Config/Debug.xcconfig")),
//            .release(name: "Release", xcconfig: .relativeToRoot("\(projectName)/Sources/Config/Release.xcconfig")),
//        ])
        return .settings(defaultSettings: .recommended)
    }
    
    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.tnzkm.\(projectName)",
                deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["\(projectName)/Sources/**"],
                resources: "\(projectName)/Resources/**",
//                entitlements: "\(projectName).entitlements",
                scripts: [.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint")],
                dependencies: dependencies
            ),
        ]
    }
}

// MARK: - Project
let factory = BaseProjectFactory()

let project: Project = .init(
    name: factory.projectName,
    organizationName: factory.projectName,
    settings: factory.generateConfigurations(),
    targets: factory.generateTarget()
)
