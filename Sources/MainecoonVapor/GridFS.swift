import MongoKitten
import Vapor

extension MongoKitten.GridFS {
    public func store(multipartFile file: Multipart.File) throws -> ObjectId {
        return try self.store(data: file.data, named: file.name, withType: file.type)
    }
}
