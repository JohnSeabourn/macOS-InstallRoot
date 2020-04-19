//
//  ContentView.swift
//  MacOS InstallRoot
//
//  Created by John Seabourn on 4/17/20.
//  Copyright © 2020 John Seabourn. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .padding()
            Text("macOS InstallRoot")
                .font(.largeTitle)
                .foregroundColor(Color.black)
            Button(action: {
                installCerts()
            }) {
                Text("Install DoD Certs")
                .font(.headline)
                .foregroundColor(Color.black)
                .background(Color.gray)
                .padding()
                .background(Color.gray)
                .cornerRadius(16)
            }
        .buttonStyle(PlainButtonStyle())
            .padding(30)
            Text("version 1.0")
                .foregroundColor(Color.black)
                .padding()
        }.frame(width: 600, height: 400, alignment: .center)
            .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
