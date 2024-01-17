//
//  ContentView.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 26/09/2022.
//

import SwiftUI
import Tapjoy

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    @State var showEntryPointActionSheet = false
    private func getEntryPointActionButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []

        for entryPoint in appDelegate.entryPoints {
            if entryPoint == .unknown {
                buttons.append(.destructive(Text("None")) {
                    appDelegate.selectedEntryPoint = entryPoint
                })
                continue
            }
            buttons.append(.default(Text(appDelegate.titleFor(entryPoint: entryPoint))) {
                appDelegate.selectedEntryPoint = entryPoint
            })
        }
        buttons.append(.cancel())

        return buttons
    }
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Group {
                        Text("\(appDelegate.statusMessage)").foregroundColor(Color("TextColor"))
                            .padding(.bottom)
                        
                        if !Tapjoy.isConnected() {
                            Button(action: {
                                appDelegate.manualConnect = true
                                appDelegate.connectToTapjoy()
                            }) {
                                Text("Connect To Tapjoy")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {appDelegate.showOfferwallAction()}) {
                            Text("Show Offerwall")
                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                .font(Font.headline)
                                .padding()
                        }
                        .frame(maxHeight: 40)
                        .background(Color("ButtonColor"))
                        .foregroundColor(Color("TextColor"))
                        .cornerRadius(10)
                        
                        Button(action: {appDelegate.getDirectPlayVideoAdAction()}){
                            Text("Get Direct Play Video Ad")
                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                .font(Font.headline)
                                .padding()
                        }
                        .frame(maxHeight: 40)
                        .background(Color("ButtonColor"))
                        .foregroundColor(Color("TextColor"))
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        HStack {
                            Text("Managed Currency").foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        
                        HStack {
                            Button(action: {appDelegate.getCurrencyBalanceAction()}) {
                                Text("Get")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            
                            Button(action: {appDelegate.spendCurrencyAction()}) {
                                Text("Spend")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            
                            Button(action: {appDelegate.awardCurrencyAction()}) {
                                Text("Award")
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
                            Text("Content Placements").foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        TextField(" Placement", text: $appDelegate.placementString)
                            .onChange(of: appDelegate.placementString) { value in
                                appDelegate.placementNameDidChange()
                            }
                            .frame(height: 40)
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .cornerRadius(8)
                            .padding(.bottom)
                        HStack{
                            Button(action: {appDelegate.requestContentAction(placementName: appDelegate.placementString)}){
                                Text("Request")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                            
                            
                            Button(action: {appDelegate.showContentAction()}) {
                                Text("Show")
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
                            Text("Entry point").foregroundColor(Color("TextColor"))
                            Spacer()
                        }

                        Button {
                            self.showEntryPointActionSheet = true
                        } label: {
                            Text(appDelegate.titleFor(entryPoint: appDelegate.selectedEntryPoint))
                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                .font(Font.headline)
                                .padding()
                        }
                        .frame(maxHeight: 40)
                        .background(Color("ButtonColor"))
                        .foregroundColor(Color("TextColor"))
                        .cornerRadius(10)
                        .actionSheet(isPresented: $showEntryPointActionSheet) {
                            ActionSheet(title: Text("Select Entry Point"), message: nil, buttons: getEntryPointActionButtons())
                        }
                    }
                    Group {
                        HStack {
                            Text("Currency").foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        HStack {
                            VStack(alignment: .labelAlignmentGuide, spacing: 2) {
                                Text("Identifier")
                                    .foregroundColor(Color("TextColor"))
                                    .font(.system(size: 10))
                                    .frame(height: 24)
                                Text("Balance")
                                    .foregroundColor(Color("TextColor"))
                                    .font(.system(size: 10))
                                    .frame(height: 24)
                                Text("Required Amount")
                                    .foregroundColor(Color("TextColor"))
                                    .font(.system(size: 10))
                                    .frame(height: 24)
                            }
                            VStack(spacing: 2) {
                                TextField(" Currency ID", text: $appDelegate.currencyId)
                                    .frame(height: 24)
                                    .background(Color.white)
                                    .foregroundColor(Color.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .cornerRadius(2)
                                    .font(.system(size: 10))
                                TextField(" Self-managed only", text: $appDelegate.currencyBalanceString)
                                    .frame(height: 24)
                                    .background(Color.white)
                                    .foregroundColor(Color.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .cornerRadius(2)
                                    .keyboardType(.numbersAndPunctuation)
                                    .font(.system(size: 10))
                                TextField(" Required amount of currency", text: $appDelegate.currencyRequiredAmountString)
                                    .frame(height: 24)
                                    .background(Color.white)
                                    .foregroundColor(Color.black)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .cornerRadius(2)
                                    .keyboardType(.numbersAndPunctuation)
                                    .font(.system(size: 10))
                            }
                        }
                    }
                    Group {
                        
                        HStack {
                            Text("Purchase").foregroundColor(Color("TextColor"))
                            Spacer()
                        }
                        
                        Button(action: {appDelegate.sendPurchaseEventAction()}) {
                            Text("Purchase")
                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                .font(Font.headline)
                                .padding()
                        }
                        .frame(maxHeight: 40)
                        .background(Color("ButtonColor"))
                        .foregroundColor(Color("TextColor"))
                        .cornerRadius(10)
                    }
                    
                    Group {
                        Button(action: {appDelegate.sendPurchaseWithCampaignEventAction()}) {
                            Text("Purchase (Campaign)")
                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                .font(Font.headline)
                                .padding()
                        }.frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            .padding(.bottom)
                        
                        Toggle("Debug Enabled", isOn: $appDelegate.debugSwitch)
                            .onChange(of: appDelegate.debugSwitch) { value in
                                appDelegate.toggleDebugEnabled()
                            }
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom)
                        HStack {
                            Text("SDK Version: \(appDelegate.sdkVersion)")
                                .foregroundColor(Color("TextColor"))
                            Spacer()
                            Text("Support WebLink")
                                .foregroundColor(Color.blue)
                                .underline()
                                .onTapGesture() {
                                    UIApplication.shared.open(URL(string: appDelegate.supportURLString)!, options: [:])
                                }
                            
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}

extension HorizontalAlignment {
    /// A custom alignment for image titles.
    private struct LabelAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to bottom alignment if no guides are set.
            context[HorizontalAlignment.leading]
        }
    }


    /// A guide for aligning titles.
    static let labelAlignmentGuide = HorizontalAlignment(
        LabelAlignment.self
    )
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



