//
//  Campaign.swift
//  APIServer
//
//  Created by Bob Godwin Obi on 12/4/16.
//
//

import Vapor
import Fluent
import Foundation

final class Campaign: Model {
    var id: Node?
    var name: String
    var type: Int
    
    init(name: String, type: Int) {
        self.id = UUID().uuidString.makeNode()
        self.name = name
        self.type = type
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        type = try node.extract("type")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "type": type
            ])
    }
}

extension Campaign {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    public convenience init?(from string: String, type: Int) throws {
        self.init(name: "hello", type: 0)
    }
}

extension Campaign: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}
