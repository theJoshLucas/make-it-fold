import { useState } from "react";
import { Pressable, StyleSheet, Text, TextInput, View, useWindowDimensions } from "react-native";

// Compact layout: fields stacked. Wide layout: fields side by side with a preview.
function CompactForm() {
  const [name, setName] = useState("");
  const [notes, setNotes] = useState("");
  return (
    <View>
      <TextInput style={styles.input} placeholder="Chore name" value={name} onChangeText={setName} />
      <TextInput style={[styles.input, styles.multi]} placeholder="Notes" value={notes} onChangeText={setNotes} multiline />
      <Pressable style={styles.button}><Text style={styles.buttonText}>Add chore</Text></Pressable>
    </View>
  );
}

function WideForm() {
  const [name, setName] = useState("");
  const [notes, setNotes] = useState("");
  return (
    <View style={styles.wide}>
      <View style={styles.wideCol}>
        <TextInput style={styles.input} placeholder="Chore name" value={name} onChangeText={setName} />
        <TextInput style={[styles.input, styles.multi]} placeholder="Notes" value={notes} onChangeText={setNotes} multiline />
        <Pressable style={styles.button}><Text style={styles.buttonText}>Add chore</Text></Pressable>
      </View>
      <View style={[styles.wideCol, styles.preview]}>
        <Text style={styles.previewTitle}>{name || "Chore name"}</Text>
        <Text>{notes || "Notes"}</Text>
      </View>
    </View>
  );
}

export default function NewChore() {
  const { width } = useWindowDimensions();
  return (
    <View style={styles.content}>
      <Text style={styles.title}>New chore</Text>
      {width >= 600 ? <WideForm /> : <CompactForm />}
    </View>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16 },
  title: { fontSize: 28, fontWeight: "700", marginBottom: 12 },
  input: { backgroundColor: "#fff", borderRadius: 10, padding: 12, fontSize: 16, marginBottom: 10 },
  multi: { minHeight: 90 },
  button: { backgroundColor: "#1f6f4a", borderRadius: 10, padding: 14, alignItems: "center" },
  buttonText: { color: "#fff", fontWeight: "700", fontSize: 16 },
  wide: { flexDirection: "row", gap: 16 },
  wideCol: { flex: 1 },
  preview: { backgroundColor: "#fff", borderRadius: 10, padding: 14 },
  previewTitle: { fontSize: 18, fontWeight: "700", marginBottom: 6 },
});
