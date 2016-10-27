import MainecoonVapor
import Vapor

class Todo: VaporInstance {
    var title: String {
        get {
            return self.getProperty(forKey: "title") ?? ""
        }
        set {
            self.setProperty(toValue: newValue, forKey: "title")
        }
    }
    
    var completed: Bool {
        get {
            return self.getProperty(forKey: "completed") ?? false
        }
        set {
            self.setProperty(toValue: newValue, forKey: "completed")
        }
    }
    
    var order: Int? {
        get {
            return self.getProperty(forKey: "order")
        }
        set {
            self.setProperty(toValue: newValue, forKey: "order")
        }
    }
}
