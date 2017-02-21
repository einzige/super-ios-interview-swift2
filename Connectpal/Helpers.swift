import Foundation

// Background syntax sugar
infix operator ~>

// Queue for dispatch serial operator
private let queue = DispatchQueue(label: "serial-worker", attributes: [])

// ( background ) ~> ( main thread callback )
func ~> <R> (
    backgroundClosure: @escaping () -> R,
    mainClosure: @escaping (_ result: R) -> ())
{
    queue.async {
        let result = backgroundClosure()
        DispatchQueue.main.async(execute: {
            mainClosure(result)
        })
    }
}
