//
//  installCerts.swift
//  MacOS InstallRoot
//
//  Created by John Seabourn on 4/18/20.
//  Copyright © 2020 John Seabourn. All rights reserved.
//
import Foundation

func installCerts() {
    var complete = false
    let path = "/bin/bash"
    let argument: [String] = [Bundle.main.path(forResource: "installRoot",ofType:"command")!]
    let buildTask = Process()
    buildTask.launchPath = path
    buildTask.arguments = argument
    do {
        try buildTask.run()
    } catch { print("Error during launch")}
    buildTask.waitUntilExit()
    complete.toggle()
}
