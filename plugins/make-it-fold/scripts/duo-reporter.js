// duo-reporter: injected into pages by duo-listen (proxy mode) during a Duo check.
// It never ships with the app. It reports what the page sees after every resize and answers
// small questions from duo-shot (where is this element, is it covered, what is its value).
(function () {
  if (window.__duoReporter) return;
  window.__duoReporter = true;
  if (!window.__duoMarker) window.__duoMarker = Date.now() + "-" + Math.random().toString(36).slice(2);

  function insetProbe() {
    var d = document.createElement("div");
    d.style.cssText = "position:fixed;visibility:hidden;pointer-events:none;top:0;left:0;" +
      "padding:env(safe-area-inset-top) env(safe-area-inset-right) env(safe-area-inset-bottom) env(safe-area-inset-left)";
    document.documentElement.appendChild(d);
    var s = getComputedStyle(d);
    var r = { top: parseFloat(s.paddingTop), right: parseFloat(s.paddingRight),
              bottom: parseFloat(s.paddingBottom), left: parseFloat(s.paddingLeft) };
    d.remove();
    return r;
  }
  function unit(u) {
    var d = document.createElement("div");
    d.style.cssText = "position:fixed;visibility:hidden;pointer-events:none;top:0;left:0;width:0;height:100" + u;
    document.documentElement.appendChild(d);
    var h = Math.round(d.getBoundingClientRect().height);
    d.remove();
    return h;
  }
  function describe(el) {
    if (!el || !el.tagName) return null;
    var s = el.tagName.toLowerCase();
    if (el.id) s += "#" + el.id;
    else if (el.className && typeof el.className === "string") s += "." + el.className.trim().split(/\s+/).slice(0, 2).join(".");
    var t = (el.innerText || el.value || el.getAttribute("aria-label") || "").trim().replace(/\s+/g, " ").slice(0, 40);
    return t ? s + ' "' + t + '"' : s;
  }
  function visible(el) {
    var cs = getComputedStyle(el);
    if (cs.display === "none" || cs.visibility === "hidden" || parseFloat(cs.opacity) === 0) return false;
    var r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0;
  }
  // True when wide content sits in its OWN sideways-scrolling box (a deliberate, correct fix),
  // not in a big container that scrolls everything sideways (header, form and all).
  function ownScroller(el) {
    var h = el.getBoundingClientRect().height;
    for (var p = el.parentElement, i = 0; p && p !== document.body && i < 4; p = p.parentElement, i++) {
      var ox = getComputedStyle(p).overflowX;
      if (ox === "auto" || ox === "scroll") {
        return p.getBoundingClientRect().height <= h + 40;
      }
    }
    return false;
  }
  // Problems a fold commonly causes, measured from inside the page.
  function issues() {
    var out = [], W = innerWidth, H = innerHeight, ins = insetProbe();
    var sw = Math.max(document.documentElement.scrollWidth, document.body ? document.body.scrollWidth : 0);
    if (sw > W + 1) {
      var wide = [];
      document.querySelectorAll("body *").forEach(function (el) {
        if (wide.length >= 5 || !visible(el)) return;
        var r = el.getBoundingClientRect();
        if (r.right > W + 1 && r.width <= sw) {
          var p = el.parentElement, parentWide = p && p.getBoundingClientRect().right > W + 1 && p !== document.body;
          if (!parentWide) wide.push(describe(el) + " right edge " + Math.round(r.right) + "px");
        }
      });
      out.push({ kind: "sideways-scroll", detail: "page is " + sw + "px wide in a " + W + "px viewport", offenders: wide });
    }
    // Content wider than the screen, even when a box scrolls it sideways (the page itself may not).
    var wideSeen = 0;
    document.querySelectorAll("table, pre, img, video, canvas, iframe, svg, [style*=width], main *, section > *").forEach(function (el) {
      if (wideSeen >= 3 || !visible(el)) return;
      var w = el.getBoundingClientRect().width;
      if (w > W + 1 && el.parentElement && el.parentElement.getBoundingClientRect().width <= W + 1 && !ownScroller(el)) {
        wideSeen++;
        out.push({ kind: "wider-than-screen", detail: describe(el) + " is " + Math.round(w) + "px wide on a " + W + "px screen (part of it is cut off or scrolls sideways)" });
      }
    });
    // Screens sized with 100vh are taller than what Safari shows while its toolbar is visible.
    var lv = unit("lvh");
    if (lv > H + 1) {
      var tall = 0;
      document.querySelectorAll("body, body > *, body > * > *").forEach(function (el) {
        if (tall >= 2 || !visible(el)) return;
        var h = Math.round(el.getBoundingClientRect().height);
        if (Math.abs(h - lv) <= 1 && h > H + 1) {
          tall++;
          out.push({ kind: "taller-than-visible", detail: describe(el) + " is " + h + "px tall but only " + H + "px is visible (100vh?): the bottom " + (h - H) + "px hides behind the toolbar" });
        }
      });
    }
    document.querySelectorAll("body *").forEach(function (el) {
      var cs = getComputedStyle(el);
      if ((cs.position !== "fixed" && cs.position !== "sticky") || !visible(el)) return;
      var box = el.getBoundingClientRect();
      if (box.width < 8 || box.height < 8) return;
      // A pinned bar's background may run to the edge (that is right); its controls may not.
      var ctrls = el.matches("a,button,input,select,textarea,[role=button]") ? [el]
        : Array.prototype.slice.call(el.querySelectorAll("a,button,input,select,textarea,[role=button]")).filter(visible);
      if (!ctrls.length) return;
      var r = { left: Infinity, top: Infinity, right: -Infinity, bottom: -Infinity };
      ctrls.forEach(function (c) {
        var q = c.getBoundingClientRect();
        r.left = Math.min(r.left, q.left); r.top = Math.min(r.top, q.top);
        r.right = Math.max(r.right, q.right); r.bottom = Math.max(r.bottom, q.bottom);
      });
      var bad = [];
      if (ins.left > 0 && r.left < ins.left) bad.push("under the left safe area (" + ins.left + "px)");
      if (ins.right > 0 && r.right > W - ins.right) bad.push("under the right safe area (" + ins.right + "px)");
      if (ins.bottom > 0 && r.bottom > H - ins.bottom) bad.push("under the bottom safe area (" + ins.bottom + "px)");
      if (ins.top > 0 && r.top < ins.top) bad.push("under the top safe area (" + ins.top + "px)");
      if (r.bottom > H + 1) bad.push("pinned bar extends below the visible area (bottom " + Math.round(r.bottom) + " > " + H + ")");
      if (bad.length) out.push({ kind: "pinned-control-in-unsafe-area", detail: describe(el) + " (its buttons/fields): " + bad.join("; ") });
    });
    document.querySelectorAll("input:not([type=hidden]):not([type=checkbox]):not([type=radio]),textarea,select").forEach(function (el) {
      if (!visible(el)) return;
      var fs = parseFloat(getComputedStyle(el).fontSize);
      if (fs < 16) out.push({ kind: "input-zoom", detail: describe(el) + " has font-size " + fs + "px (< 16px makes Safari zoom on tap)" });
    });
    return out;
  }
  // Design notes: prompts for the design review, measured from inside the page. They are NOT
  // failures and never change duo-shot's exit code. A person (or agent) looks at the picture and decides.
  function design() {
    var out = [], W = innerWidth, H = innerHeight, wide = W >= 600;
    function onScreen(r) { return r.bottom > 0 && r.top < H && r.right > 0 && r.left < W; }
    var stretched = [];
    document.querySelectorAll("button, input:not([type=hidden]):not([type=range]), select, textarea, [role=button]").forEach(function (el) {
      if (stretched.length >= 4 || !visible(el)) return;
      var r = el.getBoundingClientRect();
      if (r.width > 560 && onScreen(r)) stretched.push(describe(el) + " (" + Math.round(r.width) + "px wide)");
    });
    if (stretched.length) out.push({ kind: "stretched-control", detail: "controls wider than a phone would make them: " + stretched.join("; ") });
    var longLines = [];
    document.querySelectorAll("p, li, dd, blockquote, td").forEach(function (el) {
      if (longLines.length >= 2 || !visible(el)) return;
      var text = (el.innerText || "").trim();
      if (text.length < 96) return;
      var r = el.getBoundingClientRect(), fs = parseFloat(getComputedStyle(el).fontSize) || 16;
      var perLine = Math.round(Math.min(text.length, r.width / (fs * 0.5)));
      if (perLine > 95 && onScreen(r)) longLines.push(describe(el).slice(0, 50) + " runs about " + perLine + " characters a line");
    });
    if (longLines.length) out.push({ kind: "long-lines", detail: "text is hard to read past about 90 characters a line: " + longLines.join("; ") });
    if (wide) {
      // Is anything side by side? Look for two sizeable blocks that share a row.
      var blocks = [];
      (function walk(el, depth) {
        if (depth > 7 || blocks.length >= 160) return;
        for (var c = el.firstElementChild; c; c = c.nextElementSibling) {
          if (c.id === "__duo_glass" || !visible(c)) continue;
          var r = c.getBoundingClientRect();
          if (r.width >= 170 && r.height >= 110 && onScreen(r)) blocks.push({ el: c, r: r });
          walk(c, depth + 1);
        }
      })(document.body, 0);
      var sideBySide = false;
      for (var i = 0; i < blocks.length && !sideBySide; i++) {
        for (var j = 0; j < blocks.length; j++) {
          var a = blocks[i], b = blocks[j];
          if (a === b || a.el.contains(b.el) || b.el.contains(a.el)) continue;
          var overlapY = Math.min(a.r.bottom, b.r.bottom) - Math.max(a.r.top, b.r.top);
          if (a.r.right <= b.r.left + 1 && overlapY >= 60) { sideBySide = true; break; }
        }
      }
      if (!sideBySide) out.push({ kind: "one-column-on-wide-screen", detail: "at " + W + "px wide everything is still in one column; the inner screen has room for a second pane or more columns" });
      var left = Infinity, right = -Infinity;
      document.querySelectorAll("p, h1, h2, h3, li, td, th, img, button, input, select, textarea, label, a, canvas, svg, video").forEach(function (el) {
        if (!visible(el)) return;
        var r = el.getBoundingClientRect();
        if (!onScreen(r) || r.width < 4) return;
        left = Math.min(left, Math.max(0, r.left)); right = Math.max(right, Math.min(W, r.right));
      });
      if (right > left) {
        var used = Math.round(100 * (right - left) / W);
        if (used < 60) out.push({ kind: "unused-width", detail: "content uses only " + used + "% of the " + W + "px width; the rest is empty" });
      }
    }
    var small = [];
    document.querySelectorAll("button, [role=button], input[type=checkbox], input[type=radio], select, a").forEach(function (el) {
      if (!visible(el)) return;
      if (el.tagName === "A" && getComputedStyle(el).display === "inline" && el.closest("p, li, td, dd, span")) return;
      var r = el.getBoundingClientRect();
      if (onScreen(r) && (r.width < 43 || r.height < 43)) small.push(describe(el) + " (" + Math.round(r.width) + " x " + Math.round(r.height) + ")");
    });
    if (small.length) out.push({ kind: "small-touch-target", detail: small.length + " control" + (small.length === 1 ? "" : "s") + " under 44 x 44: " + small.slice(0, 3).join("; ") });
    return out;
  }
  function fonts() {
    function size(sel) { var e = document.querySelector(sel); return e && visible(e) ? parseFloat(getComputedStyle(e).fontSize) : null; }
    // The longest visible block of text: Safari's own text enlarging hits wide paragraphs first.
    var longest = null, len = 0;
    document.querySelectorAll("p, li, td, dd, blockquote").forEach(function (e) {
      var n = (e.innerText || "").length;
      if (n > len && visible(e)) { longest = e; len = n; }
    });
    return { body: parseFloat(getComputedStyle(document.body).fontSize), heading: size("h1, h2"), button: size("button, [role=button]"),
             text: size("p, li, td"), paragraph: longest ? parseFloat(getComputedStyle(longest).fontSize) : null };
  }
  function read(reason) {
    return {
      reason: reason, marker: window.__duoMarker, url: location.pathname + location.search, time: Date.now(),
      innerWidth: innerWidth, innerHeight: innerHeight,
      visualViewport: window.visualViewport ? [Math.round(visualViewport.width), Math.round(visualViewport.height), Math.round(visualViewport.offsetTop)] : null,
      svh: unit("svh"), dvh: unit("dvh"), lvh: unit("lvh"), inset: insetProbe(),
      scroll: [Math.round(scrollX), Math.round(scrollY)],
      active: describe(document.activeElement), userAgent: navigator.userAgent,
      issues: issues(), design: design(), fonts: fonts(), lastClick: window.__duoLastClick || null
    };
  }
  function post(path, body) {
    return fetch(path, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) })
      .catch(function () {});
  }
  function report(reason) { post("/__duo/report", read(reason)); }
  var t;
  function soon(reason) { clearTimeout(t); t = setTimeout(function () { report(reason); }, 300); }
  addEventListener("resize", function () { soon("resize"); });
  if (window.visualViewport) visualViewport.addEventListener("resize", function () { soon("visual-resize"); });
  addEventListener("pageshow", function (e) { report(e.persisted ? "pageshow-cached" : "load"); });
  document.addEventListener("click", function (e) {
    window.__duoLastClick = { clientX: Math.round(e.clientX), clientY: Math.round(e.clientY), target: describe(e.target) };
  }, true);

  // Commands from duo-shot.
  function el(sel) { try { return document.querySelector(sel); } catch (e) { return null; } }
  var ops = {
    report: function () { return read("asked"); },
    rect: function (c) {
      var e = el(c.selector);
      if (!e) return { found: false };
      if (c.scroll) e.scrollIntoView({ block: "center", inline: "center" });
      var r = e.getBoundingClientRect(), cx = r.left + r.width / 2, cy = r.top + r.height / 2;
      var hit = document.elementFromPoint(cx, cy);
      return { found: true, visible: visible(e), x: r.left, y: r.top, w: r.width, h: r.height, cx: cx, cy: cy,
               inViewport: r.right > 0 && r.bottom > 0 && r.left < innerWidth && r.top < innerHeight,
               covered: !!(hit && hit !== e && !e.contains(hit)), coveredBy: hit && hit !== e && !e.contains(hit) ? describe(hit) : null };
    },
    value: function (c) { var e = el(c.selector); return e ? { found: true, value: e.value !== undefined ? e.value : e.innerText } : { found: false }; },
    setValue: function (c) {
      var e = el(c.selector); if (!e) return { found: false };
      var proto = e.tagName === "TEXTAREA" ? HTMLTextAreaElement.prototype : HTMLInputElement.prototype;
      var setter = Object.getOwnPropertyDescriptor(proto, "value").set;
      setter.call(e, c.text);
      e.dispatchEvent(new Event("input", { bubbles: true }));
      e.dispatchEvent(new Event("change", { bubbles: true }));
      return { found: true };
    },
    text: function (c) { return { found: document.body.innerText.indexOf(c.text) >= 0 }; },
    // A full-screen glass pane that swallows one tap, so duo-shot can learn where page
    // coordinates sit on the screen without pressing anything in the app.
    calibrate: function () {
      var g = document.getElementById("__duo_glass");
      if (!g) {
        g = document.createElement("div");
        g.id = "__duo_glass";
        g.style.cssText = "position:fixed;inset:0;z-index:2147483647;background:transparent;";
        g.addEventListener("click", function (e) {
          e.preventDefault(); e.stopPropagation();
          window.__duoCalib = { clientX: e.clientX, clientY: e.clientY };
          g.remove();
        }, true);
        document.documentElement.appendChild(g);
      }
      window.__duoCalib = null;
      return { armed: true };
    },
    calibration: function () { return { calib: window.__duoCalib || null }; }
  };
  function poll() {
    fetch("/__duo/cmd?marker=" + encodeURIComponent(window.__duoMarker), { cache: "no-store" })
      .then(function (r) { return r.status === 200 ? r.json() : null; })
      .then(function (c) {
        if (c && ops[c.op]) {
          var res;
          try { res = ops[c.op](c); } catch (e) { res = { error: String(e) }; }
          return post("/__duo/result", { id: c.id, result: res, marker: window.__duoMarker });
        }
      })
      .catch(function () {})
      .then(function () { setTimeout(poll, 250); });
  }
  poll();
})();
