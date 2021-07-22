//
//  StorageKeys.swift
//  StorageKeys
//
//  Created by Collin Dunphy on 7/21/21.
//

import Foundation

struct StorageKeys {
    
    struct User {
        public static let totalAssessments : String = "userLogCountTOTAL"
    }
    
    struct AssessGallery {
        public static let galleryType = "assessment_gallery_type"
        public static let favoriteAssessments = "favorite_assessment_types"
        public static let galleryIsGrouped = "gallery_is_grouped"
    }
    
    struct History {
        public static let pinnedRecords = "pinned_records"
        public static let historyIsGrouped : String = "history_is_grouped"
        
    }
    
}
