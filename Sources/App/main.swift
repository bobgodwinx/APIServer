import Vapor
import HTTP
import VaporMySQL

let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations = [Campaign.self, Post.self, Adgroup.self]

if let mysql = drop.database?.driver as? MySQLDriver {
    let version = try mysql.raw("SELECT @@version")
}

drop.get() { request in
    return try drop.view.make("welcome", [
    	"message": drop.localization[request.lang, "welcome", "title"]
    ])
}

drop.get("campaign") { request in
    guard let campaignId = request.data["campaignId"]?.string else {
        return try Campaign.all().makeNode().converted(to: JSON.self)
    }
    return try Campaign.query().filter("campaignId", .equals, campaignId).first()!.converted(to: JSON.self)
}

drop.get("campaignExtended") { request in
    guard let campaignId = request.data["campaignId"]?.string else {
        return Abort.custom(status: .badRequest, message: "name or type badly specified") as! ResponseRepresentable
    }
    let campaign = try! Campaign.query().filter("campaignId", .equals, campaignId).first()
    var result = try campaign!.converted(to: JSON.self)
    //var adgroups = try! campaign!.adgroups().all().makeNode().converted(to: JSON.self)
    //var adgroups = try! campaign!.adgroups().all().makeNode().converted(to: JSON.self)
    var adgroups = try Adgroup.query().filter("campaign_id", .equals, (campaign?.id)!).all().makeNode().converted(to: JSON.self)
    result["adgroups"] = adgroups
    return result
}

drop.post("campaign") { request in
    guard let campaignName = request.data["campaignName"]?.string,
        let campaignId = request.data["campaignId"]?.int else {
        return Abort.custom(status: .badRequest, message: "name or type badly specified") as! ResponseRepresentable
    }
    
    var campaign = Campaign(campaignName: campaignName, campaignId: campaignId)
    try campaign.save()
    
//    var adgroup = Adgroup(adgroupName: "myAdgroup", adgroupId: 224242)
//    adgroup.campaign_id = Node(campaign.campaignId)
//    try adgroup.save()
    
    return campaign
}

drop.post("adgroup") { request in
    
    guard let adgroupName = request.data["adgroupName"]?.string,
        let campaignId = request.data["campaignId"]?.int,
        let adgroupId = request.data["adgroupId"]?.int else {
        return Abort.badRequest as! ResponseRepresentable
    }
    let campaign = try Campaign.query().filter("campaignId", .equals, campaignId).first()!
    var adgroup = Adgroup(adgroupName: adgroupName, adgroupId: adgroupId)
    adgroup.campaign_id = campaign.id!
    try adgroup.save()
    return adgroup
}



drop.get("adgroup") { request in
    guard let adgroupId = request.data["adgroupId"]?.string else {
        return try Adgroup.all().makeNode().converted(to: JSON.self)
    }
    return try Adgroup.query().filter("adgroupId", .equals, adgroupId).first()!.converted(to: JSON.self)
}



drop.run()
