

import Foundation

struct Service {

    private static func fileURL(for filename: String) -> URL {
        let paths: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }

    private static func logError(_ error: Error, in function: String) {
        var currentAttempt: Int = 0
        let url: URL = fileURL(for: "ERRORLOGS")
        let dateTime: Date = Date()
        let message: Codable = "\(dateTime): \(function), \(error)"
        
        while currentAttempt < 3 {
            do {
                let encoder: JSONEncoder = JSONEncoder()
                let encodedData: Data = try encoder.encode(message)
                try encodedData.write(to: url, options: .atomic)
            } catch {
                currentAttempt += 1
                Thread.sleep(forTimeInterval: 0.01)
            }
        }
    }

    static func saveOrAppend<T: Codable>(_ function: (T, String)->Result<Void, Error>, _ data: T, to filename: String) {
        var currentAttempt: Int = 0
        var lastError: Error?
        
        while currentAttempt < 3 {
            switch function(data, filename) { 
                case .success:
                    return
                case .failure(let error):
                    lastError = error
                    currentAttempt += 1
                    //print("Save failed. Retrying (\(currentAttempt)/\(attempts))...")
                    Thread.sleep(forTimeInterval: 0.1)
                }
            }
        logError(lastError!, in: "Service.saveOrAppend")
    }
    
    static func load<T: Codable>(
        using function: (String, T.Type) ->Result<[T], Error>,
        toRead filename: String,
        as type: T.Type) -> [T] {

        var currentAttempt: Int = 0
        var lastError: Error?
        
        while currentAttempt < 3 {
            switch function(filename, T.self) { 
                case .success(let results):
                    return results
                case .failure(let error):
                    lastError = error
                    currentAttempt += 1
                    //print("Save failed. Retrying (\(currentAttempt)/\(attempts))...")
                    Thread.sleep(forTimeInterval: 0.1)
                }
            }
        logError(lastError!, in: "Service.load")
        return []
    }
}