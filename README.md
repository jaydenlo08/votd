# Verse of the Day CLI

A simple python script to display verse of the day from [www.verseoftheday.com](https://www.verseoftheday.com) on your terminal.

# How to use
Simply execute `votd` on your favourite terminal emulator

More options available:
```
votd: votd [-a] [-h]
    Print the verse of the day

    Options     Long option    Meaning
    -a          --all          Print verse and thoughts
    -h          --help         Display this help message
    -t          --thoughts     Print thoughts only
    -n          --no-error     Do not display network error
```

# Sample output
<p align="center">
  <img width="570.67" height="277.33" alt="image" src="https://github.com/user-attachments/assets/f89be109-990a-4e7e-b102-e08802bd9f25"  />
</p>

```
-- John 3:16 --
For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.
```

# Installation

#### 1. Install Python dependency
For Debian-based systems:
```
sudo apt install python3-bs4 python3-urllib3
```
For Fedora system:
```
sudo dnf install python3-beautifulsoup4 python3-urllib3
```

#### 2. Download script
This fetches the script from GitHub and saves it to `~/.local/share/votd.py`
```
curl -s https://raw.githubusercontent.com/jaydenlo08/votd/refs/heads/main/votd.py >> ~/.local/share/votd.py
```

#### 3. Add to .bashrc (optional)
This will allow `votd` to run automatically on shell initialisation
```
echo "python3 ~/.local/share/votd.py" >> ~/.bashrc
```

# NixOS
A Nix flake is also provided in this repository, `votd.nix`. To use, simply add it to your `flake.nix`, as a module.

# Technical Info
Upon first run of the day, the script extracts the information from [www.verseoftheday.com](https://www.verseoftheday.com) and saves it to a JSON file at `~/.config/votd.conf`. Any subsequent invocations in the same day will use the existing cached data.

# Credits
Many thanks to the community behind [www.verseoftheday.com](https://www.verseoftheday.com), which is part of the [Heartlight](https://www.heartlight.org/) network.
