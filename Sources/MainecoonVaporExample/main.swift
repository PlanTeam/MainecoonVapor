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
    return "Successfully created Todo: \(todo.getProperty(forKey: "_id") as String?)"
}

drop.get("todos") { _ in
    let todos = Array(try Todo.find())
    
    let jsons = todos.map({ todo in
        return todo.document.makeExtendedJSON()
        })
    
    return jsons.joined(separator: ",")
}

drop.get("todos", Todo.self) { _, todo in
    return todo
}

drop.delete("todos", Todo.self) { req, todo in
    try todo.remove()
    return "Todo \(todo.identifier) removed"
}

let server = try! Server(hostname: "localhost")
let db = server["todo-test"]

try registerModel(named: ("todo", "todos"), withSchematics: ["title": (.nonEmptyString, true), "completed": (.bool, true), "order": (.number, true)], inDatabase: db, instanceType: Todo.self)

drop.run()
