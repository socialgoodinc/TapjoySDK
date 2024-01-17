//
//  CustomEventsView.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 10/10/2022.
//

import SwiftUI

struct CustomEventsView: View {
    @EnvironmentObject var customEventsViewModel: CustomEventsViewModel
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Group{
                        Text("\(customEventsViewModel.statusMessage)")
                            .foregroundColor(Color("TextColor"))
                            .padding()
                        HStack {
                            Button(action: {customEventsViewModel.noneButton()}) {
                                Text("None")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                          
                            
                            Button(action: {customEventsViewModel.p1EventButton()}) {
                                Text("P1")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            
                            
                            Button(action: {customEventsViewModel.vEventButton()}) {
                                Text("Value")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            
                            
                            Button(action: {customEventsViewModel.p1p2EventButton()}) {
                                Text("P1P2")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            
                        }
                        .padding(.horizontal)
                        HStack {
                            Button(action: {customEventsViewModel.p1vEventButton()}) {
                                Text("P1V")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            Button(action: {customEventsViewModel.p1p2vEventButton()}) {
                                Text("P1P2V")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            Button(action: {customEventsViewModel.p1p2v1v2EventButton()}) {
                                Text("P1P2V1V2")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            Button(action: {customEventsViewModel.allEventButton()}) {
                                Text("All")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                        }.padding()
                    }
                }
            }
        }
    }
}

struct CustomEventsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomEventsView()
    }
}
