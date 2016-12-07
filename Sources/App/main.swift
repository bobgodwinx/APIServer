import Vapor
import HTTP
import VaporMySQL

let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations = [Campaign.self, Post.self]

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

drop.post("campaign") { request in
    guard let campaignName = request.data["campaignName"]?.string,
        let campaignId = request.data["campaignId"]?.int else {
        return Abort.custom(status: .badRequest, message: "name or type badly specified") as! ResponseRepresentable
    }
    
    var campaign = Campaign(campaignName: campaignName, campaignId: campaignId)
    try campaign.save()
    return campaign
}

drop.run()
