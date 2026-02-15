//handles persistent storage of items, history and error logs
//save: rewrites file, use for items
//append: just adds to file, use for history
import Foundation

struct PersistenceManager {

    private static func fileURL(for filename: String) -> URL {
        let paths: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
    
    static func save<T: Codable>(_ data: [T], to filename: String) -> Result<Void, Error> {
        let url: URL = fileURL(for: filename)
        
        do {
            let encoder: JSONEncoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encodedData: Data = try encoder.encode(data)
            try encodedData.write(to: url, options: .atomic)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    static func append<T: Codable>(_ data: T, to filename: String) -> Result<Void, Error> {
        let url: URL = fileURL(for: filename)
        
        do {
            let encoder: JSONEncoder = JSONEncoder()
            let encodedData: Data = try encoder.encode(data)
            var entryData: Data = encodedData
            entryData.append(contentsOf: "\n".data(using: .utf8)!)
            
            if FileManager.default.fileExists(atPath: url.path) {
                let fileHandle: FileHandle = try FileHandle(forWritingTo: url)
                defer { fileHandle.closeFile() }
                fileHandle.seekToEndOfFile()
                fileHandle.write(entryData)
            } else {
                try entryData.write(to: url, options: .atomic)
            }
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    static func loadItems<T: Codable>(_ filename: String, as type: T.Type) -> Result<[T], Error> {
        let url: URL = fileURL(for: filename)
        
        do {
            let data: Data = try Data(contentsOf: url)
            let decoder: JSONDecoder = JSONDecoder()
            let decodedList: [T] = try decoder.decode([T].self, from: data)
            return .success(decodedList)  
        } catch {
            return .failure(error)
        }
    }
    
    static func loadHistory<T: Codable>(_ filename: String, as type: T.Type) -> Result<[T], Error> {
        let url: URL = fileURL(for: filename)
        var results: [T] = []
        
        do {
            let content: String = try String(contentsOf: url, encoding: .utf8)
            
            let decoder: JSONDecoder = JSONDecoder()
            content.enumerateLines { (line: String, _) in
                if let data: Data = line.data(using: .utf8),
                let item: T = try? decoder.decode(T.self, from: data) {
                    results.append(item)
                }
            }
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}