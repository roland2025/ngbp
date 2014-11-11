#!/bin/bash
#   This should probably be in gruntfile
#
set -e
me=$PWD

# generate your key by creating extension on chrome://extensions page
application_id=jpabeekbjicamajjcfejnochhmlbpgjh
web_url_prefix="http://$(hostname)/ngbp"

# web application manifest path
webapp_manifest_path="webapp-manifest.json"
# chrome app manifest path
chrome_manifest_path="chrome-manifest.json"

# version number
version_number=$(jq -r .version package.json)

# grunt
grunt

# copy fontawesome

cp -vr vendor/font-awesome/fonts/ build/
mkdir -p build/vendor/mobile-angular-ui/dist
cp -vr vendor/font-awesome/fonts/ build/vendor/mobile-angular-ui/dist
cp -vr vendor/mobile-angular-ui/dist/css build/vendor/mobile-angular-ui/dist

cp -vr vendor/font-awesome/fonts/ bin/
mkdir -p bin/vendor/mobile-angular-ui/dist
cp -vr vendor/font-awesome/fonts/ bin/vendor/mobile-angular-ui/dist
cp -vr vendor/mobile-angular-ui/dist/css bin/vendor/mobile-angular-ui/dist
cp -vr src/_locales bin/locales

# Generate manifest.json
# Required - manifest begin
echo '{
  "manifest_version": 2,
  "name": "ngbp-mobile-angular-ui",
' | tee -a $webapp_manifest_path | tee -a $chrome_manifest_path


echo "  \"version\": \"$version_number\"," | tee -a $webapp_manifest_path | tee -a $chrome_manifest_path

echo "  \"homepage_url\": \"http://$(hostname)/ng\"," | tee -a $webapp_manifest_path

# was in chrome gdrive example
echo '  "minimum_chrome_version": "29",' | tee -a $chrome_manifest_path


#   // Recommended
echo '
  "description": "Mobile Angular UI - ngbp example",
' | tee -a $webapp_manifest_path

[[ -f src/assets/icon/favicon-128.png ]] && {

echo '
  "icons": [ {
            "src": "assets/icon/favicon-128.png",
            "type": "image/png",
            "sizes": "128x128",
            "density": 2
      }],
' | tee -a $webapp_manifest_path


echo '
  "icons": {
    "128": "assets/icon/favicon-128.png",
    "192": "assets/icon/favicon-192.png",
    "512": "assets/icon/favicon-512.png"
  },
' | tee -a $chrome_manifest_path

}

#  // Optional
#   "default_locale": "en",
echo '
  "author": "'$(jq -r .author package.json)'",
  "app": {
    "background": {
      "scripts": ["assets/background.js"]
    }
  },
  "offline_enabled": true,
' | tee -a $webapp_manifest_path | tee -a $chrome_manifest_path

echo '
  "background": {
    "persistent": true
  }, 
' | tee -a $webapp_manifest_path


echo "  \"update_url\": \"$web_url_prefix/updateChrome.xml\"" | tee -a $chrome_manifest_path

echo "  \"update_url\": \"$web_url_prefix/updateWebApp.xml\"" | tee -a $webapp_manifest_path

echo "}" | tee -a $webapp_manifest_path | tee -a $chrome_manifest_path
# - manifest end

echo "
<?xml version='1.0' encoding='UTF-8'?>
<gupdate xmlns='http://www.google.com/update2/response' protocol='2.0'>
  <app appid='$application_id'>
    <updatecheck codebase='$web_url_prefix/assets/ngbp-mobile-angular-ui-$version_number.crx' version='$version_number' />
  </app>
</gupdate>
" | tee -a bin/updateWebApp.xml

mv -v $webapp_manifest_path bin/manifest.json

#     Generate Chrome extension

echo "
<?xml version='1.0' encoding='UTF-8'?>
<gupdate xmlns='http://www.google.com/update2/response' protocol='2.0'>
  <app appid='$application_id'>
    <updatecheck codebase='$web_url_prefix/assets/ngbp-mobile-angular-ui-$version_number.crx' version='$version_number' />
  </app>
</gupdate>
" | tee -a bin/updateChrome.xml

    ! rm -rf bin-chrome
    cp -vr bin bin-chrome
    mv -v $chrome_manifest_path bin-chrome/manifest.json
[[ -f bin-chrome.pem ]] && {
    ./crxmake.sh bin-chrome bin-chrome.pem

    mv -v bin-chrome.crx bin/assets/ngbp-mobile-angular-ui-$version_number.crx

# 
#     Launch chrome
# 
#     google-chrome --load-and-launch-app=ngbp-mobile-angular-ui &
#     google-chrome --app-id=$application_id
}
#     rm -rf bin-chrome
echo "All finished"

