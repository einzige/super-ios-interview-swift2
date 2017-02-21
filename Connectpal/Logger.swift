import Foundation

class Logger {
    // NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__]
    
    func info(_ str: String) {
        if globals.mode == Environment.development {
            NSLog("%@", str)
        }
    }
}
