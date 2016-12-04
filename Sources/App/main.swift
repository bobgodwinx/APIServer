import Vapor
import HTTP
import VaporMySQL


//let drop = Droplet()
//let mysql = try VaporMySQL.Provider(host: "localhost", user: "apiserver", password: "apiServer#386", database: "apiserver")
//try drop.addProvider(mysql)

//try drop.addProvider(VaporMySQL.Provider.self)
//try drop.preparations([Campaign.self])
let drop = Droplet(preparations:[Campaign.self], providers:[VaporMySQL.Provider.self])

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
        return Abort.badRequest as! ResponseRepresentable
    }
    
    let campaign = Campaign(name: name, type: type)
    return campaign
}


drop.run()
