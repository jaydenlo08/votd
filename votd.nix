{ inputs, lib, config, pkgs, ... }: let
  votd = pkgs.writers.writePython3Bin "votd" {
    libraries = with pkgs.python3Packages; [ urllib3 beautifulsoup4 ];
  } ''
# Import libraries
import urllib3
import sys
import json
import os
from datetime import datetime
from bs4 import BeautifulSoup


def printAll(cache):
    # Print verse and thoughts
    print(f"-- {cache['citation']} --\n"
          f"{cache['words']}\n\n"
          f"{cache['thoughts']}")


def printVerse(cache):
    # Print verse only
    print(f"-- {cache['citation']} --\n"
          f"{cache['words']}")


def printThoughts(cache):
    # Print thoughts only
    print(cache['thoughts'])


def printHelp():
    # Print help
    print("""votd: votd [-a] [-h]
    Print the verse of the day

    Options     Long option    Meaning
    -a          --all          Print verse and thoughts
    -h          --help         Display this help message
    -t          --thoughts     Print thoughts only
    -n          --no-error     Do not display network error
    """)


def run():
    if "DEBUG" in globals():
        print("Reading from file...")

    with open(path, 'r') as file:  # Open file
        cache = json.load(file)
    if ("-a" in sys.argv) or ("--all" in sys.argv):
        printAll(cache)
    elif ("-t" in sys.argv) or ("--thoughts" in sys.argv):
        printThoughts(cache)
    elif ("-h" in sys.argv) or ("--help" in sys.argv):
        printHelp()
    else:
        printVerse(cache)


def update():
    dateFormatted = datetime.today().strftime('%m%d%y')
    requestURL = f"https://www.verseoftheday.com/en/{dateFormatted}"
    if "DEBUG" in globals():
        print(f"Updating from {requestURL} ...")
    try:
        request = urllib3.request("GET", requestURL)
    except Exception:
        if "-n" not in sys.argv:
            print("Network Error.")
        sys.exit(1)
    else:
        url = request.data
    html = BeautifulSoup(url, 'html.parser')

    # Extract from HTML
    verse = html.find('div', attrs={'class': 'bilingual-left'}).text.strip()
    words = verse[:verse.find(u'—')]
    citation = verse[verse.find(u'—')+1:]
    thoughts = html.find('p', attrs={'id': 'thought'}).text.strip()
    cache = {
        "date": date,
        "citation": citation,
        "words": words,
        "thoughts": thoughts
    }
    with open(path, 'w') as file:  # Update file
        file.write(json.dumps(cache))


# Main
path = f"{os.getenv('HOME')}/.config/votd.conf"  # Config path
date = datetime.today().strftime('%Y-%m-%d')
if os.path.isfile(path):
    with open(path, 'r') as file:  # Open file
        try:
            cache = json.load(file)
        except json.JSONDecodeError:
            # If malformed JSON
            update()
        else:
            if (date != cache["date"]):
                # If incorrect date
                update()
else:
    # If file not exist
    update()
run()
  '';
in {
  environment.systemPackages = [ votd ];
  programs.bash.interactiveShellInit = "votd -n";
}
