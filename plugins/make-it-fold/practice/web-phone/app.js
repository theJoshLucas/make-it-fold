// Woodshed: a tiny practice diary. Made-up data, kept in memory only.
const state = {
  selected: null,
  sessions: [
    { id: 1, piece: "Blackbird", when: "Today", min: 25, next: "",
      notes: "Slow and even through the bridge. The thumb keeps racing ahead of the melody when the metronome is off, so every pass started at sixty and only moved up after two clean runs in a row." },
    { id: 2, piece: "Minor blues in A", when: "Yesterday", min: 40, next: "Turnaround in bars 11 and 12", notes: "Comping only. Kept the left hand quiet and counted the rests out loud." },
    { id: 3, piece: "Scales, two octaves", when: "Tuesday", min: 15, next: "", notes: "Flat keys still stumble on the way down." },
    { id: 4, piece: "Autumn Leaves", when: "Monday", min: 30, next: "Second ending", notes: "Head is memorised. Solo falls apart after the first eight bars." },
  ],
};
const $ = (id) => document.getElementById(id);

function renderList() {
  $("sessions").innerHTML = "";
  for (const s of state.sessions) {
    const li = document.createElement("li");
    li.dataset.id = s.id;
    if (s.id === state.selected) li.className = "on";
    li.innerHTML = `<div><div class="piece"></div><div class="when"></div></div><div class="min"></div>`;
    li.querySelector(".piece").textContent = s.piece;
    li.querySelector(".when").textContent = s.when;
    li.querySelector(".min").textContent = s.min + " min";
    li.addEventListener("click", () => open(s.id));
    $("sessions").appendChild(li);
  }
  $("week-min").textContent = state.sessions.reduce((n, s) => n + s.min, 0);
  $("count").textContent = state.sessions.length;
}

function open(id) {
  const s = state.sessions.find((x) => x.id === id);
  state.selected = id;
  $("d-piece").textContent = s.piece;
  $("d-meta").textContent = `${s.when}, ${s.min} minutes`;
  $("d-notes").textContent = s.notes;
  $("d-next").value = s.next;
  $("app").dataset.view = "detail";
  renderList();
}

$("back").addEventListener("click", () => { $("app").dataset.view = "list"; });
$("d-save").addEventListener("click", () => {
  const s = state.sessions.find((x) => x.id === state.selected);
  if (s) s.next = $("d-next").value;
});

function sheet(show) { $("sheet").hidden = !show; $("scrim").hidden = !show; }
$("add").addEventListener("click", () => sheet(true));
$("cancel").addEventListener("click", () => sheet(false));
$("scrim").addEventListener("click", () => sheet(false));
$("sheet").addEventListener("submit", (e) => {
  e.preventDefault();
  const piece = $("f-piece").value.trim();
  if (!piece) return;
  state.sessions.unshift({ id: Date.now(), piece, when: "Today", min: parseInt($("f-min").value, 10) || 0, next: "", notes: $("f-notes").value });
  $("sheet").reset();
  sheet(false);
  renderList();
});

renderList();
