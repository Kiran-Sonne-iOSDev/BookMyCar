//
//  MessageView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 14/02/26.
//

import SwiftUI
import FoundationModels
struct MessageView: View {
    let segments: [Transcript.Segment]
    let isUser: Bool
    var body: some View {
        VStack{
            ForEach(segments, id: \.id){ segment in
                switch segment {
                case .text(let text):
                    Text(text.content).padding(10)
                        .background(isUser ? Color.gray.opacity(0.2) : Color.clear,in: .rect(cornerRadius: 12))
                        .frame(maxWidth: .infinity,alignment: isUser ? .trailing : .leading)
                case .structure:
                    EmptyView()
                    @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
