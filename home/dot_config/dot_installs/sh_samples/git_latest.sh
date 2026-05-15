latest=$(curl -s https://api.github.com/repos/cloudflare/cf-terraforming/releases/latest | grep browser_download_url | grep 'linux_amd64.tar.gz' | head -n 1 | cut -d '"' -f 4)
latest_file="${latest##*/}"
version_path=$(curl -s https://api.github.com/repos/cloudflare/cf-terraforming/releases | grep tarball_url | head -n 1 | cut -d '"' -f 4)
version="${version_path##*/}"
echo $latest
echo $latest_file
echo "${latest_file%.*}"
echo "${${latest_file%.*}%.*}"
echo "${latest_file%.tar.gz}"
echo $version_path
echo $version