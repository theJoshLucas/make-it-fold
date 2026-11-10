import { Dimensions, ScrollView, StyleSheet, Text, View } from "react-native";

// Read once when the file loads.
const { width: SCREEN_WIDTH } = Dimensions.get("screen");

const chores = ["Water the plants", "Take out recycling", "Wipe the counters", "Sweep the porch", "Fold laundry"];

export default function Today() {
  return (
    <ScrollView contentContainerStyle={styles.content}>
      <Text style={styles.title}>Today</Text>
      {chores.map((c) => (
        <View key={c} style={[styles.row, { width: SCREEN_WIDTH - 32 }]}>
          <Text style={styles.rowText}>{c}</Text>
        </View>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: { padding: 16 },
  title: { fontSize: 28, fontWeight: "700", marginBottom: 12 },
  row: { backgroundColor: "#fff", borderRadius: 10, padding: 14, marginBottom: 8 },
  rowText: { fontSize: 16 },
});
