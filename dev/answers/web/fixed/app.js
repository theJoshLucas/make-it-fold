// Setlist: a tiny practice app. Data lives in memory only.
var shows = ["Friday at the Grange", "Spring recital", "Wedding: Hall B"];
var songs = [
  { title: "Take Five", key: "Eb min", bpm: 172, len: "5:24", notes: "Sax solo, count in 5/4" },
  { title: "Autumn Leaves", key: "G min", bpm: 120, len: "4:10", notes: "Ballad intro, then swing" },
  { title: "Fly Me to the Moon", key: "C", bpm: 128, len: "3:05", notes: "Vocals in, horns out at bridge" },
  { title: "September", key: "A", bpm: 126, len: "3:35", notes: "Everyone on the ba-dee-ya" }
];

function renderShows() {
  document.getElementById("shows").innerHTML = shows.map(function (s, i) {
    return '<li class="' + (i === 0 ? "on" : "") + '">' + s + "</li>";
  }).join("");
}

function renderSongs() {
  document.getElementById("songs").innerHTML = songs.map(function (s, i) {
    return "<tr><td>" + (i + 1) + "</td><td>" + s.title + "</td><td>" + s.key + "</td><td>" + s.bpm +
      "</td><td>" + s.len + "</td><td>" + s.notes + '</td><td><button class="del" type="button" data-i="' + i +
      '">Delete</button></td></tr>';
  }).join("");
}

// The editor is built once at load. A resize never rebuilds it, so typed text survives a fold.
function renderEditor() {
  document.getElementById("editor-slot").innerHTML =
    '<div class="editor"><h3>Add a song</h3>' +
    '<label for="song-title">Title</label><input id="song-title" placeholder="Song title">' +
    '<label for="song-notes">Notes for the band</label><textarea id="song-notes" placeholder="Who solos, where it ends"></textarea>' +
    "</div>";
}

// A narrow song list gets the compact layout. Measure the room the list really has (the page
// minus the sidebar), not the window: unfolded and upright, the sidebar leaves it about 449px.
function applyLayout() {
  var compact = document.querySelector(".content").clientWidth < 500;
  document.body.classList.toggle("compact", compact);
}

renderShows();
renderSongs();
renderEditor();
applyLayout();
window.addEventListener("resize", applyLayout);

document.getElementById("songs").addEventListener("click", function (e) {
  if (e.target.classList.contains("del")) {
    songs.splice(Number(e.target.getAttribute("data-i")), 1);
    renderSongs();
  }
});
document.getElementById("save").addEventListener("click", function () {
  document.getElementById("status").textContent = "Saved";
});
