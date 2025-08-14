//
//  TagChipsView.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 13/08/25.
//

import SwiftUI

struct TagChipsView: View {
    let all: [String]
    @Binding var selected: Set<String>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(all, id: \.self) { tag in
                    let isOn = selected.contains(tag)
                    Text(tag.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(isOn ? Color.gray.opacity(0.2) : Color.clear)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(.secondary.opacity(0.4)))
                        .onTapGesture {
                            if isOn { selected.remove(tag) } else { selected.insert(tag) }
                        }
                }
            }.padding(.vertical, 4)
        }
    }
}
