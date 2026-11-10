// Trail Notes: a tiny practice page shown inside a native shell. Data lives in memory only.
var notes = [
  { title: "Ridge loop", body: "Muddy after rain, 6 km, bring poles." },
  { title: "Creek crossing", body: "Stepping stones are loose near the bend." },
  { title: "Lookout point", body: "Best light about an hour before sunset." },
  { title: "Parking", body: "Lot fills by 8 am on weekends." },
  { title: "Water refill", body: "Tap at the ranger hut, closed in winter." },
  { title: "Fern gully", body: "Short detour, steep steps on the way back." }
];

var grid = document.getElementById("grid");

function render() {
  document.getElementById("count").textContent = notes.length + " notes";
  grid.innerHTML = notes.map(function (n) {
    return '<article class="card"><h3>' + n.title + "</h3><p>" + n.body + "</p></article>";
  }).join("");
}

// Lay the cards out for this device: one column on phones, two on wider screens.
function layout() {
  var cols = window.innerWidth >= 500 ? 2 : 1;
  grid.style.gridTemplateColumns = "repeat(" + cols + ", 1fr)";
}

document.getElementById("add").addEventListener("click", function () {
  notes.unshift({ title: "New note", body: "Tap to edit." });
  render();
});

render();
layout();
window.addEventListener("resize", layout);
