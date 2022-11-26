//
//  EditDetailPhotographerInformation.swift
//  Trinap
//
//  Created by Doyun Park on 2022/11/26.
//  Copyright © 2022 Trinap. All rights reserved.
//

import Foundation

struct EditDetailPhotographerInformation {
    let photographerProfile: PhotographerProfile
    let introduction: PhotographerDetailIntroduction
    let pictures: [Picture?]
    let review: ReviewInformation
    
    func toProfileDataSource(isEditable: Bool) -> [EditPhotographerDataSource] {
        
        let pictures = self.pictures.map { picture in
            return Picture(isEditable: isEditable, profileImage: picture?.profileImage)
        }
        
        return [self.photographerProfile.toDataSource()] + [[PhotographerSection.photo: pictures.map { PhotographerSection.Item.photo($0) }]]
    }
    
    func toDetailDataSource() -> [EditPhotographerDataSource] {
        return [self.photographerProfile.toDataSource()] + [self.introduction.toDataSource()]
    }
    
    func toReviewDataSource() -> [EditPhotographerDataSource] {
        return [self.photographerProfile.toDataSource()] + self.review.toDataSource()
    }
}
