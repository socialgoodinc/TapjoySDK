//
//  MainView.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 26/09/2022.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    var body: some View {
        TabView {
            ContentView()
                .onAppear() {
                    guard #available(iOS 15.0, *) else {
                        appDelegate.connectToTapjoy()
                        return
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    appDelegate.connectToTapjoy()
                }
                .alert(isPresented: $appDelegate.showAlert) {
                    Alert(title: Text("Got Action Callback", comment: ""),
                          message: Text("\(appDelegate.alertMessage)"),
                          dismissButton: .none)
                }
                .tabItem( {
                    Label("Main", systemImage: "house")
                })
            

            CustomEventsView()
                .environmentObject(CustomEventsViewModel())
                .tabItem( {
                    Label("Custom Events", systemImage: "square.and.pencil")
                })
            

            UserPropView()
                .environmentObject(UserPropViewModel())
                .tabItem({
                    Label("User Properties", systemImage: "person.fill")
                })
            
            OfferwallDiscoverView()
                .environmentObject(OfferwallDiscoverViewModel())
                .tabItem({
                    Label("Offerwall Discover", systemImage: "greetingcard.fill")
                })
            
            ConfigView()
                .environmentObject(ConfigViewModel())
                .tabItem({
                    Label("Config", systemImage: "gear")
                })
                
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
