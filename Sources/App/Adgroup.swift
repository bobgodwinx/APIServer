//
//  Adgroup.swift
//  APIServer
//
//  Created by Bob Godwin Obi on 12/13/16.
//
//
import Vapor
import Fluent
import Foundation

final class Adgroup: Model {
    
    var id: Node?
    var adgroupName: String
    var adgroupId: Int
    var exists: Bool = false
    var campaign_id: Node = 0
    
    init(adgroupName: String, adgroupId: Int) {
        self.adgroupName = adgroupName
        self.adgroupId = adgroupId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        adgroupName = try node.extract("adgroupName")
        adgroupId = try node.extract("adgroupId")
        campaign_id = try node.extract("campaign_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "adgroupName": adgroupName,
            "adgroupId": adgroupId,
            "campaign_id": campaign_id
            ])
    }
    static func prepare(_ database: Database) throws {
        try database.create("adgroups") { adgroup in
            adgroup.id()
            adgroup.string("adgroupName")
            adgroup.int("adgroupId")
            adgroup.parent(Campaign.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("adgroups")
    }
}
extension Adgroup {
    func campaign() throws -> Parent<Campaign> {
        return try parent(campaign_id)
    }
}
