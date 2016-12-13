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
    var campaignName: String
    var campaignId: Int
    var exists: Bool = false
    
    init(campaignName: String, campaignId: Int) {
        self.campaignName = campaignName
        self.campaignId = campaignId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        campaignName = try node.extract("campaignName")
        campaignId = try node.extract("campaignId")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "campaignName": campaignName,
            "campaignId": campaignId
            ])
    }
    static func prepare(_ database: Database) throws {
        try database.create("campaigns") { campaign in
            campaign.id()
            campaign.string("campaignName")
            campaign.int("campaignId")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("campaigns")
    }
}

extension Campaign {
    func adgroups() throws -> Parent<Adgroup> {
        return try parent(self.id!)
    }
}

