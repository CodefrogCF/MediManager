"""Exercise a release APK with synthetic records on a disposable Android emulator."""

import argparse
import hashlib
import json
import re
import subprocess
import tempfile
import time
import xml.etree.ElementTree as ET
from datetime import date, timedelta
from pathlib import Path


PACKAGE = "com.codefrog.medimanager"
PERMISSION = "android.permission.POST_NOTIFICATIONS"
BACKUP = "medimanager-release-fixture.json"
MORNING, EVENING = 81, 82


def eventually(action, description, seconds=90):
    deadline = time.monotonic() + seconds
    while time.monotonic() < deadline:
        if result := action():
            return result
        time.sleep(1)
    raise RuntimeError(f"Timed out waiting for {description}")


class Emulator:
    def __init__(self, adb, serial):
        self.command = [adb, "-s", serial]

    def adb(self, *arguments):
        timeout = 180 if arguments[0] in {"install", "reboot", "wait-for-device"} else 45
        return subprocess.check_output(
            self.command + list(map(str, arguments)), timeout=timeout
        )

    def shell(self, *arguments):
        return self.adb("shell", *arguments).decode("utf-8", errors="replace").strip()

    def launch(self):
        self.shell("input", "keyevent", "KEYCODE_WAKEUP")
        self.shell("wm", "dismiss-keyguard")
        self.shell("am", "start", "-n", f"{PACKAGE}/.MainActivity")

    def key(self, key):
        self.shell("input", "keyevent", key)

    def node(self, label):
        label = label.casefold()
        output = self.shell("uiautomator", "dump", "/data/local/tmp/mm-release.xml")
        if "dumped to" not in output:
            return None
        xml = self.adb("shell", "cat", "/data/local/tmp/mm-release.xml")
        nodes = list(ET.fromstring(xml).iter("node"))
        if any(node.get("text") == "System UI isn't responding" for node in nodes):
            wait_button = next((node for node in nodes if node.get("text") == "Wait"), None)
            if wait_button is not None:
                x1, y1, x2, y2 = map(int, re.findall(r"\d+", wait_button.get("bounds", "")))
                self.shell("input", "tap", (x1 + x2) // 2, (y1 + y2) // 2)
                print("Dismissed the emulator's System UI timeout with Wait.", flush=True)
                return None
        for exact in (True, False):
            for node in nodes:
                title = node.get("text", "") + "\n" + node.get("content-desc", "")
                lines = title.casefold().splitlines()
                if any(line == label if exact else label in line for line in lines):
                    return tuple(map(int, re.findall(r"\d+", node.get("bounds", ""))))
        return None

    def wait(self, label):
        return eventually(lambda: self.node(label), repr(label))

    def tap_bounds(self, bounds):
        x1, y1, x2, y2 = bounds
        self.shell("input", "tap", (x1 + x2) // 2, (y1 + y2) // 2)
        time.sleep(0.4)

    def tap(self, label):
        self.tap_bounds(self.wait(label))

    def open(self, label, landmark):
        def navigate():
            if self.node(landmark):
                return True
            if bounds := self.node(label):
                self.tap_bounds(bounds)
            return False

        eventually(navigate, f"{landmark!r} after opening {label!r}")

    def posted(self):
        status = self.shell("dumpsys", "notification", "--noredact")
        return {
            int(slot)
            for slot in re.findall(
                rf"^\s*NotificationRecord.*pkg={re.escape(PACKAGE)}\b.*?tag=intake:(\d+):",
                status,
                re.MULTILINE,
            )
        }

    def reminder_alarm(self):
        alarms = self.shell("dumpsys", "alarm")
        return f"tag=*walarm*:{PACKAGE}.REFRESH_REMINDERS" in alarms

    def screenshot(self, path):
        path.write_bytes(self.adb("exec-out", "screencap", "-p"))


def fixture(today):
    yesterday = today - timedelta(days=1)
    old_stamp = "2020-01-01T00:00:00.123456Z"
    payload = {
        "exported_at": f"{yesterday}T20:00:00.000000Z",
        "tables": {
            "medications": [{
                "id": 43, "name": "Vitamin D", "dosage": "Example dose",
                "is_active": True, "created_at": f"{yesterday}T06:00:00.000000Z",
            }],
            "medication_details": [{
                "medication_id": 43, "starts_on": "-271821-04-20",
                "name": "Vitamin D", "dosage": "Example dose",
            }],
            "medication_schedules": [
                {"id": slot, "medication_id": 43, "recurrence": 0,
                 "minutes_after_midnight": minute, "starts_on": str(yesterday),
                 "ends_before": None, "label": label}
                for slot, minute, label in [(MORNING, 480, "Morning"), (EVENING, 1080, "Evening")]
            ],
            "intake_events": [{
                "id": 41, "schedule_id": MORNING, "scheduled_date": str(yesterday),
                "kind": "confirmation", "recorded_at": f"{yesterday}T08:01:00.123456Z",
                "recorded_on": str(yesterday), "reported_intake_at": None,
            }],
            "slot_reminders": [
                {"schedule_id": slot, "enabled": True, "reminder_minute": 0,
                 "snooze_minutes": minutes, "changed_at": old_stamp}
                for slot, minutes in [(MORNING, 5), (EVENING, 30)]
            ],
            "app_settings": [{"id": 1, "theme_mode": "light", "accent": "green", "language": "en"}],
        },
    }
    canonical = json.dumps(payload, ensure_ascii=False, separators=(",", ":"))
    return json.dumps({
        "format": "medimanager-backup", "version": 1,
        "sha256": hashlib.sha256(canonical.encode()).hexdigest(), "payload": payload,
    })


def restore(emulator, today, *, english=False):
    with tempfile.TemporaryDirectory() as directory:
        backup = Path(directory) / BACKUP
        backup.write_text(fixture(today), encoding="utf-8")
        emulator.adb("push", backup, f"/sdcard/Download/{BACKUP}")
    privacy = "Data and privacy" if english else "Daten und Datenschutz"
    restore_label = "Restore backup" if english else "Sicherung wiederherstellen"
    emulator.open("Settings" if english else "Einstellungen", privacy)
    emulator.open(privacy, restore_label)
    emulator.open(restore_label, "Show roots")
    if not emulator.node(BACKUP):
        emulator.open("Show roots", "Open from")
        emulator.open("Downloads", BACKUP)
    emulator.tap(BACKUP)
    emulator.wait("Replace local data?" if english else "Lokale Daten ersetzen?")
    emulator.tap("Restore" if english else "Wiederherstellen")
    emulator.wait("Export backup")
    emulator.key("KEYCODE_BACK")
    emulator.key("KEYCODE_BACK")
    emulator.wait("Taken for Vitamin D, Morning")
    emulator.wait("Taken for Vitamin D, Evening")


def check_release(args):
    emulator = Emulator(args.adb, args.serial)
    if emulator.shell("getprop", "ro.kernel.qemu") != "1":
        raise RuntimeError("Use a disposable emulator for this test.")
    if f"package:{PACKAGE}" in emulator.shell("pm", "list", "packages", PACKAGE).splitlines():
        raise RuntimeError("MediManager is already installed. Use a fresh test emulator.")
    api = int(emulator.shell("getprop", "ro.build.version.sdk"))
    pages = emulator.shell("getconf", "PAGE_SIZE")
    print(f"Android API {api}, {pages}-byte pages", flush=True)
    if args.screenshots:
        args.screenshots.mkdir(parents=True, exist_ok=True)
        emulator.shell("wm", "size", "1080x1920")
    emulator.adb("install", args.previous_apk or args.apk)
    emulator.launch()
    today = date.fromisoformat(emulator.shell("date", "+%F"))
    restore(emulator, today)
    if api >= 33:
        assert emulator.posted() == set(), "Reminders appeared without permission"
        print("Tracking and restore worked with notification permission denied.", flush=True)
    if args.previous_apk:
        emulator.adb("install", "-r", args.apk)
        emulator.launch()
        emulator.wait("Taken for Vitamin D, Morning")
        emulator.wait("Taken for Vitamin D, Evening")
        emulator.tap("Archive")
        emulator.wait("Undo for Vitamin D, Morning")
        emulator.tap("Today")
        print("Upgrade preserved the existing slots, confirmation and preferences.", flush=True)
        if api < 33:
            # An upgrade can clear cards that the old version has already posted.
            restore(emulator, today, english=True)

    check_intakes(emulator, today, api, args)


def check_intakes(emulator, today, api, args):
    if api >= 33:
        emulator.shell("pm", "grant", PACKAGE, PERMISSION)
        emulator.key("KEYCODE_HOME")
        emulator.launch()
    eventually(lambda: emulator.posted() == {MORNING, EVENING}, "two independent reminders")

    # Swipe the posted evening card. This exercises the OS dismissal path.
    emulator.key("KEYCODE_NOTIFICATION")
    x1, y1, x2, y2 = emulator.wait(f"Evening · {today:%Y-%m-%d} · 18:00")
    x = (x1 + x2) // 2
    y = (y1 + y2) // 2
    width = int(re.findall(r"\d+x\d+", emulator.shell("wm", "size"))[-1].split("x")[0])
    target = width - 1 if x < width / 2 else 1
    emulator.shell("input", "swipe", x, y, target, y, 300)
    # Android can group multiple cards and dismiss the group with one gesture.
    eventually(lambda: EVENING not in emulator.posted(), "evening notification dismissal")
    emulator.key("KEYCODE_BACK")
    emulator.wait("Taken for Vitamin D, Evening")
    print("Swiping away the evening reminder left that intake pending.", flush=True)

    check_persistence(emulator, today, args)


def check_persistence(emulator, today, args):
    emulator.tap("Taken for Vitamin D, Morning")
    emulator.wait("Undo for Vitamin D, Morning")
    eventually(lambda: emulator.posted() == set() or None, "confirmation cancels its reminder")
    emulator.wait("Taken for Vitamin D, Evening")
    if args.screenshots:
        emulator.screenshot(args.screenshots / "today.png")
    emulator.tap("Archive")
    emulator.wait("Undo for Vitamin D, Morning")
    if args.screenshots:
        emulator.screenshot(args.screenshots / "archive.png")

    if args.reboot:
        emulator.key("KEYCODE_HOME")
        emulator.shell("dumpsys", "battery", "unplug")
        try:
            emulator.shell("cmd", "deviceidle", "force-idle")
            assert emulator.shell("cmd", "deviceidle", "get", "deep") == "IDLE"
            assert emulator.reminder_alarm(), "Android discarded the next reminder during Doze"
            print("The next reminder remained scheduled in forced Doze.", flush=True)
        finally:
            emulator.shell("cmd", "deviceidle", "unforce")
            emulator.shell("dumpsys", "battery", "reset")

        emulator.adb("reboot")
        emulator.adb("wait-for-device")
        eventually(lambda: emulator.shell("getprop", "sys.boot_completed") == "1", "Android boot", 180)
        emulator.key("KEYCODE_WAKEUP")
        emulator.shell("wm", "dismiss-keyguard")
        eventually(emulator.reminder_alarm, "the reminder alarm after reboot", 180)
        print("Android re-armed the reminder before opening the app after reboot.", flush=True)

    emulator.shell("am", "force-stop", PACKAGE)
    emulator.shell("cmd", "connectivity", "airplane-mode", "enable")
    emulator.launch()
    emulator.wait("Undo for Vitamin D, Morning")
    emulator.wait("Taken for Vitamin D, Evening")
    emulator.tap("Archive")
    emulator.wait("Undo for Vitamin D, Morning")
    print("Today and Archive preserved independent states after restart while offline.", flush=True)

    emulator.tap("Settings")
    emulator.tap("Data and privacy")
    emulator.tap("Export backup")
    emulator.tap("Show roots")
    emulator.tap("Downloads")
    emulator.tap("Save")
    emulator.wait("The backup was exported.")
    exported = json.loads(emulator.adb("exec-out", "cat", f"/sdcard/Download/medimanager-{today}.json"))
    exported_today = [event for event in exported["payload"]["tables"]["intake_events"]
                      if event["scheduled_date"] == str(today)]
    assert [(event["schedule_id"], event["kind"]) for event in exported_today] == [
        (MORNING, "confirmation")
    ]
    print("The exported intake log contains today's morning confirmation and no evening event.", flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--serial", required=True, help="Fresh emulator with English Android UI")
    parser.add_argument("--adb", default="adb")
    parser.add_argument("--apk", required=True, type=Path, help="Signed release-mode APK")
    parser.add_argument("--previous-apk", type=Path, help="Optional v0.3 APK signed with the same key")
    parser.add_argument("--screenshots", type=Path)
    parser.add_argument("--reboot", action="store_true")
    check_release(parser.parse_args())
