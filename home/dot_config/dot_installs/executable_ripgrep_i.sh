# /usr/bin/rg
deb=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
| grep browser_download_url \
| grep '\.deb"' \
| cut -d '"' -f 4)
curl -LO "$deb" && sudo dpkg -i "$(basename "$deb")" && rm $(basename "$deb")
# If dependencies fail after installation:
sudo apt-get install -f