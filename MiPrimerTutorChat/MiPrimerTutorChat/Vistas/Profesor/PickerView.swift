//
//  PickerView.swift
//  MiPrimerTutorChat
//
//  Created by Irving Alejandro Vega Lagunas on 02/12/23.
//

import SwiftUI

struct PickerView: View {
    var label: String
    var data: [String]
    @Binding var selection: String

    var body: some View {
        Form {
            Picker(label, selection: $selection) {
                ForEach(data, id: \.self) { item in
                    Text(item).tag(item)
                }
            }
            .font(.system(size: 22, design: .rounded))
        }
        .frame(height: 100)
    }
}

#Preview {
    PickerView(label: "Test", data: ["Option 1", "Option 2"], selection: .constant("Option 1"))

}
