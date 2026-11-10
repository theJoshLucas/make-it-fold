import { StyleSheet, Switch, Text, View } from "react-native";
import { useState } from "react";

export default function Settings() {
  const [reminders, setReminders] = useState(true);
  return (
    <View style={styles.content}>
      <Text style={styles.title}>Settings</Text>
      <View style={styles.row}>
        <Text style={styles.rowText}>Daily reminder</Text>
        <Switch value={reminders} onValueChange={setReminders} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16 },
  title: { fontSize: 28, fontWeight: "700", marginBottom: 12 },
  row: { backgroundColor: "#fff", borderRadius: 10, padding: 14, flexDirection: "row", justifyContent: "space-between", alignItems: "center" },
  rowText: { fontSize: 16 },
});
