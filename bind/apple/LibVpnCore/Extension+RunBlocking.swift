import Foundation

public func runBlocking<T>(_ operation: @escaping () async throws -> T) rethrows -> T {
    let semaphore = DispatchSemaphore(value: 0)
    var result: Result<T, Error>?
    
    Task {
        do {
            let value = try await operation()
            result = .success(value)
        } catch {
            result = .failure(error)
        }
        semaphore.signal()
    }
    
    semaphore.wait()
    switch result! {
    case .success(let val): return val
    case .failure(let err):
        #if compiler(>=5.7)
        throw err
        #else
        fatalError("Error in runBlocking: \(err)")
        #endif
    }
}
