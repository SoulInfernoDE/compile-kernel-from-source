# Kernel Upgrade Script (v2.9)

[🇺🇸 Switch to English version](README.md)

Ein vollautomatisches Bash-Skript zum Kompilieren, Installieren und Signieren eines aktuellen Mainline-Linux-Kernels. Dieses Skript wurde optimiert, um moderne Kernel-Features nahtlos zu integrieren, alte Kernel-Reste zu entfernen und Sicherheitsstandards (UEFI Secure Boot Signierung) fehlerfrei zu handhaben.

## 🚀 Features

- **🌐 OTA Auto-Updater:** Prüft bei jedem Start direkt das GitHub-Repository. Wird eine neuere Version gefunden, überschreibt sich das Skript selbst und setzt deinen Befehl ohne Unterbrechung fort (funktioniert auch direkt bei Optionen wie `-h`).

- **📦 Systemweite Integration (`--install-system`):** Kopiert das Skript nach `~/.scripts`, trägt den Pfad in deine `~/.bashrc` ein und aktiviert die native Tab-Vervollständigung im Terminal.

- **Vollautomatisch:** Lädt den neuesten stabilen Kernel von `kernel.org`, konfiguriert, baut und installiert ihn.

- **Waydroid Ready:** Integriert automatisch `.config`-Fragmente für **Binder** und **memfd** (erforderlich für moderne Waydroid/Android-Container, ersetzt das veraltete ashmem).

- **Secure Boot & DKMS Support:** Automatisierte MOK (Machine Owner Key) Generierung und Signierung der Kernel-Images (`sbsign`). Hinterlegt die Schlüssel zeitgleich als PEM und binäres DER-Format, um SSL/ASN1-Parsing-Fehler bei Drittanbieter-Modulen (z. B. DisplayLink `evdi` via `kmodsign`) zu verhindern.

- **🔄 Intelligente Versionsprüfung:** Erkennt, ob der Ziel-Kernel bereits läuft oder installiert ist. Statt redundante Builds zu starten, schlägt das Skript interaktiv die Top 3 der alternativen stabilen Kernel-Releases vor.

- **🧹 Automatisierte Bereinigung (`--purge-custom`):** Entfernt alte `-waydroid` Kernel-Reste, Header und Debug-Symbole restlos. Über einen cleveren `grub-reboot`-Hook startet das System dafür einmalig temporär in den offiziellen Distributions-Kernel, bereinigt alle Altlasten und setzt den Prozess nach dem Reboot fort.
- **Autosign-Integration:** Installiert ein Post-Install-Skript, das zukünftige Kernel-Updates automatisch signiert.
- **Mehrsprachig:** Erkennt automatisch die Systemsprache (Deutsch/Englisch).


## 🛠 Voraussetzungen

Das Skript installiert notwendige Abhängigkeiten automatisch via `apt`. Grundsätzlich werden benötigt:
- Ein Debian-basiertes System (Ubuntu, Linux Mint, Debian, etc.)
- Internetverbindung
- Root-Rechte (via `sudo`)


## 📦 Installation & Nutzung

1. **Skript vorbereiten:**
   Speichere/Downloade den Code des Skripts als `kernel_upgrade`.

2. **Ausführbar machen:**
   ```bash
   chmod +x kernel_upgrade

3. **Systemweit installieren (Empfohlen):**
   ```bash
   ./kernel_upgrade --install-system && source ~/.bashrc

Ab jetzt kannst du das Skript von jedem beliebigen Verzeichnis aus mit dem Befehl kernel_upgrade im Terminal samt Autovervollständigung aufrufen!


⚙️ Parameter & Optionen
```bash
Option                  Beschreibung
-h, --help              Zeigt diese Hilfe-Seite an.
--version               Zeigt die aktuelle Skript-Version (v2.9-stable) an.
--install-system        Installiert das Skript systemweit in ~/.scripts und setzt den PATH.
--kernelversion [VER]   Erzwingt den Build einer spezifischen Version (z. B. 6.12.1).
--purge-custom          Startet die automatisierte Deinstallation alter Custom-Kernel mittels temporärem Reboot.
--signonly              Signiert lediglich einen vorhandenen Kernel in /boot (kein Build).
--installautosign       Installiert das Hook-Skript für automatische Signierung bei Updates.
--uninstallautosign     Entfernt das Autosign-Skript und bereinigt optional die Schlüssel.
```


🔐 Secure Boot Hinweis

Wenn du Secure Boot nutzt, wird das Skript dich beim ersten Durchlauf fragen, ob neue MOK-Schlüssel generiert werden sollen.

Bestätige die Generierung.

Starte das System nach Abschluss des Skripts neu.

Im blauen Menü (MOK Manager) wähle: Enroll MOK -> Continue -> Yes -> Passwort eingeben -> Reboot.
Der neue Kernel kann nun sicher gebootet werden.


📂 Dateistruktur

~/.scripts/: Installationsort für die globale Ausführung im System environment.

~/Downloads: Hier werden die Kernel-Sourcen entpackt und die .deb-Pakete erstellt.

~/.mok_keys: Speicherort deiner privaten UEFI-Schlüssel (sowohl als PEM als auch als binäres DER-Format).

/var/lib/shim-signed/mok/: System-Pfad für maximale Kompatibilität mit sbsign und dkms / kmodsign.

/etc/kernel/postinst.d/: Installationsort des Autosign-Hooks.
