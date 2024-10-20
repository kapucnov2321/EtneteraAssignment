//
//  RealmActivityData.swift
//  Etnetera
//
//  Created by Ján Matoniak on 20/10/2024.
//

import Foundation
import RealmSwift

class RealmActivityData: Object {
    @Persisted var id: String = ""
    @Persisted var activityName: String = ""
    @Persisted var activityPlace: String = ""
    @Persisted var activityDuration: String = ""
    
    func toActivityData() -> ActivityData {
        ActivityData(
            id: id,
            activityName: activityName,
            activityPlace: activityPlace,
            activityDuration: activityDuration
        )
    }

    func toCategorized(category: DatabaseLocation) -> CategorizedActivityData {
        CategorizedActivityData(
            id: self.id,
            activityName: self.activityName,
            activityPlace: self.activityPlace,
            activityDuration: self.activityDuration,
            databaseLocation: category
        )
    }
}
