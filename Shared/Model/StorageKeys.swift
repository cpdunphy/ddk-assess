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
    
    
    struct Assessments {
        
        static func timerLength(_ type: AssessmentType) -> String {
            return type.rawValue + "_timer_length"
        }
        
        static func countdownLength(_ type: AssessmentType) -> String {
            return type.rawValue + "_countdown_length"
        }
        
        static func showDecimal(_ type: AssessmentType) -> String {
            return type.rawValue + "_show_decimal"
        }
    }
    
    
    struct History {
        public static let pinnedRecords :   String = "pinned_records"
        public static let sortBy :          String = "sort_history_by"
        public static let useGroups :       String = "use_groups_in_history"
        
    }
    
}


