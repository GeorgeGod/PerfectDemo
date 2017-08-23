import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectCrypto
import BCrypt
import Stencil
import PerfectLogger
import PerfectRequestLogger


// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		// Ensure that response.completed() is called when your processing is done.
		response.completed()
	}
}


//加密处理
func cryptoHandler(data: [String:Any]) -> RequestHandler {
    return {
        request, response in
        
        response.setHeader(.contentType, value: "text/html")
        
        
        let str = "Hello Swift"
        
        do {
            //hash字符串
            let digest = try BCrypt.Hash.make(message: str)
            let enstr = digest.makeString()
            print(digest.makeString());
            
            //验证字符串
            let res = try BCrypt.Hash.verify(message: str, matches: enstr)
            print("res:\(res)")
            
        } catch {
            
        }
        response.appendBody(string: "请求成功")
        
        response.completed()
    }
}

struct Article {
    let title : String
    let author : String
}
let context = [
    "articles" : [
        Article(title: "西游记", author: "施耐庵"),
        Article(title: "红楼梦", author: "曹雪芹")
    ]
]



func stencilHandler(data: [String:Any]) -> RequestHandler {
    return {
        request, response in
        
        //定义日志文件的目录
        LogFile.location = "./webroot/mylog.txt"
        
        //日志写入文件
        LogFile.debug("debug message")
        LogFile.info("info message")
        LogFile.warning("warning message")
        //terminal信息会使程序崩溃
//        LogFile.terminal("terminal message")
        
        
        
//        let server = HTTPServer()
//        let mylogger = RequestLogger()
//        server.setRequestFilters([(mylogger, .high)])
//        server.setResponseFilters([(mylogger, .low)])
        
        
        
        
//        let env = Environment(loader: FileSystemLoader(paths: ["./webroot/template.html"]))
        
        do {
            
//            //方式一
//            let environment = Environment()
//            let template = "Hello {{name}}"
//            let context = ["name": "George"]
//            let render = try environment.renderTemplate(string: template, context: context)
//            
//            
//            response.setHeader(.contentType, value: "text/html")
//            response.appendBody(string: render)
//            response.completed()

            
            //方式三
            /*
             加载html文件作为模版。
             paths: 文档的根目录
             */
            let environment = Environment(loader: FileSystemLoader(paths: ["./webroot"]))
//            let context = ["name": "George"]
            let render = try environment.renderTemplate(name: "template.html", context: context)
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: render)
            response.completed()
            
        } catch {
            response.setHeader(.contentType, value: "text/html")
            
            response.appendBody(string: "请求成功")
            
            response.completed()
        }
    }
}

// Configuration data for an example server.
// This example configuration shows how to launch a server
// using a configuration dictionary.

let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":8181,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
				["method":"get", "uri":"/crypto", "handler":cryptoHandler],
				["method":"get", "uri":"/stencil", "handler":stencilHandler],
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]

//do {
//	// Launch the servers based on the configuration data.
//	try HTTPServer.launch(configurationData: confData)
//} catch {
//	fatalError("\(error)") // fatal error launching one of the servers
//}




let server = HTTPServer()
var routes = Routes()

//server.addRoutes(routes)
server.serverPort = 8181
//
////笔记：设置文档的根目录，如果该目录不存在，就会自动创建该目录，目录名称可以是任意字符串
//server.documentRoot = "./webroot"

//笔记：当没有添加任何路由的时候，打开localhost:8081就会找./webroot文件夹下的index.html文件
routes.add(method: .get, uri: "/") { (request, response) in
    response.setHeader(.contentType, value: "text/html")
    
    let resDic = ["errcode":0, "errmsg":"请求成功"] as [String : Any];
    do {
        let str = try resDic.jsonEncodedString()
        response.appendBody(string: str)
        response.completed()
        
    } catch {
        
        response.appendBody(string: "错误啦")
        response.completed()
    }
}

routes.add(method: .get, uri: "/crypto") { (request, response) in
    
    response.setHeader(.contentType, value: "text/html")
    
    let str = "Hello Swift"
    let enstr = str.encode(.hex)
//    String(validatingUTF8: enstr) == 
    
    response.appendBody(string: "执行成功")
    
    response.completed()
}

routes.add(method: .get, uri: "/stencil") { (request, response) in
    
    
//    let server = HTTPServer()
    RequestLogFile.location = "./webroot/reqlog.txt"
    let mylogger = RequestLogger()
    
    server.setRequestFilters([(mylogger, .high)])
    server.setResponseFilters([(mylogger, .low)])
    
    
    response.setHeader(.contentType, value: "text/html")
//    response.setHeader(.contentEncoding, value: "utf-8")
    
    
    response.appendBody(string: "执行成功")
    
    response.completed()
}



server.addRoutes(routes)
//server.serverPort = 8181

//笔记：设置文档的根目录，如果该目录不存在，就会自动创建该目录，目录名称可以是任意字符串
server.documentRoot = "./webroot"

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("网络错误：\(err)\(msg)")
}







