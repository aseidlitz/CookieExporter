//
//  main.swift
//  CookieExporter
//  by alex@seidlitz.ca
//
//  Based on the code by Hendrik Grahl
//  https://www.grahl.ch/2016/10/09/export-cookies-from-safari-in-sierra/
//

import Foundation

let filename: URL = URL(string: "file://\(CommandLine.arguments[0])")!
let cmd = filename.lastPathComponent

func printUsage() {
        print("usage: \(cmd) http://cookie.domain.tld")
}

func errorBadArg(arg: String) {
    print("Can't parse cookie domain: \(arg)")
    printUsage()
}



guard CommandLine.arguments.count > 1 else {
    printUsage()
    exit(-1)
}
let urlString = CommandLine.arguments[1]
let storage = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: "Cookies")

guard let url = URL(string: urlString) else {
    errorBadArg(arg: urlString)
    exit(-1)
}
print("Fetching Cookies for URL: \(url.absoluteString)")

guard let cookies = storage.cookies(for: url) else {
    print("No cookies for \(url)")
    exit(-1)
}

print("# Netscape HTTP Cookie File\n\n")

for cookie in cookies {
    var secure = "FALSE"
    if (cookie.isSecure) {
        secure = "TRUE"
    }
    var expires:Int = Int(cookie.expiresDate!.timeIntervalSince1970)
    print("\(cookie.domain)\tTRUE\t\(cookie.path)\t\(secure)\t\(expires)\t\(cookie.name)\t\(cookie.value)")
}
