//
//  templateInstall.swift
//  Pulse
//
//  Created by Лазарев Павел on 11.10.2023.
//

import Foundation

enum Constants {
    enum CommandLineValues {
        static let yes = "y"
        static let no = "n"
    }

    enum File {
        static let templateNames = ["TCA Feature.xctemplate", "TCA Feature+View.xctemplate"]
        static let destinationRelativePath = "/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project Templates/iOS/Application"
    }

    enum Messages {
        static let successMessage = "✅  Template was installed succesfully 🎉. Enjoy it 🙂"
        static let successfullReplaceMessage = "✅  The Template has been replaced for you with the new version 🎉. Enjoy it 🙂"
        static let errorMessage = "❌  Ooops! Something went wrong 😡"
        static let exitMessage = "Bye Bye 👋"
        static let promptReplace = "That Template already exists. Do you want to replace it? (y or n)"
    }

    enum Blocks {
        static let printSeparator = { print("====================================") }
    }
}

func printToConsole(_ message: Any) {
    Constants.Blocks.printSeparator()
    print("\(message)")
    Constants.Blocks.printSeparator()
}

func moveTemplate(templateName: String, destinationPath: String, fileManager: FileManager) throws {
    if !fileManager.fileExists(atPath: "\(destinationPath)/\(templateName)") {
        try fileManager.copyItem(atPath: templateName, toPath: "\(destinationPath)/\(templateName)")
    } else {
        try replaceItemAt(URL(fileURLWithPath: "\(destinationPath)/\(templateName)"), withItemAt: URL(fileURLWithPath: templateName))
    }
}

func replaceItemAt(_ url: URL, withItemAt itemAtUrl: URL) throws {
    let fileManager = FileManager.default
    try fileManager.removeItem(at: url)
    try fileManager.copyItem(atPath: itemAtUrl.path, toPath: url.path)
}

func shell(launchPath: String, arguments: [String]) -> String {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)!
    if output.count > 0 {
        // remove newline character.
        let lastIndex = output.index(before: output.endIndex)
        return String(output[output.startIndex ..< lastIndex])
    }
    return output
}

func bash(command: String, arguments: [String]) -> String {
    let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
    return shell(launchPath: whichPathForCommand, arguments: arguments)
}

func run() {
    let fileManager = FileManager.default
    let destinationPath = bash(command: "xcode-select", arguments: ["--print-path"]).appending(Constants.File.destinationRelativePath)
    
    for templateName in Constants.File.templateNames {
        do {
            try moveTemplate(templateName: templateName, destinationPath: destinationPath, fileManager: fileManager)
        } catch let error as NSError {
            printToConsole("\(Constants.Messages.errorMessage) : \(error.localizedFailureReason!)")
            return
        }
    }
    printToConsole(Constants.Messages.successMessage)
}

run()
