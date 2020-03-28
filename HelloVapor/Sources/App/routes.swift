import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
	router.get("hello",use: hardCode)
	router.get("hello","vapor", use: queryed)
	router.get("hello",String.parameter, use: dynamicPath)
	router.post(InfoData.self,at:"info", use: handleJSON)
}

// MARK: - Route handler

public typealias ToResponse<T> = (Request) throws -> T
public typealias ContentHandler<T:Content,U:Content> = (Request,T) -> U

fileprivate let hardCode: ToResponse =  { req in
	return "Hello, world!"
}

fileprivate let queryed:ToResponse = { req in
	"hello, " +
		(req.query[String.self,at: "name"] ?? "Vapor")
}


fileprivate let dynamicPath: ToResponse = {
	req in
	"hello, " +
		((try? req.parameters.next(String.self)) ?? "P a t h")
}
fileprivate struct InfoData: Content {
 let name: String
}

fileprivate struct HelloResponse:Content {
	let code:Int
	let message:String
}

fileprivate let handleJSON:ContentHandler<InfoData,HelloResponse> = {
	(req, body) -> HelloResponse in
	let name = body.name
	return HelloResponse(code: 0, message: "hello, \(name)")
}
