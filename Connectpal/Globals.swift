import UIKit

enum Environment : Int {
    case development
    case production
    case test
}

class Globals {
    lazy var player: Player = {
       return Player()
    }()
    
    var mode = Environment.development
    
    lazy var logger: Logger = {
        return Logger()
    }()
}

let globals = Globals()
