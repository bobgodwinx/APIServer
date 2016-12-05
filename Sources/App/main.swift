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

drop.resource("posts", PostController())

drop.post("user") { request in
    guard let name = request.data["name"]?.string else {
        return Abort.badRequest as! ResponseRepresentable
    }
    return name
}

drop.post("campaign") { request in
    guard let name = request.data["name"]?.string,
        let type = request.data["type"]?.int else {
        return Abort.custom(status: .badRequest, message: "name or type badly specified") as! ResponseRepresentable
    }
    
    var campaign = Campaign(name: name, type: type)
    try campaign.save()
    return campaign
}

drop.run()
