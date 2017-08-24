import PackageDescription

let package = Package(
	name: "PerfectDemo",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		
//		.Package(url:"https://github.com/PerfectlySoft/Perfect-Session.git", majorVersion: 0, minor: 0),
        
//        .Package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2),
        
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2, minor: 0),
        
        .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0, minor: 8),
        
//        .Package(url: "https://github.com/vapor/bcrypt.git", majorVersion: ),
        .Package(url: "https://github.com/vapor/random.git", majorVersion: 1),
        
        //majorVersion是必须的参数，不能少
        .Package(url: "https://github.com/vapor/bcrypt.git", majorVersion: 1),
        
        .Package(url: "https://github.com/PerfectlySoft/Perfect-SMTP.git", majorVersion: 1, minor: 0),
        
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 1),
        
//        .Package(url: "https://github.com/PerfectlySoft/Perfect-Crypto.git", majorVersion: 1),
        
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 1),
        
        
    ]
)


/*
 step1: swift build
 step2: swift package generate-xcodeproj
 */
