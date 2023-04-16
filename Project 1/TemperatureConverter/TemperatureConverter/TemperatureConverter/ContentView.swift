//
//  ContentView.swift
//  TemperatureConverter
//
//  Created by Sachin Nair on 4/14/23.
//

import SwiftUI

struct ContentView: View {
    let temperatureUnits = ["F", "C", "K"]
    @State private var baseTempType = "F"
    @State private var finalTempType = "C"
    
    @State private var baseTemp = 0.0
    @FocusState private var temperatureIsFocused: Bool
    
    var finalTemperature: Double {
        var baseCelsius = baseTemp
        
        switch (baseTempType) {
            case "F":
                baseCelsius = (baseTemp - 32) * 5 / 9
            case "K":
                baseCelsius = baseTemp - 273.15
            default: break
        }
        
        switch (finalTempType) {
            case "F":
                return (baseCelsius * 9 / 5) + 32
            case "K":
                return baseCelsius + 273.15
            default: return baseCelsius
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Temperature", value: $baseTemp, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($temperatureIsFocused)
                }
                
                Section {
                    Picker("Base Temperature Unit", selection: $baseTempType) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Base Temperature Unit")
                }
                
                Section {
                    Picker("Final Temperature Unit", selection: $finalTempType) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Final Temperature Unit")
                }
                
                Section {
                    Text(String(finalTemperature))
                } header: {
                    Text("Final Temperature")
                }
            }
            .navigationTitle("Temperature Converter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        temperatureIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
