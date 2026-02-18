//
//  ContentView.swift
//  BookMyCar
//
//  Created by Kiran Sonne on 14/02/26.
//

import SwiftUI
import FoundationModels
struct ContentView: View {
    @State var model = LMModel()
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12){
                        ForEach(model.session.transcript) { entry in
                            Group {
                                switch entry {
                                case .prompt(let prompt):
                                    MessageView(segments: prompt.segments, isUser: true)
                                        .transition(.offset(y: 500))
                                        .padding(.trailing)
                                case .response(let response):
                                    MessageView(segments: response.segments, isUser: false)
                                        .padding(.leading, 10)
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .animation(.easeInOut, value: model.session.transcript)
                    
                    if model.isAwaitingResponse {
                        if let last = model.session.transcript.last {
                            if case .prompt = last {
                                HStack(spacing: 12) {
                                    HStack(spacing: 4) {
                                        ForEach(0..<3) { index in
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 8, height: 8)
                                                .offset(y: model.isThinking ? -5 : 0)
                                                .animation(
                                                    .easeInOut(duration: 0.5)
                                                        .repeatForever()
                                                        .delay(Double(index) * 0.15),
                                                    value: model.isThinking
                                                )
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                }
                                .padding(.leading)
                                .offset(y: 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onAppear {
                                    model.isThinking = true
                                }
                            }
                        }
                    }
                }
                .defaultScrollAnchor(.bottom, for: .sizeChanges)
                .safeAreaPadding(.bottom, 100)
                
            }
            .navigationTitle("Chat bot")
        }
        HStack {
            TextField("ask me anything...", text: $model.inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .disabled(model.session.isResponding)
                .frame(height: 55)
            Button {
                model.sendMessage()
            }label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 30,weight: .bold))
                    .foregroundStyle(model.session.isResponding ? Color.gray.opacity(0.6) : .primary)
            }
            .disabled(model.inputText.isEmpty || model.session.isResponding)
        }
        .padding(.horizontal)
        .glassEffect(.regular.interactive())
        .padding()
        .frame(maxWidth: .infinity,alignment: .bottom)
    }
}



 
