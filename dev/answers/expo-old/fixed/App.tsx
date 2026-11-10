import { useState } from "react";
import { Dimensions, Pressable, StyleSheet, Text, View } from "react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";

// Read once at startup.
const { width: SCREEN_WIDTH } = Dimensions.get("screen");

type Tab = "today" | "done";

const chores = ["Water the plants", "Take out recycling", "Wipe the counters"];

function TodayScreen() {
  return (
    <View style={styles.screen}>
      <Text style={styles.title}>Today</Text>
      {chores.map((c) => (
        <View key={c} style={[styles.row, { width: SCREEN_WIDTH - 32 }]}>
          <Text style={styles.rowText}>{c}</Text>
        </View>
      ))}
    </View>
  );
}

function DoneScreen() {
  return (
    <View style={styles.screen}>
      <Text style={styles.title}>Done</Text>
      <Text style={styles.empty}>Nothing finished yet.</Text>
    </View>
  );
}

function TabBar({ tab, onChange }: { tab: Tab; onChange: (t: Tab) => void }) {
  return (
    <View style={styles.tabBar}>
      {(["today", "done"] as Tab[]).map((t) => (
        <Pressable key={t} style={styles.tabItem} onPress={() => onChange(t)}>
          <Text style={[styles.tabText, tab === t && styles.tabTextOn]}>{t === "today" ? "Today" : "Done"}</Text>
        </Pressable>
      ))}
    </View>
  );
}

export default function App() {
  const [tab, setTab] = useState<Tab>("today");
  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.root} edges={["top", "bottom"]}>
        <StatusBar style="dark" />
        {tab === "today" ? <TodayScreen /> : <DoneScreen />}
        <TabBar tab={tab} onChange={setTab} />
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: "#f6f4ef" },
  screen: { flex: 1, padding: 16 },
  title: { fontSize: 28, fontWeight: "700", marginBottom: 12 },
  row: { backgroundColor: "#fff", borderRadius: 10, padding: 14, marginBottom: 8 },
  rowText: { fontSize: 16 },
  empty: { color: "#7a766c" },
  tabBar: { flexDirection: "row", borderTopWidth: 1, borderTopColor: "#ddd8cc", backgroundColor: "#fff" },
  tabItem: { flex: 1, alignItems: "center", paddingVertical: 14 },
  tabText: { fontSize: 14, color: "#7a766c" },
  tabTextOn: { color: "#1f6f4a", fontWeight: "700" },
});
