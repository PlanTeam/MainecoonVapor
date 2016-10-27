import MainecoonVapor
import MongoKitten
import Vapor
import HTTP

let drop = Droplet()

drop.post("todos") { req in
    // TODO: Check permissions
    
    // Create a Todo from the request
    let todo = try Todo(request: req)
    
    // Return the messae
    return "Successfully created Todo: \(todo.getProperty(forKey: "_id").string)"
}

drop.get("todos") { _ in
    let todos = Array(try Todo.find())
    
    let jsons = todos.map({ todo in
        return todo.document.makeExtendedJSON()
        })
    
    return jsons.joined(separator: ",")
}

drop.get("todos", ObjectId.self) { _, todoIdentifier in
    guard let todo = try Todo.findOne(matching: "_id" == todoIdentifier) else {
        return "TODO not found"
    }
    
    return todo
}

drop.delete("todos", ObjectId.self) { req, todoIdentifier in
    guard let todo = try Todo.findOne(matching: "_id" == todoIdentifier) else {
        return "TODO not found"
    }
    
    try todo.remove()
    return "Todo removed"
}

let server = try! Server(hostname: "localhost")
let db = server["todo-test"]

try registerModel(named: ("todo", "todos"), withSchematics: ["title": (.nonEmptyString, true), "completed": (.bool, true), "order": (.number, true)], inDatabase: db, instanceType: Todo.self)

drop.run()
