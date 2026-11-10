// Practice Timer: a tiny practice app. Data lives in memory only.
var running = false;
var startedAt = 0;
var tick = null;
var sessions = [
  { label: "Scales", mins: "12:00" },
  { label: "Etude no. 4", mins: "25:30" },
  { label: "Sight reading", mins: "08:15" },
  { label: "Warm-up", mins: "05:00" }
];

var timerEl = document.getElementById("timer");
var toggleEl = document.getElementById("toggle");
var logEl = document.getElementById("log");

function fmt(ms) {
  var s = Math.floor(ms / 1000);
  var m = Math.floor(s / 60);
  s = s % 60;
  return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
}

function renderLog() {
  logEl.innerHTML = sessions.map(function (s) {
    return "<li><span>" + s.label + "</span><span>" + s.mins + "</span></li>";
  }).join("");
}

toggleEl.addEventListener("click", function () {
  if (!running) {
    running = true;
    startedAt = Date.now();
    toggleEl.textContent = "Stop";
    toggleEl.classList.add("running");
    tick = setInterval(function () { timerEl.textContent = fmt(Date.now() - startedAt); }, 250);
  } else {
    running = false;
    clearInterval(tick);
    sessions.unshift({ label: "Session " + (sessions.length + 1), mins: fmt(Date.now() - startedAt) });
    timerEl.textContent = "00:00";
    toggleEl.textContent = "Start";
    toggleEl.classList.remove("running");
    renderLog();
  }
});

document.querySelector(".tabbar").addEventListener("click", function (e) {
  var b = e.target.closest("button");
  if (!b) return;
  document.querySelectorAll(".tabbar button").forEach(function (x) { x.removeAttribute("aria-current"); });
  b.setAttribute("aria-current", "page");
  document.getElementById(b.getAttribute("data-go")).scrollIntoView();
});

renderLog();
