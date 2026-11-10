import { Pressable, StyleSheet, Text, View } from "react-native";
import { Slot, router, usePathname } from "expo-router";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";

const tabs = [
  { path: "/", label: "Today" },
  { path: "/new", label: "New" },
  { path: "/settings", label: "Settings" },
];

function TabBar() {
  const pathname = usePathname();
  return (
    <View style={styles.tabBar}>
      {tabs.map((t) => (
        <Pressable key={t.path} style={styles.tabItem} onPress={() => router.navigate(t.path as never)}>
          <Text style={[styles.tabText, pathname === t.path && styles.tabTextOn]}>{t.label}</Text>
        </Pressable>
      ))}
    </View>
  );
}

export default function RootLayout() {
  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.root} edges={["top", "bottom"]}>
        <StatusBar style="dark" />
        <View style={styles.body}>
          <Slot />
        </View>
        <TabBar />
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: "#f6f4ef" },
  body: { flex: 1 },
  tabBar: { flexDirection: "row", borderTopWidth: 1, borderTopColor: "#ddd8cc", backgroundColor: "#fff" },
  tabItem: { flex: 1, alignItems: "center", paddingVertical: 14 },
  tabText: { fontSize: 14, color: "#7a766c" },
  tabTextOn: { color: "#1f6f4a", fontWeight: "700" },
});
