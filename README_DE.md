# Kernel Upgrade Script (v2.0)

[🇺🇸 Switch to English version](README.md)

Ein vollautomatisches Bash-Skript zum Kompilieren, Installieren und Signieren eines aktuellen Mainline-Linux-Kernels. Dieses Skript wurde optimiert, um moderne Kernel-Features und Sicherheitsstandards (UEFI Secure Boot Signierung) nahtlos zu integrieren.

## 🚀 Features

- **Vollautomatisch:** Lädt den neuesten stabilen Kernel von `kernel.org`, konfiguriert, baut und installiert ihn.
- **Waydroid Ready:** Integriert automatisch `.config`-Fragmente für **Binder** und **memfd** (erforderlich für moderne Waydroid/Android-Container, ersetzt das veraltete ashmem).
- **Secure Boot Support:** Automatisierte MOK (Machine Owner Key) Generierung und Signierung der Kernel-Images (`sbsign`).
- **Autosign-Integration:** Installiert ein Post-Install-Skript, das zukünftige Kernel-Updates automatisch signiert.
- **Mehrsprachig:** Erkennt automatisch die Systemsprache (Deutsch/Englisch).
- **Flexibel:** Erlaubt die Installation spezifischer Versionen via `--kernelversion`.

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

3. **Starten:**
   ```bash
   ./kernel_upgrade

## ⚙️ Parameter & Optionen
   ```bash
Option               Beschreibung

-h, --help               Zeigt diese Hilfe-Seite an.
--version                Zeigt die aktuelle Skript-Version (v2.0) an.
--kernelversion [VER]    Erzwingt den Build einer spezifischen Version (z. B. 6.12.1).
--signonly               Signiert lediglich einen vorhandenen Kernel in /boot (kein Build).
--installautosign        Installiert das Hook-Skript für automatische Signierung bei Updates.
--uninstallautosign      Entfernt das Autosign-Skript und bereinigt optional die Schlüssel.
```

## 🔐 Secure Boot Hinweis
Wenn du Secure Boot nutzt, wird das Skript dich beim ersten Durchlauf fragen, ob neue MOK-Schlüssel generiert werden sollen.

Bestätige die Generierung.

Starte das System nach Abschluss des Skripts neu.

Im blauen Menü (MOK Manager) wähle: Enroll MOK -> Continue -> Yes -> Passwort eingeben -> Reboot.
Der neue Kernel kann nun sicher gebootet werden.

## 📂 Dateistruktur
~/Downloads: Hier werden die Kernel-Sourcen entpackt und die .deb-Pakete erstellt.

~/.mok_keys: Speicherort deiner privaten UEFI-Schlüssel.

/etc/kernel/postinst.d/: Installationsort des Autosign-Hooks.
