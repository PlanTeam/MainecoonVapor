@_exported import MongoKitten
@_exported import Vapor
@_exported import Mainecoon

public final class MainecoonProvider: Vapor.Provider {
    /**
     Mongo database created by the provider.
     */
    public let database: MongoKitten.Database
    
    public enum Error: Swift.Error {
        case config(String)
    }
    
    /**
     Creates a new `MongoDriver` with
     the given database name, credentials, and port.
     */
    public init(
        database: String,
        user: String,
        password: String,
        host: String = "localhost",
        port: Int = 27017
        ) throws {
        let server = try Server(hostname: host, port: UInt16(port), authenticatedAs: (user, password, ""))
        
        self.database = server[database]
    }
    
    public func registerModel<T: Instance>(named name: (singular: String, plural: String), withSchematics schematics: Schema, inDatabase db: MongoKitten.Database, instanceType: T.Type) throws {
        _ = try Mainecoon.registerModel(named: name, withSchematics: schematics, inDatabase: self.database, instanceType: instanceType)
    }
    
    public convenience init(config: Config) throws {
        guard let mongo = config["mainecoon"]?.object else {
            throw Error.config("No mainecoon.json config file.")
        }
        
        guard let database = mongo["database"]?.string else {
            throw Error.config("No 'database' key in mongo.json config file.")
        }
        
        let user = mongo["user"]?.string ?? ""
        let password = mongo["password"]?.string ?? ""
        let host = mongo["host"]?.string ?? "localhost"
        let port = mongo["port"]?.int ?? 27017
        
        try self.init(
            database: database,
            user: user,
            password: password,
            host: host,
            port: port
        )
    }
    
    public func boot(_ drop: Droplet) {    }
    
    public func afterInit(_ drop: Droplet) {    }
    
    public func beforeRun(_ drop: Droplet) {    }
}
