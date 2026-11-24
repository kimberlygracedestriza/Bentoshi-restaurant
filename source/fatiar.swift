// Extract N evenly spaced frames as JPG with AVFoundation (ffmpeg stand-in).
// Usage: swift fatiar.swift <video> <outdir> <count> <maxWidth> <maxHeight> <quality 0-1>
import AVFoundation
import AppKit

let a = CommandLine.arguments
let asset = AVURLAsset(url: URL(fileURLWithPath: a[1]))
let out = URL(fileURLWithPath: a[2])
let count = Int(a[3])!
let size = CGSize(width: Double(a[4])!, height: Double(a[5])!)
let q = Double(a[6])!
try FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)

let gen = AVAssetImageGenerator(asset: asset)
gen.appliesPreferredTrackTransform = true
gen.requestedTimeToleranceBefore = .zero
gen.requestedTimeToleranceAfter = .zero
gen.maximumSize = size

let dur = CMTimeGetSeconds(asset.duration)
for i in 0..<count {
    let t = CMTime(seconds: dur * Double(i) / Double(count), preferredTimescale: 600)
    let img = try gen.copyCGImage(at: t, actualTime: nil)
    let rep = NSBitmapImageRep(cgImage: img)
    let data = rep.representation(using: .jpeg, properties: [.compressionFactor: q])!
    try data.write(to: out.appendingPathComponent(String(format: "f_%04d.jpg", i + 1)))
}
print("OK \(count) frames, \(Int(dur))s")
