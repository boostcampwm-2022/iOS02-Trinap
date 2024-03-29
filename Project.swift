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
        .external(name: "SnapKit"),
        .external(name: "HorizonCalendar"),
        .external(name: "Kingfisher"),
        .external(name: "SkeletonView"),
        .target(name: "Queenfisher"),
        .target(name: "FirestoreService"),
        .target(name: "Than"),
        .target(name: "LocationCache"),
    ]
    
    let testDependencies: [TargetDependency] = [
        .external(name: "RxSwift"),
        .external(name: "RxTest"),
        .external(name: "RxBlocking")
    ]
    
    let firestoreServiceDependencies: [TargetDependency] = [
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseDatabase"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseMessaging"),
        .external(name: "FirebaseStorage"),
        .external(name: "FirebaseFunctions"),
        .external(name: "RxSwift")
    ]
    
    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "CFBundleDevelopmentRegion": "ko_KR",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIUserInterfaceStyle": "Light",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "NSLocationAlwaysAndWhenInUseUsageDescription": "작가 검색 및 위치 공유를 위해 위치 확인 권한이 필요합니다.",
        "NSLocationWhenInUseUsageDescription": "작가 검색 및 위치 공유를 위해 위치 확인 권한이 필요합니다.",
        "NSCameraUsageDescription": "포트폴리오 촬영을 위해 카메라 권한이 필요합니다.",
        "NSPhotoLibraryUsageDescription": "포트폴리오 및 채팅으로 이미지 공유를 위해 앨범 접근 권한이 필요합니다.",
        "CFBundleURLTypes" : ["App-prefs"],
        "UIAppFonts": [
            "Item 0": "Pretendard-Medium.otf",
            "Item 1": "Pretendard-Regular.otf",
            "Item 2": "Pretendard-SemiBold.otf",
            "Item 3": "Pretendard-Bold.otf"
        ]
    ]
    
    func generateConfigurations() -> Settings {
        return Settings.settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectName)/Sources/Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("\(projectName)/Sources/Config/Release.xcconfig")),
        ])
    }
    
    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.tnzkm.\(projectName)",
                deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["\(projectName)/Sources/**"],
                resources: "\(projectName)/Resources/**",
                entitlements: "\(projectName).entitlements",
                scripts: [
                    .pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint"),
                    .pre(path: "Scripts/UpdatePackageRunScript.sh", arguments: [], name: "OpenSource")
                ],
                dependencies: dependencies,
                environment: [
                    "use_fake_repository": "false",
                    "is_succeed_case": "false"
                ]
            ),
            Target(
                name: "Queenfisher",
                platform: .iOS,
                product: .framework,
                bundleId: "com.tnzkm.\(projectName).Queenfisher",
                infoPlist: .default,
                sources: ["Queenfisher/Sources/**"],
                dependencies: []
            ),
            Target(
                name: "\(projectName)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "com.tnzkm.\(projectName)Tests",
                infoPlist: .default,
                sources: ["\(projectName)Tests/Sources/**"],
                dependencies: testDependencies + [.target(name: projectName)]
            ),
            Target(
                name: "FirestoreService",
                platform: .iOS,
                product: .framework,
                bundleId: "com.tnzkm.\(projectName).FirestoreService",
                infoPlist: .default,
                sources: ["FirestoreService/Sources/**"],
                dependencies: firestoreServiceDependencies
            ),
            Target(
                name: "Than",
                platform: .iOS,
                product: .framework,
                bundleId: "com.tnzkm.\(projectName).Than",
                infoPlist: .default,
                sources: ["Than/Sources/**"],
                dependencies: []
            ),
            Target(
                name: "LocationCache",
                platform: .iOS,
                product: .framework,
                bundleId: "com.tnzkm.\(projectName).LocationCache",
                infoPlist: .default,
                sources: ["LocationCache/Sources/**"],
                dependencies: []
            )
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
