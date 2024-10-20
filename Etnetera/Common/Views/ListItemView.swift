//
//  ListItemView.swift
//  Etnetera
//
//  Created by Ján Matoniak on 20/10/2024.
//

import SwiftUI

struct ListItemView: View {
    let activity: ActivityData

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Activity: \(activity.activityName)")
                .font(.title2)
            HStack(spacing: 15) {
                HStack {
                    Image(systemName: "location")
                    Text(activity.activityPlace)
                }
                HStack {
                    Image(systemName: "clock")
                    Text("\(activity.activityDuration) minutes")
                }
            }
        }
    }
}

#Preview {
    ListItemView(activity: .init(id: "dasd", activityName: "dasda", activityPlace: "sadasd", activityDuration: "dasdasdasdas"))
}
