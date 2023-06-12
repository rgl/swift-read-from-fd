import Foundation

let fileURL = URL(fileURLWithPath: CommandLine.arguments[1])
print("Reading \(fileURL)...")
let data = try Data(contentsOf: fileURL)
print(data)