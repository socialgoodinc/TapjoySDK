//
//  ConfigView.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 20/12/2022.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var configViewModel: ConfigViewModel
    @State private var pickerShown = false
    @State private var pickerRotationDegree = 0.0
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text(configViewModel.statusMessage)
                        .padding(.vertical)
                        .foregroundColor(Color("TextColor"))
                    HStack {
                        Text("Auto Connect" )
                            .foregroundColor(Color("TextColor"))
                        Toggle("Auto Connect",isOn: $configViewModel.autoConnect)
                            .onChange(of: configViewModel.autoConnect) { _ in
                                configViewModel.autoConnectToTapjoy()
                            }
                            .labelsHidden()
                        Spacer()
                    }.padding(.horizontal)
                        .padding(.bottom)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("SDK Key: ")
                                .foregroundColor(Color("TextColor"))
                                .padding(.leading)
                            HStack {
                                TextField("Enter Key Here...", text: $configViewModel.keyTextField, onEditingChanged: {_ in
                                    configViewModel.textFieldDidBeginEditing()
                                } )
                                .frame(height: 40)
                                .background(Color.white)
                                .autocapitalization(.none)
                                .cornerRadius(8)
                                .padding(.leading)
                                .foregroundColor(Color.black)
                                Button(action:{
                                    pickerShown = !pickerShown
                                    pickerRotationDegree = pickerShown ? 180.0 : 0.0
                                    
                                }) {
                                    Image("Dropdown")
                                        .foregroundColor(Color("ButtonColor"))
                                        .frame(height:36)
                                        .cornerRadius(8)
                                        .rotationEffect(.degrees(pickerRotationDegree))
                                }
                                .padding(.trailing)
                            }
                        }
                        .padding(.bottom)
                        HStack {
                            VStack {
                                if (!pickerShown) {
                                    AddClearButtonsView()
                                        .padding(.top)
                                }
                                Picker("", selection: $configViewModel.keyTextField) {
                                    ForEach(configViewModel.keyArray, id: \.self){
                                        Text($0)
                                            .foregroundColor(.black)
                                    }
                                }.frame(maxHeight:80)
                                    .pickerStyle(WheelPickerStyle())
                                    .opacity(pickerShown ? 1.0 : 0.0)
                                    .onChange(of: configViewModel.keyTextField) { _ in
                                        configViewModel.restartAppMeesage()
                                        configViewModel.pickerDidSelect()
                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.top, 40)
                                if (pickerShown) {
                                    AddClearButtonsView()
                                        .padding(.top, 35)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}


struct AddClearButtonsView: View {
    @EnvironmentObject var configViewModel: ConfigViewModel
    var body: some View {
        HStack {
            Button(action: {configViewModel.addButtonPressed()}){
                Text("Add")
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                    .font(Font.headline)
                    .padding()
            }
            .frame(maxHeight: 40)
            .background(Color("ButtonColor"))
            .foregroundColor(Color("TextColor"))
            .cornerRadius(10)
            .padding(.leading, 30)
            
            Button(action: {configViewModel.clearButtonPressed()}){
                Text("Clear")
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                    .font(Font.headline)
                    .padding()
            }
            .frame(maxHeight: 40)
            .background(Color("ButtonColor"))
            .foregroundColor(Color("TextColor"))
            .cornerRadius(10)
            .padding(.trailing, 30)
        }
    }
}
struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}

