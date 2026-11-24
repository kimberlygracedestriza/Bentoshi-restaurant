// Screenshot a page section with WebKit after scrolling to it.
// Usage: swift shot.swift <url> <width> <height> <outdir> <id1,id2,...>
import AppKit
import WebKit

let a = CommandLine.arguments
let url = URL(string: a[1])!
let w = CGFloat(Double(a[2])!), h = CGFloat(Double(a[3])!)
let out = a[4]
let ids = a[5].split(separator: ",").map(String.init)

let app = NSApplication.shared
let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: w, height: h), styleMask: [.borderless], backing: .buffered, defer: false)
let web = WKWebView(frame: NSRect(x: 0, y: 0, width: w, height: h))
win.contentView = web
app.setActivationPolicy(.accessory)
win.orderFrontRegardless()
web.load(URLRequest(url: url))

func wait(_ s: Double) { RunLoop.main.run(until: Date().addingTimeInterval(s)) }
wait(4)
for id in ids {
    let js = id == "top" ? "window.scrollTo(0,0)" :
        id.hasPrefix("y=") ? "window.scrollTo(0,\(id.dropFirst(2)))" :
        "document.documentElement.style.scrollBehavior='auto';document.querySelectorAll('.revelar').forEach(e=>e.classList.add('visto'));document.getElementById('\(id)').scrollIntoView()"
    web.evaluateJavaScript(js, completionHandler: nil)
    wait(2.5)
    var done = false
    web.takeSnapshot(with: nil) { img, _ in
        if let img = img, let tiff = img.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff),
           let png = rep.representation(using: .png, properties: [:]) {
            try? png.write(to: URL(fileURLWithPath: "\(out)/\(Int(w))-\(id).png"))
        }
        done = true
    }
    while !done { wait(0.1) }
}
print("OK")
