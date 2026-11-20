// duo-webshot: draws a page from this computer's own web server in this Mac's WebKit (Safari's
// engine) at set window sizes, runs a make-it-fold scenario's actions, and saves pictures. Nothing
// to install: duo-shot compiles this file once with the Swift compiler that comes with Xcode.
// It is the engine behind `duo-shot phone` and the picture comparison in `duo-shot compare`.
//
//   duo-webshot shoot <job.json>                 one JSON line per picture, per problem, then {"event":"done"}
//   duo-webshot diff <a.png> <b.png> <diff.png>  {"total":n,"changed":n,"box":[x,y,w,h] or null,"sizes":"..."}
//
// job.json: {"base": "http://localhost:8765", "paths": ["/"], "steps": {"/": [...]}, "out": "<folder>",
//            "sizes": [{"name": "phone", "w": 390, "h": 844, "ua": "<user agent or empty>"}]}
// Scenario actions used: name, tap, type, wait. A picture is taken when each path has loaded, and once
// for each named state (at the first "pose" step after the "name", or at the end). "pose" and the
// "expect_*" checks belong to the Duo's fold positions and are skipped here.
import AppKit
import ImageIO
import UniformTypeIdentifiers
import WebKit

struct Fail: Error { let detail: String }

func emit(_ obj: [String: Any]) {
    if let d = try? JSONSerialization.data(withJSONObject: obj, options: [.sortedKeys]), let s = String(data: d, encoding: .utf8) {
        print(s)
        fflush(stdout)
    }
}

let tracing = ProcessInfo.processInfo.environment["DUO_WEBSHOT_TRACE"] != nil
func trace(_ s: String) { if tracing { FileHandle.standardError.write("duo-webshot: \(s)\n".data(using: .utf8)!) } }

func savePNG(_ img: CGImage, _ path: String) throws {
    let url = URL(fileURLWithPath: path)
    guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        throw Fail(detail: "could not write \(path)")
    }
    CGImageDestinationAddImage(dest, img, nil)
    if !CGImageDestinationFinalize(dest) { throw Fail(detail: "could not write \(path)") }
}

func loadPNG(_ path: String) throws -> CGImage {
    guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil),
          let img = CGImageSourceCreateImageAtIndex(src, 0, nil) else { throw Fail(detail: "could not read \(path)") }
    return img
}

func rgba(_ img: CGImage) -> [UInt8] {
    let w = img.width, h = img.height
    var buf = [UInt8](repeating: 0, count: w * h * 4)
    let ctx = CGContext(data: &buf, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                        space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.draw(img, in: CGRect(x: 0, y: 0, width: w, height: h))
    return buf
}

// Two pictures, pixel by pixel. A pixel counts as changed when any color channel moved by more than 8 of 255.
func diff(_ a: String, _ b: String, _ out: String) throws {
    let ia = try loadPNG(a), ib = try loadPNG(b)
    if ia.width != ib.width || ia.height != ib.height {
        emit(["total": ib.width * ib.height, "changed": ib.width * ib.height, "box": NSNull(),
              "sizes": "\(ia.width) x \(ia.height) before, \(ib.width) x \(ib.height) after"])
        return
    }
    let w = ia.width, h = ia.height
    let pa = rgba(ia), pb = rgba(ib)
    var marked = [UInt8](repeating: 0, count: w * h * 4)
    var changed = 0, minX = w, minY = h, maxX = -1, maxY = -1
    for y in 0..<h {
        for x in 0..<w {
            let i = (y * w + x) * 4
            let moved = max(abs(Int(pa[i]) - Int(pb[i])), abs(Int(pa[i + 1]) - Int(pb[i + 1])), abs(Int(pa[i + 2]) - Int(pb[i + 2])))
            if moved > 8 {
                changed += 1
                minX = min(minX, x); minY = min(minY, y); maxX = max(maxX, x); maxY = max(maxY, y)
                marked[i] = 230; marked[i + 1] = 30; marked[i + 2] = 30; marked[i + 3] = 255
            } else {  // the "after" picture, faded, so the red marks stand out
                for c in 0..<3 { marked[i + c] = UInt8(min(255, 178 + Int(pb[i + c]) * 77 / 255)) }
                marked[i + 3] = 255
            }
        }
    }
    if changed > 0 {
        let ctx = CGContext(data: &marked, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                            space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        try savePNG(ctx.makeImage()!, out)
    }
    emit(["total": w * h, "changed": changed, "sizes": "same",
          "box": changed > 0 ? [minX, minY, maxX - minX + 1, maxY - minY + 1] : NSNull()])
}

let helpers = """
window.__duoWeb = {
  async settle(maxMs) {
    try { await document.fonts.ready; } catch (e) {}
    const t0 = performance.now();
    while (performance.now() - t0 < maxMs) {
      const busy = document.getAnimations().filter(a => a.playState === 'running' &&
        (a.effect && a.effect.getComputedTiming && a.effect.getComputedTiming().iterations !== Infinity));
      const imgs = Array.from(document.images).filter(i => !i.complete);
      if (!busy.length && !imgs.length) break;
      await new Promise(r => setTimeout(r, 100));
    }
    // Endless animations (spinners) are stopped at their first frame so two pictures can match.
    for (const a of document.getAnimations()) {
      if (a.effect && a.effect.getComputedTiming && a.effect.getComputedTiming().iterations === Infinity) { a.pause(); a.currentTime = 0; }
    }
    if (document.activeElement && document.activeElement !== document.body) document.activeElement.blur();
    await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
    return true;
  },
  tap(sel) {
    const el = document.querySelector(sel);
    if (!el) return {found: false};
    el.scrollIntoView({block: 'center', inline: 'center'});
    const r = el.getBoundingClientRect();
    const x = r.left + r.width / 2, y = r.top + r.height / 2;
    const top = document.elementFromPoint(x, y) || el;
    const o = {bubbles: true, cancelable: true, composed: true, clientX: x, clientY: y, view: window, pointerType: 'touch', isPrimary: true};
    for (const [kind, E] of [['pointerdown', PointerEvent], ['mousedown', MouseEvent], ['pointerup', PointerEvent], ['mouseup', MouseEvent]]) {
      top.dispatchEvent(new E(kind, o));
    }
    top.click();
    const covered = !(top === el || el.contains(top));
    return {found: true, covered, coveredBy: covered ? (top.tagName.toLowerCase() + (top.id ? '#' + top.id : '')) : null};
  },
  type(sel, text) {
    const el = document.querySelector(sel);
    if (!el) return {found: false};
    el.focus();
    const proto = el instanceof HTMLTextAreaElement ? HTMLTextAreaElement.prototype :
                  el instanceof HTMLSelectElement ? HTMLSelectElement.prototype : HTMLInputElement.prototype;
    const set = Object.getOwnPropertyDescriptor(proto, 'value');
    if (set && set.set) set.set.call(el, text); else el.value = text;
    el.dispatchEvent(new Event('input', {bubbles: true}));
    el.dispatchEvent(new Event('change', {bubbles: true}));
    el.blur();
    return {found: true};
  },
  page() {
    const d = document.documentElement;
    return {scrollHeight: Math.max(d.scrollHeight, document.body ? document.body.scrollHeight : 0),
            innerWidth: window.innerWidth, innerHeight: window.innerHeight, scrollY: window.scrollY,
            sideways: d.scrollWidth > window.innerWidth + 1};
  }
};
true;
"""

@MainActor
final class Shooter: NSObject, WKNavigationDelegate {
    var waiting: CheckedContinuation<Void, Error>?
    var status = 0

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        if navigationResponse.isForMainFrame, let r = navigationResponse.response as? HTTPURLResponse { status = r.statusCode }
        return .allow
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { finish(nil) }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { finish(error) }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { finish(error) }
    func finish(_ error: Error?) {
        guard let w = waiting else { return }
        waiting = nil
        if let e = error { w.resume(throwing: e) } else { w.resume() }
    }

    func load(_ web: WKWebView, _ url: URL) async throws {
        status = 0
        let timer = Task { @MainActor in
            try await Task.sleep(nanoseconds: 30_000_000_000)
            self.finish(Fail(detail: "\(url.absoluteString) did not finish loading within 30 seconds"))
        }
        defer { timer.cancel() }
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            waiting = c
            web.load(URLRequest(url: url))
        }
    }

    func js(_ web: WKWebView, _ body: String, _ args: [String: Any] = [:]) async throws -> Any? {
        try await web.callAsyncJavaScript(body, arguments: args, in: nil, contentWorld: .page)
    }

    func settle(_ web: WKWebView, _ ms: Int = 4000) async throws {
        _ = try await js(web, "return await window.__duoWeb.settle(ms);", ["ms": ms])
    }

    func snap(_ web: WKWebView) async throws -> CGImage {
        let cfg = WKSnapshotConfiguration()
        cfg.afterScreenUpdates = true
        let img = try await web.takeSnapshot(configuration: cfg)
        guard let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { throw Fail(detail: "the picture came back empty") }
        return cg
    }

    // What a person sees: the first screen, then one more picture per further screenful when the page
    // scrolls (each as a person would see it, fixed bars included), at most 10 screens.
    func picture(_ web: WKWebView, name: String, size: String, w: Int, h: Int, out: String, path: String, screen: String) async throws {
        trace("picture \(name): settling")
        try await settle(web)
        guard let page = try await js(web, "return window.__duoWeb.page();") as? [String: Any] else { throw Fail(detail: "the page did not answer") }
        let pageHeight = (page["scrollHeight"] as? NSNumber)?.intValue ?? h
        let startY = (page["scrollY"] as? NSNumber)?.intValue ?? 0
        _ = try await js(web, "window.scrollTo(0, 0); return true;")
        try await settle(web, 1000)
        let first = try await snap(web)
        trace("picture \(name): \(first.width) x \(first.height), page \(pageHeight) high")
        let file = "shots/\(name).png"
        try savePNG(first, "\(out)/\(file)")
        var scrolls: [String] = []
        if pageHeight > h + 1 {
            var y = h, k = 2
            while k <= 10 {
                _ = try await js(web, "window.scrollTo(0, y); return true;", ["y": y])
                try await settle(web, 1000)
                let at = ((try await js(web, "return window.scrollY;")) as? NSNumber)?.intValue ?? y
                let f = "shots/\(name)-scroll\(k).png"
                try savePNG(try await snap(web), "\(out)/\(f)")
                scrolls.append(f)
                if at < y || at + h >= pageHeight { break }  // the bottom of the page
                y += h; k += 1
            }
        }
        _ = try await js(web, "window.scrollTo(0, y); return true;", ["y": startY])
        var row: [String: Any] = ["event": "shot", "path": path, "screen": screen, "size": size, "file": file, "scrolls": scrolls,
                                  "w": w, "h": h, "pixels": "\(first.width) x \(first.height)", "pageHeight": pageHeight]
        if (page["sideways"] as? Bool) == true { row["sidewaysScroll"] = true }
        emit(row)
    }

    func shoot(_ jobPath: String) async throws {
        guard let job = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: jobPath))) as? [String: Any],
              let base = job["base"] as? String, let out = job["out"] as? String,
              let sizes = job["sizes"] as? [[String: Any]], let paths = job["paths"] as? [String] else {
            throw Fail(detail: "the job file is not in the expected shape")
        }
        let steps = job["steps"] as? [String: [[String: Any]]] ?? [:]
        try FileManager.default.createDirectory(atPath: "\(out)/shots", withIntermediateDirectories: true)
        let slug = { (s: String) in s.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: " ", with: "_") }
        for size in sizes {
            guard let sname = size["name"] as? String, let w = (size["w"] as? NSNumber)?.intValue,
                  let h = (size["h"] as? NSNumber)?.intValue else { throw Fail(detail: "a size is missing its name, w or h") }
            for path in paths {
                guard let url = URL(string: base + path) else { throw Fail(detail: "bad address \(base + path)") }
                let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: w, height: h), styleMask: [.borderless],
                                   backing: .buffered, defer: false)
                win.isReleasedWhenClosed = false
                win.alphaValue = 0.0          // drawn, never seen
                win.ignoresMouseEvents = true
                let cfg = WKWebViewConfiguration()
                cfg.websiteDataStore = .nonPersistent()  // every size starts like a first visit; nothing is kept
                let web = WKWebView(frame: NSRect(x: 0, y: 0, width: w, height: h), configuration: cfg)
                // The window is never shown, so WebKit would treat the page as hidden and stop drawing
                // (no animation frames, no pictures). Tell it to ignore whether the window can be seen.
                let occlusion = NSSelectorFromString("_setWindowOcclusionDetectionEnabled:")
                if web.responds(to: occlusion) { web.perform(occlusion, with: false) }
                if let ua = size["ua"] as? String, !ua.isEmpty { web.customUserAgent = ua }
                web.navigationDelegate = self
                win.contentView = web
                win.orderBack(nil)
                defer { win.orderOut(nil); win.close() }
                trace("loading \(url.absoluteString) at \(w) x \(h)")
                try await load(web, url)
                trace("loaded (HTTP \(status))")
                if status >= 400 { emit(["event": "problem", "path": path, "size": sname, "detail": "the server answered \(status) for \(path)"]) }
                _ = try await web.evaluateJavaScript(helpers)
                try await picture(web, name: "\(slug(path))-\(sname)", size: sname, w: w, h: h, out: out, path: path, screen: path)
                var state: String? = nil, pending = false
                for (i, step) in (steps[path] ?? []).enumerated() {
                    guard let (op, arg) = step.first.map({ ($0.key, $0.value) }) else { continue }
                    switch op {
                    case "name":
                        state = "\(arg)"; pending = true
                    case "pose":
                        if pending, let s = state {
                            try await picture(web, name: "\(slug(path))-\(slug(s))-\(sname)", size: sname, w: w, h: h, out: out,
                                              path: path, screen: "\(path) \(s)")
                            pending = false
                        }
                    case "tap":
                        let r = try await js(web, "return window.__duoWeb.tap(sel);", ["sel": "\(arg)"]) as? [String: Any] ?? [:]
                        if (r["found"] as? Bool) != true {
                            emit(["event": "problem", "path": path, "size": sname, "detail": "step \(i + 1): nothing to tap matches \(arg)"])
                        } else if (r["covered"] as? Bool) == true {
                            emit(["event": "problem", "path": path, "size": sname,
                                  "detail": "step \(i + 1): \(arg) is covered by \(r["coveredBy"] ?? "something") (the tap went to that)"])
                        }
                        try await settle(web)
                    case "type":
                        if let a = arg as? [Any], a.count == 2 {
                            let r = try await js(web, "return window.__duoWeb.type(sel, text);", ["sel": "\(a[0])", "text": "\(a[1])"]) as? [String: Any] ?? [:]
                            if (r["found"] as? Bool) != true {
                                emit(["event": "problem", "path": path, "size": sname, "detail": "step \(i + 1): no field matches \(a[0])"])
                            }
                        }
                    case "wait":
                        let s = (arg as? NSNumber)?.doubleValue ?? Double("\(arg)") ?? 0
                        try await Task.sleep(nanoseconds: UInt64(max(0, min(s, 30)) * 1_000_000_000))
                    default:
                        break  // expect_* and anything else belong to the Duo's poses
                    }
                }
                if pending, let s = state {
                    try await picture(web, name: "\(slug(path))-\(slug(s))-\(sname)", size: sname, w: w, h: h, out: out,
                                      path: path, screen: "\(path) \(s)")
                }
            }
        }
        emit(["event": "done"])
    }
}

let args = CommandLine.arguments
if args.count == 5 && args[1] == "diff" {
    do { try diff(args[2], args[3], args[4]); exit(0) } catch let e as Fail { emit(["event": "error", "detail": e.detail]); exit(2) }
    catch { emit(["event": "error", "detail": "\(error)"]); exit(2) }
}
guard args.count == 3 && args[1] == "shoot" else {
    FileHandle.standardError.write("usage: duo-webshot shoot <job.json> | duo-webshot diff <a.png> <b.png> <diff.png>\n".data(using: .utf8)!)
    exit(2)
}
let app = NSApplication.shared
app.setActivationPolicy(.accessory)  // no Dock icon, never takes the keyboard
Task { @MainActor in
    do { try await Shooter().shoot(args[2]); exit(0) }
    catch let e as Fail { emit(["event": "error", "detail": e.detail]); exit(2) }
    catch { emit(["event": "error", "detail": error.localizedDescription]); exit(2) }
}
app.run()
