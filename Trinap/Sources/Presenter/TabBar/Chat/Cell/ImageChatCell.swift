//
//  ImageChatCell.swift
//  Trinap
//
//  Created by 김세영 on 2022/11/21.
//  Copyright © 2022 Trinap. All rights reserved.
//

import UIKit

import SnapKit
import Kingfisher
import Queenfisher

final class ImageChatCell: ChatCell {
    
    // MARK: - Properties
    private lazy var imageContentView = UIImageView().than {
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Initializers
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        self.imageContentView.kf.cancelDownloadTask()
        self.imageContentView.qf.cancelDownloadTask()
//        self.imageContentView.kf.setImage(with: URL(string: ""))
        self.imageContentView.image = nil
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.chatContentView.addSubview(imageContentView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        imageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureCell(by chat: Chat, hasMyChatBefore: Bool, completion: (() -> Void)? = nil) {
        guard
            let width = chat.imageWidth,
            let height = chat.imageHeight
        else {
            return
        }
        
        super.configureCell(by: chat, hasMyChatBefore: hasMyChatBefore, completion: nil)
        
        let url = URL(string: chat.content)
        let defaultSize = CGSize(width: width, height: height)
        self.imageContentView.qf.setImage(at: url, placeholder: UIView.placeholder(width: width, height: height)) { [weak self] _ in
            self?.layoutIfNeeded()
        }
//        self.imageContentView.kf.setImage(
//            with: url,
//            placeholder: UIView.placeholder(width: width, height: height),
//            options: [.processor(DownsamplingImageProcessor(size: defaultSize))]
//        ) { [weak self] _ in
//            self?.layoutIfNeeded()
//        }
    }
}

// MARK: - Placeholder
private extension UIView {
    
    static func placeholder(width: Double, height: Double) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            TrinapAsset.background.color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        return image
    }
}
