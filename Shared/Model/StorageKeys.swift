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
        public static let galleryType :         String = "assessment_gallery_type"
        public static let favoriteAssessments : String = "favorite_assessment_types"
        public static let sortBy :              String = "sort_by_assessment_gallery"
    }
    
    struct Timed {
        public static let timerLength : String = "timer_length"
    }
    
    struct History {
        public static let pinnedRecords :   String = "pinned_records"
        public static let sortBy :          String = "sort_history_by"
        public static let useGroups :       String = "use_groups_in_history"
        
    }
    
}
