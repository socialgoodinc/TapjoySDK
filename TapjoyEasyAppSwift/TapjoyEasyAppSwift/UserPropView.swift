//
//  UserPropView.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 10/10/2022.
//

import SwiftUI

struct UserPropView: View {
    @EnvironmentObject var userPropViewModel: UserPropViewModel

    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Group {
                        Text("\(userPropViewModel.statusMessage)")
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom)
                        HStack(alignment: .topSectionTitlesAlignment) {
                            VStack(alignment: .leading) {
                                Text("User ID")
                                    .foregroundColor(Color("TextColor"))
                                    .alignmentGuide(.topSectionTitlesAlignment) {d in
                                        d[VerticalAlignment.center]
                                    }
                                    .padding(.bottom, 35)
                                Text("Level")
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.bottom, 35)
                                Text("Max Level")
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.bottom, 35)
                                Text("Friends")
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.bottom, 35)

                                Text("Cohort \nVariables")
                                    .foregroundColor(Color("TextColor"))
                            }
                            VStack {
                                TextField(" User ID",text: $userPropViewModel.userId)
                                    .alignmentGuide(.topSectionTitlesAlignment) {
                                        d in d[VerticalAlignment.center]
                                    }
                                    .frame(height: 40)
                                    .background(Color.white)
                                    .autocapitalization(.none)
                                    .cornerRadius(8)
                                    .padding(.bottom)
                                
                                TextField(" Level",text: $userPropViewModel.level)
                                    .frame(height: 40)
                                    .background(Color.white)
                                    .autocapitalization(.none)
                                    .cornerRadius(8)
                                    .padding(.bottom)
                                
                                TextField(" Max Level", text: $userPropViewModel.maxLevel)
                                    .frame(height: 40)
                                    .background(Color.white)
                                    .autocapitalization(.none)
                                    .cornerRadius(8)
                                    .padding(.bottom)
                                
                                TextField(" Friends",text: $userPropViewModel.friends)
                                    .frame(height: 40)
                                    .background(Color.white)
                                    .autocapitalization(.none)
                                    .cornerRadius(8)
                                    .padding(.bottom)
                                
                                VStack {
                                    HStack {
                                        TextField(" Cohort 1",text: $userPropViewModel.cohort1)
                                            .frame(height: 40)
                                            .background(Color.white)
                                            .autocapitalization(.none)
                                            .cornerRadius(8)
                                        TextField(" Cohort 2",text: $userPropViewModel.cohort2)
                                            .frame(height: 40)
                                            .background(Color.white)
                                            .autocapitalization(.none)
                                            .cornerRadius(8)
                                        TextField(" Cohort 3",text: $userPropViewModel.cohort3)
                                            .frame(height: 40)
                                            .background(Color.white)
                                            .autocapitalization(.none)
                                            .cornerRadius(8)
                                    }
                                    HStack {
                                        TextField(" Cohort 4",text: $userPropViewModel.cohort4)
                                            .frame(height: 40)
                                            .background(Color.white)
                                            .autocapitalization(.none)
                                            .cornerRadius(8)
                                        TextField(" Cohort 5",text: $userPropViewModel.cohort5)
                                            .frame(height: 40)
                                            .background(Color.white)
                                            .autocapitalization(.none)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    Group {
                        HStack {
                            Text("User \nSegment")
                                .foregroundColor(Color("TextColor"))
                            
                            Picker("User Segment", selection: $userPropViewModel.userSegmentValue) {
                                Text("Non-Payer").tag(0)
                                Text("Payer").tag(1)
                                Text("VIP").tag(2)
                                Text("Not Set").tag(3)
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: userPropViewModel.userSegmentValue) { newValue in
                                userPropViewModel.userSegmentValue = newValue
                            }
                        }.padding(.bottom)
                        HStack {
                            Button(action: {userPropViewModel.setProperties()}) {
                                Text("Set")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            Button(action: {userPropViewModel.clearProperties()}) {
                                Text("Clear")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                        HStack {
                            Text("User Tag")
                                .foregroundColor(Color("TextColor"))
                            
                            TextField(" User Tag",text: $userPropViewModel.userTag)
                                .frame(height: 40)
                                .background(Color.white)
                                .autocapitalization(.none)
                                .cornerRadius(8)
                        }.padding(.bottom)
                        HStack {
                            Button(action: {userPropViewModel.addUserTag()}) {
                                Text("Add")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            Button(action: {userPropViewModel.removeUserTag()}) {
                                Text("Remove")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            Button(action: {userPropViewModel.clearUserTag()}) {
                                Text("Clear")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                    }
                    Group {
                        HStack {
                            Text("Below Consent Age")
                                .foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        Picker("Below Consent Age", selection: $userPropViewModel.belowConsentAge) {
                            Text("Yes").tag(0)
                            Text("No").tag(1)
                            Text("Not Set").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: userPropViewModel.belowConsentAge) { newValue in
                            userPropViewModel.setBelowConsentAge(status: newValue)
                        }
                        HStack {
                            Text("Subject to GDPR")
                                .foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        Picker("Subject to GDPR?", selection: $userPropViewModel.subjectToGDPR) {
                            Text("Yes").tag(0)
                            Text("No").tag(1)
                            Text("Not Set").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: userPropViewModel.subjectToGDPR) { newValue in
                            userPropViewModel.setSubjectToGDPR(status: newValue)
                        }
                        HStack {
                            Text("User Consent")
                                .foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        Picker("User Consent", selection: $userPropViewModel.userConsent) {
                            Text("Yes").tag(0)
                            Text("No").tag(1)
                            Text("Not Set").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: userPropViewModel.userConsent) { newValue in
                            userPropViewModel.setUserConsent(status: newValue)
                        }
                        HStack {
                            Text("US Privacy")
                                .foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        HStack {
                            TextField("US Privacy", text: $userPropViewModel.usPrivacy)
                                .padding(.leading, 4)
                                .frame(height: 40)
                                .background(Color.white)
                                .autocapitalization(.none)
                                .cornerRadius(8)
                                .padding(.bottom)
                            
                            Button(action: {
                                userPropViewModel.setUSPrivacy(value: userPropViewModel.usPrivacy)
                            }){
                                Text("Set")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                        }
                    }
                }
            }
            .padding()
        }

        .onAppear() {
            userPropViewModel.getLocalProperties()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                userPropViewModel.getLocalProperties()
            }
        }

    }
}


struct UserPropView_Previews: PreviewProvider {
    static var previews: some View {
        UserPropView()
    }
}


extension VerticalAlignment {
    
    // A custom vertical alignment to custom align views vertically
    private struct TopSectionTitlesAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to center alignment if no guides are set
            context[HorizontalAlignment.center]
        }
    }
    
    static let topSectionTitlesAlignment = VerticalAlignment(TopSectionTitlesAlignment.self)
}
