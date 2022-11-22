//
//  Dependencies.swift
//  Config
//
//  Created by 김세영 on 2022/11/10.
//

import ProjectDescription

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.5.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMinor(from: "4.0.0")),
    .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "8.10.0")),
    .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .branch("master")),
    .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.0")),
    .remote(url: "https://github.com/airbnb/HorizonCalendar.git", requirement: .branch("master"))
])

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
