import MainecoonVapor
import Vapor

class Todo: VaporInstance {
    var title: String {
        get {
            return self.getProperty("title").string
        }
        set {
            self.setProperty("title", toValue: ~newValue)
        }
    }
    
    var completed: Bool {
        get {
            return self.getProperty("completed").bool
        }
        set {
            self.setProperty("completed", toValue: ~newValue)
        }
    }
    
    var order: Int {
        get {
            return self.getProperty("order").int
        }
        set {
            self.setProperty("order", toValue: ~newValue)
        }
    }
}
