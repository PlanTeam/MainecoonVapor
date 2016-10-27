# Mainecoon Vapor

These are the Vapor helpers for Mainecoon.

Mainecoon is an ORM aimed at having a really small amount of bloat in setting things up.

Mainecoon is based on MongoDB and [MongoKitten](https://github.com/OpenKitten/MongoKitten).

## Usage

Mainecoon revolves around four main objects.

- The MongoKitten Database object
- Instance
- Model
- Schema

So every MongoKitten Database is a collection of collections. Collections have a name, requirements and Documents.

Every Instance in Mainecoon is a Document underneath. The Document is automatically stored/managed in the Collection which resides in the Database on the MongoDB server.

Instances are the Document's representation in your code.

Models are a combination of a Schema and an Instance Type. An Instance's Swift Type is registered together with a name and a Schema. This Schema will be used to validate any Instance.

All models are registered using the `registerModel` global method

The most basic example of mainecoon looks like this:

```swift
import MainecoonVapor
import MongoKitten

class Todo: VaporInstance {}

do {
    let server = try Server(mongoURL: "mongodb://localhost:27017")
    let database = server["mydatabase"]
    
    let todoSchema: Schema = [
        "title": (match: .nonEmptyString, required: true),
        "description": (match: .string, required: true)
    ]
    
    try registerModel(named: (singular: "todo", plural: "todos"), withSchematics: todoSchema, inDatabase: database, instanceType: Todo.self)

} catch {
  fatalError("Unable to set up application")
}
```

The matches for the Schema can be found in [Schema.swift](https://github.com/OpenKitten/Mainecoon/blob/master/Sources/Schema.swift). They're the `FieldRequirement`s.

As of writing we support:

```
case string, number, date, anyObject, bool, nonEmptyString
case reference(model: Instance.Type)
case object(matching: Schema)
case enumeration([ValueConvertible])
case array(of: FieldRequirement)
case any(requirement: [FieldRequirement])
case exactly(BSON.Value)
case all(requirements: [FieldRequirement])
case matchingRegex(String, withOptions: String)
case anything
```

The schema will be used to validate the stored Instance types to validate whole Instances on initialization.

## Instances

Instances can be very easily defined:

```swift
class MyInstance: VaporInstance {}
```

However.. this doesn't add much usability. Having to extract and update every value from the Instance manually is a ugly. Luckily Swift allows you to use getters and setters to fix this problem.


```swift
class Todo: VaporInstance {
    var title: String? {
        get {
            return self.getProperty(forKey: "username")
        }
        set {
            self.setProperty(toValue: newValue, forKey: "username")
        }
    }
}
```

Since we have the ensurance from the Schema that this property will always be a String when stored, fetched and initialized we can get rid of the Optional part without a problem:

```swift
class Todo: VaporInstance {
    var title: String {
        get {
            return self.getProperty(forKey: "username") ?? ""
        }
        set {
            self.setProperty(toValue: newValue, forKey: "username")
        }
    }
}
```

## Exposing using Vapor

All VaporInstance types use ObjectId as their default identifier and are StringInitializable. This allows you to let vapor help you resolve the object.

```swift
let drop = Droplet()

drop.get("todos", Todo.self) { request, todo in
    return todo
}
```

The above code will resolve "/todos/0123456789abcdef" to a Todo's ObjectId and it'll resolve the ObjectId to the related Todo. then it'll return the Todo object as MongoDB Extended JSON to the client.

If you prefer to return only the title of the todo it's as simple as:

```swift
let drop = Droplet()

drop.get("todos", Todo.self) { request, todo in
    return todo.title
}
```